//
//  Cell.h
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
#import "SpaceLane.h"
#import "Planet.h"

@interface Cell : NSObject {
    NSMutableArray *exitnames;
    Planet *planet;
    NSMutableArray *players;
    NSMutableDictionary *exits;
    UIImage *picture;
    UIImage *defaultpicture;
}


@property (readwrite, retain) Planet *planet;
@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) NSMutableDictionary *exits;
@property (readwrite, assign) bool ongrid;
@property (nonatomic, retain) NSMutableArray *visitedBy;
@property (readwrite, retain) UIImage *picture;
@property (readwrite, retain) UIImage *defaultpicture;
@property (nonatomic, retain) NSMutableArray *exitnames;

- (bool) hasLane:(NSString *)dir;
- (void) addPlanet:(Planet *)newplanet;
- (void) delPlanet;
@end
