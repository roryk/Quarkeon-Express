//
//  Planet.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
    int x;
    int y;
    Player *owner;

}

@property (readwrite, assign) int type;
@property (readwrite, assign) int planetID;
@property (readwrite, assign) int initialCost;
@property (readwrite, assign) int earnRate;
@property (readwrite, assign) int currentCost;
@property (readwrite, assign) int x;
@property (readwrite, assign) int y;


@property (nonatomic, retain) Player *owner;


@property (nonatomic, retain) NSMutableArray *visitedBy;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;


- (bool) hasVisited:(Player *)player;

@end
