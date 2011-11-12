//
//  HelloWorldLayer.m
//  SpaceGame
//
//  Created by Sean T. Hammond on 11/8/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyButton.h"
#import "ColoredCircleSprite.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)initJoystick{
    //insert the joystick to the left
    SneakyJoystickSkinnedBase *leftJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    leftJoy.position = ccp(64,64);
    leftJoy.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:64];
    leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:32];
    leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
    leftJoystick = [leftJoy.joystick retain];
    [theHUDLayer addChild:leftJoy z:10];
}

-(void)update:(ccTime)deltaTime{
    CGPoint scaledVelocity=ccpMult(leftJoystick.velocity, 240);
    if (leftJoystick.isActive){
        playerShip.velocity=scaledVelocity;
    }
    CGPoint newPosition=ccp(playerShip.position.x+playerShip.velocity.x*deltaTime, playerShip.position.y+playerShip.velocity.y*deltaTime);

    //the joystick ends up providing mirror opposite degrees because the device has been rotated
    //it's also off by 90 degrees, again because of the rotation
    int j=90-leftJoystick.degrees;
    if (j<0){
        j=j+360;
    }
   
    int whichShipFrame;
    whichShipFrame=j/10;
    //NSLog(@"%i", whichShipFrame);
    if (leftJoystick.isActive){
        [playerShip setDisplayFrame:[playerShip.spriteFrames objectAtIndex:whichShipFrame]];
    }
    [playerShip setPosition:newPosition];
    [theGameLayer runAction:[CCFollow actionWithTarget:playerShip]];

    //TODO: simulate inertia
    //      increase ship speed over time
    //      smooth turning of the ship
    //      ship acceleration should be related to mass
    
}

// on "init" you need to initialize your instance
-(id) init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    if( (self=[super init])) {
        theGameLayer= [CCLayer node];
        theHUDLayer=[CCLayer node];
        [self addChild:theGameLayer z:0];
        [self addChild:theHUDLayer z:100];
        self.isTouchEnabled=YES;

        CGSize theWindowSize = [[CCDirector sharedDirector] winSize];//how big is the screen?
        
        //place a planet
        CCSprite *thePlanet = [CCSprite spriteWithFile:@"test.jpg"];
        thePlanet.position=ccp(0,0);
        CCSprite *aStation = [CCSprite spriteWithFile:@"testSat.png"];
        aStation.anchorPoint=ccp(0,0);
        aStation.position=ccp(200,200);
        [theGameLayer addChild:thePlanet z:0];
        [theGameLayer addChild:aStation z:1];
        
        
        
        theShipSpriteSheet=[CCSpriteBatchNode batchNodeWithFile:@"ship-spritesheet.png"];//read in the ship's spritesheet
        playerShip=[ShipObject spriteWithTexture:theShipSpriteSheet.texture rect:CGRectMake(0,0,64,64)];//set the ship image to the first frame
        playerShip.position = ccp(theWindowSize.width/2, theWindowSize.height/2);//place the sprite in the center of the screen
        playerShip.spriteFrames=[[NSMutableArray alloc] init];
        int frameCount = 0;
		for (int y = 0; y < 6; y++) {
			for (int x = 0; x < 6; x++) {
                CCSprite *theFrame = [CCSpriteFrame frameWithTexture:theShipSpriteSheet.texture  rect:CGRectMake(x*64,y*64,64,64)];
                [playerShip.spriteFrames addObject:theFrame];
				frameCount++;				
				// stop looping after we've added 36 frames (6 by 6)
				if (frameCount == 36)
					break;
			}
		}
        [theGameLayer addChild:playerShip];

        [self initJoystick];
        [self scheduleUpdate];

        
        
    }
    return self;
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
