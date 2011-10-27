//
//  Player.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/21/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "Player.h"
#import "Planet.h"

@implementation Player

@synthesize name;
@synthesize xLocation, yLocation;
@synthesize picture;
@synthesize ship;
@synthesize clones, bucks, uranium;
@synthesize currLocation;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.currLocation = nil;
        self.name = nil;
        self.ship = nil;
    }
    
    return self;
}

@end
