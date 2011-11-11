//
//  ship.h
//  SpaceGame
//
//  Created by Sean T. Hammond on 11/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShipObject : CCSprite {
    NSString *name;
    int mass;
    int thrust;
    int turnSpeed;
    int maxSpeed;
    int cargoSpace;
    int outfitSpace;
    int weaponSpace;
    int maxFuel;
    int currentFuel;
    int crew;
    CGPoint velocity;
    CCSpriteBatchNode *theShipSpriteSheet;
    int currentSpriteFrame;
    NSMutableArray *spriteFrames;
}

@property (nonatomic, retain) NSString *name;
@property (readwrite, assign) int mass;
@property (readwrite, assign) int thrust;
@property (readwrite, assign) int turnSpeed;
@property (readwrite, assign) int maxSpeed;
@property (readwrite, assign) int cargoSpace;
@property (readwrite, assign) int outfitSpace;
@property (readwrite, assign) int weaponSpace;
@property (readwrite, assign) int maxFuel;
@property (readwrite, assign) int currentFuel;
@property (readwrite, assign) int crew;
@property (readwrite, assign) CGPoint velocity;
@property (nonatomic, retain) CCSpriteBatchNode *theShipSpriteSheet;
@property (readwrite, assign) NSMutableArray *spriteFrames;
@property int currentSpriteFrame;

@end
