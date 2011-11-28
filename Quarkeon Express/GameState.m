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
@synthesize isMultiplayer;
@synthesize myUserID, myEmailAddress;

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
        self.isMultiplayer = false;
        self.myUserID = -1;
        self.myEmailAddress = [[NSString alloc] init];
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


- (void)endTurn {
    /**
     end the turn of the current player by getting the next player and centering the view on their location
     XXX: should transition to a "pass game to XXX, so no spoilers regarding location"
     **/
    [self.turnQueue enqueue:self.currPlayer];
    [self.currPlayer endTurn];
    // XXX: add go to the no-spoiler screen
}

- (void)startTurn {
    self.currPlayer = [self.turnQueue dequeue];
    self.currCell = self.currPlayer.currLocation;
    [self.currPlayer startTurn];
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

- (void)gameOverCleanup {
    // XXX TO BE IMPLEMENTE
}

- (bool)canMove:(NSString *)dir {
    /**
     can the current player move in the direction 'dir'?
     **/
    return([currPlayer.currLocation hasLane:dir]);
}
@end
