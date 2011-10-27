//
//  GameState.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/21/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "GameState.h"
#import "Planet.h"
#import "Game.h"
#import "SpaceLane.h"
#import "Player.h"
#import "Queue.h"
#import <stdlib.h>

@implementation GameState

@synthesize currPlanet;
@synthesize planets;
@synthesize games;
@synthesize currentGame;
@synthesize currPlayer;
@synthesize players;
@synthesize turnQueue;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.planets = [[NSMutableArray alloc] init];
        self.players = [[NSMutableArray alloc] init];
        self.games = [[NSMutableArray alloc] init];
        self.turnQueue = [[NSMutableArray alloc] init];
        self.currPlayer = nil;
        self.currentGame = nil;
        self.currPlanet = nil;

    }

    return self;
}

- (NSMutableArray *)loadPlist:(NSString *)fileName rootKey:(NSString *)rootKey
{
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:rootKey ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        return nil;
    }
    NSMutableArray *plistData = [NSMutableArray arrayWithArray:[temp objectForKey:rootKey]];
    return plistData;

}

- (bool)loadPlanets
{
     
    NSLog(@"loading planets....");
    NSMutableArray *allPlanets = [self loadPlist:@"Planets.plist" rootKey:@"Planets"];
    int planetID = 0; // XXX adamf: we should find a better way to assign these. GUIDs in the plist?

    for (NSDictionary *planetDict in allPlanets) {    
        Planet *newPlanet = [[Planet alloc] init];
        newPlanet.name = [planetDict objectForKey:@"Name"];
        newPlanet.description = [planetDict objectForKey:@"Description"];
        newPlanet.picture = [planetDict objectForKey:@"Picture"];
        newPlanet.type = [[planetDict objectForKey:@"Type"] intValue];
        newPlanet.earnRate = [[planetDict objectForKey:@"Earn Rate"] intValue];
        newPlanet.initialCost = [[planetDict objectForKey:@"Cost"] intValue];
        newPlanet.currentCost = newPlanet.initialCost;
        newPlanet.planetID = planetID;
        [self.planets addObject:newPlanet];
        NSLog(@"loaded planet: %@", newPlanet.name);
    }
    
    return true;
}

- (bool) loadGames
{
    NSLog(@"loading games....");
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
            Planet *sourcePlanet = [self.planets objectAtIndex:planetID];
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
                
            }
        }
        [self.games addObject:newGame];
    }
    
    return true;
}


- (void)addPlayer:(int)startingUranium playerName:(NSString *)playerName
{
    Player *newPlayer = [[Player alloc] init];
    newPlayer.uranium = startingUranium;
    newPlayer.name = playerName;
    int planetID = (arc4random() % [self.planets count]);
    newPlayer.currLocation = [self.currentGame getPlanetByID:planetID];
    [self.players addObject:newPlayer];    
    
}

- (void)startGame:(Game *)game
{
    
    self.currentGame = game;
    self.currPlanet = [self.currentGame getPlanetByID:self.currentGame.startPlanetID];
    // XXX we create two players here. 
    [self addPlayer:100 playerName:@"Foo"];
    [self addPlayer:100 playerName:@"Bar"];

    // shuffle the player array
    int playerCount = [self.players count];
    for(int i = 0; i < playerCount; i++) {
        int elements = playerCount - i;
        int n = (arc4random() % elements) + i;
        [self.players exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    // load the queue up
    for(player in self.players) {
        [self.turnQueue enqueue:player];
    }
    // select the first player
    self.currPlayer = [self.turnQueue dequeue];

}

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
    self.currPlanet = self.currPlayer.currLocation;
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
    int owned = 0;
    // XXX: this isn't working for some reasona
    for(Planet *planet in self.planets) {
        if(planet.owner == self.currPlayer) {
            owned = owned + 1;
        }
    }
    return (owned > ([self.planets count] / 2));
}

- (bool)canBuyCurrPlanet
{
    if (self.currPlayer.currLocation.currentCost <= self.currPlayer.uranium) {
        return true;
    }
    return false;
    
}

- (bool)buyCurrPlanet   
{
    if ([self canBuyCurrPlanet]) {
        self.currPlayer.uranium = self.currPlayer.uranium - self.currPlanet.currentCost;
        self.currPlanet.owner = self.currPlayer;
        self.currPlayer.currLocation.currentCost = self.currPlayer.currLocation.currentCost * 1.5;
        return true;
    }
    
    return false;
}

- (void)gameOverCleanup {
    // XXX TO BE IMPLEMENTE
}

@end
