//
//  Quarkeon_ExpressAppDelegate.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "GameCreator.h"


@class Quarkeon_ExpressViewController;
@class WinScreenVC;
@class PassGameVC;
@class GameState;
@class MainMenu;
@class PlayerSetupScreen;
@class GameSetupScreen;
@class GameCreator;

@interface Quarkeon_ExpressAppDelegate : NSObject <UIApplicationDelegate> {
    GameState *gameState;
    GameCreator *gameCreator;
    
    UINavigationController *navController;
}

@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) GameCreator *gameCreator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Quarkeon_ExpressViewController *playGameVC;

@property (nonatomic, retain) IBOutlet WinScreenVC *winScreenVC;

@property (nonatomic, retain) IBOutlet PassGameVC *passGameVC;

@property (nonatomic, retain) IBOutlet MainMenu *mainMenuVC;

@property (nonatomic, retain) IBOutlet PlayerSetupScreen *playerSetupVC;

@property (nonatomic, retain) IBOutlet GameSetupScreen *gameSetupVC;



- (void) addPlayerToGame:(NSString *)playerName isAI:(bool)isAI;
- (void) startGame;
- (void) generateMap;


@end
