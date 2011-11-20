//
//  Cell.m
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

#import "Cell.h"

@implementation Cell

@synthesize planet;
@synthesize players;
@synthesize exits;
@synthesize ongrid;
@synthesize visitedBy;
@synthesize picture;
@synthesize defaultpicture;
@synthesize exitnames;

- (id)init
{
    self = [super init];
    if (self) {
        self.exits = [NSMutableDictionary dictionary];
        [self.exits setObject:[NSNull null] forKey:@"north"];
        [self.exits setObject:[NSNull null] forKey:@"south"];
        [self.exits setObject:[NSNull null] forKey:@"east"];
        [self.exits setObject:[NSNull null] forKey:@"west"];
        self.planet = nil;
        self.players = [NSMutableArray array];
        self.ongrid = false;
        self.visitedBy = [NSMutableArray array];
        self.picture = nil;
        self.defaultpicture = nil;
        self.exitnames = [NSMutableArray array];
        for(NSString *key in exits) {
            [exitnames addObject:key];
        }
    }
    
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (bool) hasLane:(NSString *)dir {
    return(!([self.exits objectForKey:dir] == [NSNull null]));
}

- (void) addPlanet:(Planet *)newplanet {
    if(!self.planet) {
        self.planet = newplanet;
        self.picture = planet.picture;
    }
}

- (void) delPlanet {
    if(self.planet) {
        [self.planet release];
        [self.picture release];
        self.planet = nil;
        self.picture = self.defaultpicture;
    }
}
@end
