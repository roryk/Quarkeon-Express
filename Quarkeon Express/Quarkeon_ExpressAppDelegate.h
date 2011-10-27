//
//  Quarkeon_ExpressAppDelegate.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Quarkeon_ExpressViewController;
@class WinScreenVC;
@class PassGameVC;
@class GameState;

@interface Quarkeon_ExpressAppDelegate : NSObject <UIApplicationDelegate> {
    GameState *gameState;
    UINavigationController *navController;
}

@property (nonatomic, retain) GameState *gameState;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Quarkeon_ExpressViewController *viewController;

@property (nonatomic, retain) IBOutlet WinScreenVC *winScreenVC;

@property (nonatomic, retain) IBOutlet PassGameVC *passGameVC;

- (void) movePlayer: (NSString *)dir;

@end
