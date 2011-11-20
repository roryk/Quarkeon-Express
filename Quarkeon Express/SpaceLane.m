//
//  SpaceLane.m
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
        self.planets = [NSMutableArray array];
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
