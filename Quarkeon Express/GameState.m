//
//  GameState.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/21/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "GameState.h"
#import "Planet.h"
#import "SpaceLane.h"
#import "Player.h"
#import "Queue.h"
#import <stdlib.h>

@implementation GameState

@synthesize currPlayer;
@synthesize players;
@synthesize turnQueue;
@synthesize cells;
@synthesize currCell;
@synthesize planets;
@synthesize numPlayers;
@synthesize mapSize;

- (id)init
{
    self = [super init];
    if (self) {
        self.players = [NSMutableArray array];
        self.turnQueue = [NSMutableArray array];
        self.cells = [NSMutableArray array];
        self.currPlayer = nil;
        self.currCell = nil;
        self.mapSize = [[NSString alloc] init];
        self.planets = [NSMutableArray array];
    }

    return self;
}

- (void)setupTurnOrder 
{
    // shuffle the player array
    int playerCount = [self.players count];
    for(int i = 0; i < playerCount; i++) {
        int elements = playerCount - i;
        int n = (arc4random() % elements) + i;
        [self.players exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    // load the queue up
    for(Player *player in self.players) {
        [self.turnQueue enqueue:player];
    }
    // select the first player
    self.currPlayer = [self.turnQueue dequeue];
    self.currCell = self.currPlayer.currLocation;
}


/**
- (bool) loadGames
{
    NSLog(@"loading games....");
    NSMutableArray *sourcePlanets = [self loadPlanets];
    NSMutableArray *allGames = [self loadPlist:@"Games.plist" rootKey:@"Games"];
    // XXX adamf: this has to load after we've loaded the planets, since we use the index into the planet
    // array. This is bad idea, but we do it anyways to get the game going.
    // all these load functions should move to a gameLoader class, and not be in the state class.
    for (NSDictionary *gamesDict in allGames) {
        Game *newGame = [[Game alloc] init];
        newGame.name = [gamesDict objectForKey:@"Name"];
        newGame.difficulty = [gamesDict objectForKey:@"Difficulty"];
        newGame.startPlanetID = [[gamesDict objectForKey:@"Start Planet ID"] intValue];
        newGame.endPlanetID = [[gamesDict objectForKey:@"End Planet ID"] intValue];
        NSMutableArray *maze = [gamesDict objectForKey:@"Maze"];
        // first just get the planet IDs we are connected to
        // then we'll make another pass after all the planets are copied where we 
        // link the planets
        for (NSDictionary *planetsDict in maze) {
            int planetID = [[planetsDict objectForKey:@"Planet ID"] intValue];
            Planet *newPlanet = [[Planet alloc] init];
            Planet *sourcePlanet = [sourcePlanets objectAtIndex:planetID];
            // XXX should implement NSCopying protocol on Planet, in case we need to copy it elsewhere
            newPlanet.type = sourcePlanet.type;
            newPlanet.name = sourcePlanet.name;
            newPlanet.description = sourcePlanet.description;
            newPlanet.picture = sourcePlanet.picture;
            newPlanet.planetID = planetID;
            newPlanet.initialCost = sourcePlanet.initialCost;
            newPlanet.currentCost = sourcePlanet.currentCost;
            newPlanet.earnRate = sourcePlanet.earnRate;
            [newGame.maze addObject:newPlanet];
            [newPlanet release];
        }
        
        for (NSDictionary *planetsDict in maze) {
            int srcPlanetID = [[planetsDict objectForKey:@"Planet ID"] intValue];
            Planet *srcPlanet = [newGame getPlanetByID:srcPlanetID];
            
            NSMutableArray *connections = [planetsDict objectForKey:@"Connections"];
            for (NSDictionary *connection in connections) {
                
                SpaceLane *newLane = [[SpaceLane alloc] init];
                int dstPlanetID = [[connection objectForKey:@"Planet ID"] intValue];
                Planet *dstPlanet = [newGame getPlanetByID:dstPlanetID];
                
                [newLane.planets addObject:srcPlanet];
                [newLane.planets addObject:dstPlanet];
                newLane.distance = [[connection objectForKey:@"Cost"] intValue];

                NSString *dir = [connection objectForKey:@"Direction"];
                
                if ([dir isEqualToString:@"North"]) {
                    srcPlanet.north = newLane;
                } else if ([dir isEqualToString:@"South"]) {
                    srcPlanet.south = newLane;
                } else if ([dir isEqualToString:@"East"]) {
                    srcPlanet.east = newLane;
                } else if ([dir isEqualToString:@"West"]) {
                    srcPlanet.west = newLane;
                }
                [newLane release];
            }
        }
        [self.games addObject:newGame];
        [newGame release];
    }
    
    return true;
}
**/

- (void)endTurn {
    /**
     end the turn of the current player by getting the next player and centering the view on their location
     XXX: should transition to a "pass game to XXX, so no spoilers regarding location"
     **/
    [self.turnQueue enqueue:self.currPlayer];
    // XXX: add go to the no-spoiler screen
}

- (void)startTurn {
    self.currPlayer = [self.turnQueue dequeue];
    self.currCell = self.currPlayer.currLocation;
    // XXX: accrue the uranium this isn't working for some reason
    for(Planet *planet in self.planets) {
        NSLog(@"planet: %@", planet);
        NSLog(@"owner: %@", planet.owner);
        NSLog(@"player: %@", self.currPlayer);
        if(planet.owner == self.currPlayer) {
            NSLog(@"a planet is owned.");
            self.currPlayer.uranium += planet.earnRate;
        }
    }
}

- (bool) didCurrentPlayerWin {
    return (self.currPlayer.planetsOwned > ([self.planets count] / 2));
}

- (bool)canBuyCurrPlanet
{
    if(self.currPlayer.currLocation.planet == nil) {
        return false;
    }
    if (self.currPlayer.currLocation.planet.currentCost <= self.currPlayer.uranium) {
        return true;
    }
    return false;
    
}

- (bool)buyCurrPlanet   
{
    if(self.currCell.planet == nil) {
        return false;
    }
    if ([self canBuyCurrPlanet]) {
        Planet *planet = self.currCell.planet;
        if (planet.owner != nil) {
            planet.owner.planetsOwned = planet.owner.planetsOwned - 1;
        }
        self.currPlayer.uranium = self.currPlayer.uranium - planet.currentCost;
        planet.owner = self.currPlayer;
        planet.currentCost = planet.currentCost * 1.5;
        self.currPlayer.planetsOwned = self.currPlayer.planetsOwned + 1;
        
        return true;
    }
    
    return false;
}

- (void)gameOverCleanup {
    // XXX TO BE IMPLEMENTE
}

@end
