//
//  Planet.h
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

@class Challenge;
@class SpaceLane;
@class Player;

@interface Planet : NSObject {
    UIImage *picture;
    int type; // XXX should be an enum
    NSMutableArray *visitedBy;
    NSString *name;
    NSString *description;
    int planetID;
    int initialCost;
    int earnRate;
    int currentCost;
    Player *owner;

}

@property (readwrite, assign) int type;
@property (readwrite, assign) int planetID;
@property (readwrite, assign) int initialCost;
@property (readwrite, assign) int earnRate;
@property (readwrite, assign) int currentCost;

@property (nonatomic, retain) Player *owner;


@property (nonatomic, retain) NSMutableArray *visitedBy;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;


- (bool) hasVisited:(Player *)player;

@end
