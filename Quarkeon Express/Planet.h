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
    Challenge *challenge;
    SpaceLane *north;
    SpaceLane *south;
    SpaceLane *east;
    SpaceLane *west;
    int type; // XXX should be an enum
    NSMutableArray *visitedBy;
    NSString *name;
    NSString *description;
    int planetID;
    int initialCost;
    int earnRate;
    int currentCost;
    Player *owner;
    
    /* 
     -- Background image
     -- challenge *Challenge (or null)
     -- North * spaceLane (or null)
     -- South * spaceLane (or null)
     -- east * spaceLane (or null)
     -- west * spaceLane (or null)
     -- type (explore, mine, shop, goal, start)
     -- boolean beenHereBefore
     -- name
     */
}

@property (readwrite, assign) int type;
@property (readwrite, assign) int planetID;
@property (readwrite, assign) int initialCost;
@property (readwrite, assign) int earnRate;
@property (readwrite, assign) int currentCost;

@property (nonatomic, retain) Player *owner;

@property (nonatomic, retain) Challenge *challenge;
@property (nonatomic, retain) SpaceLane *north;
@property (nonatomic, retain) SpaceLane *south;
@property (nonatomic, retain) SpaceLane *east;
@property (nonatomic, retain) SpaceLane *west;
@property (nonatomic, retain) NSMutableArray *visitedBy;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;


- (bool) hasLane:(NSString *)lane;
- (SpaceLane *) getLane:(NSString *)lane;
- (bool) hasVisited:(Player *)player;

@end
