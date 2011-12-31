//
//  SpaceLane.h
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

#import <Foundation/Foundation.h>

@class Planet;
@class Challenge;

@interface SpaceLane : NSObject {
    int distance;
    NSMutableArray *planets;
    NSString *name;
    bool beenTraveled;
    Challenge *challenge;
    
    /* 
     -- distance (in energy bucks)
     -- planet pair *planet[]
     -- name
     -- boolean beenTraveled
     -- challenge *Challenge (or null)
     */
}

@property (readwrite, assign) int distance;
@property (readwrite, assign) bool beenTraveled;
@property (nonatomic, retain) Challenge *challenge;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *planets;

- (Planet *)getNextPlanet:(Planet *)planet;
@end
