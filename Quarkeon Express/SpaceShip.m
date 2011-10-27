//
//  SpaceShip.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpaceShip.h"

@implementation SpaceShip

@synthesize name;
@synthesize picture;
@synthesize attack, defend, speed, uraniumStorage;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
