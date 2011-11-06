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
        appDelegate = (Quarkeon_ExpressAppDelegate *)[[UIApplication sharedApplication] delegate];    
    }
    
    return self;
    
}

- (void) move:(NSString *)dir {
    /**
     invoke the app delegate to move us in the direction dir, if possible
     **/
    if([appDelegate.gameState canMove:dir]) {
        [appDelegate movePlayer:dir];
    }
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

@end