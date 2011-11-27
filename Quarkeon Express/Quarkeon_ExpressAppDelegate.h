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
@class PickMultiplayerGameViewController;
@class LoginViewController;
@class QEHTTPClient;

@interface Quarkeon_ExpressAppDelegate : NSObject <UIApplicationDelegate> {
    GameState *gameState;
    GameCreator *gameCreator;
    QEHTTPClient *QEClient;
    NSMutableArray *myMultiplayerGames;
    
    UINavigationController *navController;
}

@property (nonatomic, retain) NSMutableArray *myMultiplayerGames;

@property (nonatomic, retain) GameState *gameState;
@property (nonatomic, retain) GameCreator *gameCreator;

@property (nonatomic, retain) QEHTTPClient *QEClient;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Quarkeon_ExpressViewController *playGameVC;

@property (nonatomic, retain) IBOutlet WinScreenVC *winScreenVC;

@property (nonatomic, retain) IBOutlet PassGameVC *passGameVC;

@property (nonatomic, retain) IBOutlet MainMenu *mainMenuVC;

@property (nonatomic, retain) IBOutlet PlayerSetupScreen *playerSetupVC;

@property (nonatomic, retain) IBOutlet GameSetupScreen *gameSetupVC;

@property (nonatomic, retain) IBOutlet LoginViewController *loginVC;

@property (nonatomic, retain) IBOutlet PickMultiplayerGameViewController *pickMPGameVC;



- (void) addPlayerToGame:(NSString *)playerName isAI:(bool)isAI;
- (void) startGame;
- (void) generateMap;

- (bool) login:(NSString *)emailAddress password:(NSString *)password;
- (void) startMultiplayer;
- (void) loadMultiplayerGame:(int)gameId;


@end
