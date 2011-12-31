//
//  Quarkeon_ExpressAppDelegate.h
//  Quarkeon Express
//
//   Copyright 2011 Rory Kirchner
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

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
- (void) setupMultiplayerGameData:(NSMutableDictionary *)multiplayerGame;


@end
