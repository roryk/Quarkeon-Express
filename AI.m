//
//  AI.m
//  Quarkeon Express
//
//   Copyright 2011 Rory Kirchner
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#import "Player.h"
#import "AI.h"
#import "GameState.h"
#import "Quarkeon_ExpressAppDelegate.h"
#import "Quarkeon_ExpressViewController.h"

@class Quarkeon_ExpressAppDelegate;

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
    NSString *dir = [NSString string];
    Planet *planet = [[Planet alloc] init];
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
    // fix this to trigger the button directly
    // something like this:
    // [button sendActionsForControlEvents:UIControlEventTouchUpInside]
    [appDelegate.playGameVC endTurn:nil];
}

@end