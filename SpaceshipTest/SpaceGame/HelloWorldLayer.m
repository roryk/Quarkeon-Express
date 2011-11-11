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
    //[self addChild:leftJoy z:10];
    [theHUDLayer addChild:leftJoy z:10];
}

-(void)update:(ccTime)deltaTime{
    CGPoint scaledVelocity=ccpMult(leftJoystick.velocity, 240);
    CGPoint newPosition=ccp(theShipSprite.position.x+scaledVelocity.x*deltaTime, theShipSprite.position.y+scaledVelocity.y*deltaTime);
    //theShipSprite.rotation=-leftJoystick.degrees;
    int whichShipFrame;
    //the joystick ends up providing mirror opposite degrees because the device has been rotated
    //it's also off by 90 degrees, again because of the rotation
    int j=90-leftJoystick.degrees;
    if (j<0){
        j=j+360;
    }
   
    
    whichShipFrame=j/10;
    //NSLog(@"%i", j);
    [theShipSprite setDisplayFrame:[theShipSpins objectAtIndex:whichShipFrame]];
    [theShipSprite setPosition:newPosition];
    [theGameLayer runAction:[CCFollow actionWithTarget:theShipSprite]];
    //theGameLayer.position=theShipSprite.position;
    //TODO: simulate inertia
    //      increase ship speed over time
    //      smooth turning of the ship
    //      stop jumping of sprite frame when joystick is released
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
        //[self addChild:thePlanet z:0];
        [theGameLayer addChild:thePlanet z:0];
        
        
        
        
        //read in the ship's spritesheet
        theShipSpriteSheet=[CCSpriteBatchNode batchNodeWithFile:@"ship-spritesheet.png"];
        [self addChild:theShipSpriteSheet];
        //create the ship sprite
        theShipSprite=[CCSprite spriteWithTexture:theShipSpriteSheet.texture rect:CGRectMake(0,0,64,64)];
        
        theShipSprite.position = ccp(theWindowSize.width/2, theWindowSize.height/2);//place the sprite in the center of the screen
        //[self addChild: theShipSprite];
        [theGameLayer addChild:theShipSprite];
        
        //this should center the camera on the ship
        //[self setCenterOfScreen:theShipSprite.position];
        
        //make the ship spin
        //theShipSpins=[NSMutableArray array];
        theShipSpins=[[NSMutableArray alloc] init];
        int frameCount = 0;
		for (int y = 0; y < 6; y++) {
			for (int x = 0; x < 6; x++) {
                CCSprite *theFrame = [CCSpriteFrame frameWithTexture:theShipSpriteSheet.texture  rect:CGRectMake(x*64,y*64,64,64)];
                [theShipSpins addObject:theFrame];
				frameCount++;				
				// stop looping after we've added 36 frames (6 by 6)
				if (frameCount == 36)
					break;
			}
		}
        
        [self initJoystick];
        [self scheduleUpdate];
        //CCAnimation *theShipSpinAnimation=[CCAnimation animationWithFrames:theShipSpins delay:0.1f];
        //// create the action
		//CCAnimate *theShipAction = [CCAnimate actionWithAnimation:theShipSpinAnimation];
		//CCRepeatForever *repeat = [CCRepeatForever actionWithAction:theShipAction];
		//// run the action
		//[theShipSprite runAction:repeat];
        
        
    }
    return self;
}


-(void) setCenterOfScreen:(CGPoint)position{
    //CGSize screenSize=[[CCDirector sharedDirector] winSize];
    self.position=theShipSprite.position;
}




//-(id) init
//{
//	// always call "super" init
//	// Apple recommends to re-assign "self" with the "super" return value
//	if( (self=[super init])) {
//        
//		// create and initialize a Label
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
//
//		// ask director the the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//	
//		// position the label on the center of the screen
//		label.position =  ccp( size.width /2 , size.height/2 );
//		
//		// add the label as a child to this Layer
//		[self addChild: label];
//	}
//	return self;
//}

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
