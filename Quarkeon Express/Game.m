//
//  Game.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "Planet.h"


@implementation Game

@synthesize maze;
@synthesize startPlanetID, endPlanetID;
@synthesize name;
@synthesize difficulty;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.maze = [NSMutableArray array];
    }
    
    return self;
}

-(Planet *)getPlanetByID:(int)pID
{
    for (Planet *planet in self.maze) {
        if (planet.planetID == pID){
            return planet;
        }
    }
    return nil;
}


@end
