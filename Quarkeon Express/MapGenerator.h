//
//  MapGenerator.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/28/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapGenerator : NSObject {
    NSMutableArray *cells;
    int rows;
    int cols;
    int ncells;
}

- (void)setSize:(int)x y:(int)y;

@property (nonatomic, retain) NSMutableArray *cells;
@property (readwrite, assign) int rows;
@property (readwrite, assign) int cols;
@property (readwrite, assign) int ncells;

- (int)getSouth:(int) x;
- (int)getNorth:(int) x;
- (int)getEast:(int) x;
- (int)getWest:(int) x;
- (NSString *)getRandomDirection;
- (int)getDirection:(int) x dir:(NSString *)dir;
- (NSString *)getOppositeDirection:(NSString *)dir;

@end
