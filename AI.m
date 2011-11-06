//
//  AI.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/5/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "AI.h"

@implementation AI

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
    
}

- (NSString *) chooseRandomDir {
    /**
     choose a random direction to go to
     **/
    int n;
    NSString *dir;
    n = arc4random() % [currLocation.exitnames count];
    dir = [currLocation.exitnames objectAtIndex:n];
    while([currLocation.exits valueForKey:dir] == [NSNull null]) {
        n = arc4random() % [currLocation.exitnames count];
        dir = [currLocation.exitnames objectAtIndex:n];
    }
    return(dir);
}

@end


@implementation DumbAI

-(id) init
{
    self = [super init];
    if(self) {
    }
    
    return self;
}

-(void)startTurn {
    [self playTurn];
}

-(void) playTurn {
    NSString *dir;
    Planet *planet;
    while(self.uranium > 0) {
        dir = [self chooseRandomDir];
        [self movePlayerInDirection:dir];
        planet = self.currLocation.planet;
        if(planet != nil && (planet.owner != self)) {
            if([self canBuyCurrPlanet]) {
                [self buyCurrPlanet];
            }
        }
    }
}

@end