//
//  HelloWorldLayer.h
//  SpaceGame
//
//  Created by Sean T. Hammond on 11/8/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class SneakyJoystick;
@class SneakyButton;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCLayer *theGameLayer;
    CCLayer *theHUDLayer;
    SneakyJoystick *leftJoystick;
    SneakyButton *rightButton;
    CCSpriteBatchNode *theShipSpriteSheet;
    CCSprite *theShipSprite;
    NSMutableArray *theShipSpins;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
