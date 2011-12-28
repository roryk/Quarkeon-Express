//
//  Quarkeon_ExpressAppDelegate.m
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


#import "Quarkeon_ExpressAppDelegate.h"
#import "Quarkeon_ExpressViewController.h"
#import "GameState.h"
#import "GameCreator.h"
#import "Planet.h"
#import "Spacelane.h"
#import "PlayerSetupScreen.h"
#import "GameSetupScreen.h"
#import "MainMenu.h"
#import "LoginViewController.h"
#import "PickMultiplayerGameViewController.h"
#import "QEHTTPClient.h"


@implementation Quarkeon_ExpressAppDelegate

@synthesize window = _window;
@synthesize passGameVC = passGameVC;
@synthesize winScreenVC = winScreenVC;
@synthesize gameState;
@synthesize gameCreator;
@synthesize gameSetupVC = gameSetupVC;
@synthesize mainMenuVC = mainMenuVC;
@synthesize playerSetupVC = playerSetupVC;
@synthesize playGameVC;

- (void) generateMap
{
    
    GameCreator *gc = self.gameCreator;
    
    if ([self.gameState.mapSize isEqualToString:@"Small"]) {
        [gc makeRandomMap:gc.smallMapSize y:gc.smallMapSize max_planets:gc.smallMapMaxPlanets];
    } else if ([self.gameState.mapSize isEqualToString:@"Medium"]) {
        [gc makeRandomMap:gc.mediumMapSize y:gc.mediumMapSize max_planets:gc.mediumMapMaxPlanets];
    } else {
        [gc makeRandomMap:gc.largeMapSize y:gc.largeMapSize max_planets:gc.largeMapMaxPlanets];        
    }
    
}

- (void) loadMultiplayerGame:(int)gameId
{
    int requestStatus;
    NSMutableDictionary *multiplayerGame = [[NSMutableDictionary alloc] init];
    GameCreator *gc = self.gameCreator;
    multiplayerGame = [QEClient loadGame:gameId status:&requestStatus];
    // XXX we should check to see if we need to login here. 
    // XXX also, the views should be in a stack, so we can push the login, then
    // pop back to the active one.
    
    NSDictionary *gameMap = [multiplayerGame objectForKey:@"map"];
    NSMutableArray *planets = [multiplayerGame objectForKey:@"planets"];
    NSMutableArray *players = [multiplayerGame objectForKey:@"players"];
    [gc makeFixedMapWithPlanets:[[gameMap objectForKey:@"width"] intValue] 
                         height:[[gameMap objectForKey:@"height"] intValue] planets:planets];
    NSDictionary *gameDict = [multiplayerGame objectForKey:@"game"];
    
    for (Player *player in players) {
        if (player.pid == [[gameDict objectForKey:@"whose_turn"] intValue]) {
            
            self.gameState.currCell = [[self.gameState.cells objectAtIndex:player.xLocation] objectAtIndex:player.yLocation];
            self.gameState.currPlayer = player;
            player.currLocation = self.gameState.currCell;
            
            break;
            
        }
    }
}

- (void) startGame
{
    [self.gameState setupTurnOrder];
    [self.gameState setupTurn];
    [self.gameState startTurn];
}

-(void) addPlayerToGame:(NSString *)playerName isAI:(bool)isAI
{
    if (self.gameState.isMultiplayer) {
        [self.gameCreator addMultiplayerPlayer:playerName];
    } else {
        [self.gameCreator addPlayer:self.gameCreator.defaultUranium playerName:playerName isAI:isAI];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
   
    self.gameState = [[GameState alloc] init];
    self.gameCreator = [[GameCreator alloc] initWithGameState:self.gameState];
    
    self.QEClient = [[QEHTTPClient alloc] init];
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    NSString* filePath = [docDirectory stringByAppendingPathComponent:@"myemail.txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        self.gameState.myEmailAddress = fileContents;
        NSLog(@"%@", fileContents);
    }

    
    self.playGameVC = [[Quarkeon_ExpressViewController alloc] init];
    self.gameSetupVC = [[GameSetupScreen alloc] init];
    self.playerSetupVC = [[PlayerSetupScreen alloc] init];
    self.loginVC = [[LoginViewController alloc] init];
    self.pickMPGameVC = [[PickMultiplayerGameViewController alloc] init];
    
    self.window.rootViewController = self.mainMenuVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
