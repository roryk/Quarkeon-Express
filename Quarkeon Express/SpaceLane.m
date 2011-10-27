//
//  SpaceLane.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpaceLane.h"
#import "Planet.h"

@implementation SpaceLane

@synthesize name;
@synthesize planets;
@synthesize challenge;
@synthesize beenTraveled;
@synthesize distance;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.beenTraveled = false;
        self.challenge = nil;
        self.planets = [[NSMutableArray alloc] init];
        self.distance = 0;
        
    }
    
    return self;
}

- (Planet *)getNextPlanet:(Planet *)planet {
    // this will not return the right value if there is more than two planets connecting
    if (![planets containsObject:planet]) {
        return nil;
    }
    if ([planets objectAtIndex:0] == planet) {
        return [planets objectAtIndex:1];
    }
    else {
        return [planets objectAtIndex:0];
    }
}

@end
