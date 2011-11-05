//
//  MapGenerator.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/28/11.
//  Copyright 2011 MIT. All rights reserved.
//

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

@end
