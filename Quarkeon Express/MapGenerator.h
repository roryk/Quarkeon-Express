//
//  MapGenerator.h
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

@interface MapGenerator : NSObject {
    NSMutableArray *loadedPlanets;
    NSMutableArray *cells;
    int rows;
    int cols;
    int ncells;
    NSMutableDictionary *oppositeDirectionName;
    NSMutableArray *exitNames;
    NSMutableArray *usedPlanets;
    NSArray *backgroundImages;
}

@property (nonatomic, retain) NSMutableArray *cells;
@property (readwrite, assign) int rows;
@property (readwrite, assign) int cols;
@property (readwrite, assign) int ncells;
@property (nonatomic, retain) NSMutableDictionary *oppositeDirectionName;
@property (nonatomic, retain) NSMutableArray *exitNames;
@property (nonatomic, retain) NSMutableArray *loadedPlanets;
@property (nonatomic, retain) NSMutableArray *usedPlanets;
@property (nonatomic, retain) NSArray *backgroundImages;

- (int)getSouth:(int) x;
- (int)getNorth:(int) x;
- (int)getEast:(int) x;
- (int)getWest:(int) x;
- (NSString *)getRandomDirectionName;
- (int)getIndexInDirection:(int) x dir:(NSString *)dir;
- (bool)checkAndMove:(int) x planets:(int)planets max_planets:(int)max_planets;
- (NSMutableArray *)buildMap:(int) max_planets;
- (void)setSize:(int)x y:(int)y;
- (void)initCells;
- (void) initCellsWithCoords;
- (NSMutableArray *)buildMapWithPlanets:(NSMutableArray *)planets;

@end
