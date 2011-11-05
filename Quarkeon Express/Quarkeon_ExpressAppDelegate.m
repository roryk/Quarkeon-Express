//
//  Quarkeon_ExpressAppDelegate.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Quarkeon_ExpressAppDelegate.h"
#import "Quarkeon_ExpressViewController.h"
#import "GameState.h"
#import "GameCreator.h"
#import "Planet.h"
#import "Spacelane.h"
#import "PlayerSetupScreen.h"
#import "GameSetupScreen.h"
#import "MainMenu.h"


@implementation Quarkeon_ExpressAppDelegate

@synthesize window = _window;
@synthesize passGameVC = passGameVC;
@synthesize winScreenVC = winScreenVC;
@synthesize gameState;
@synthesize gameCreator;
@synthesize gameSetupVC = gameSetupVC;
@synthesize mainMenuVC = mainMenuVC;
@synthesize playerSetupVC = playerSetupVC;
@synthesize playGameVC = playGameVC;

- (void) movePlayer:(NSString *)dir {
    /**
     checks to see if a player can move in a direction. if so, subtracts the uranium from their cache
     and updates the current planet on the gamestate and the current planet on the player. 
     **/
    Cell *cell = gameState.currCell;
    Cell *newcell = [cell.exits objectForKey:dir];
    Player *player = gameState.currPlayer;
    if([cell hasLane:dir] && (player.uranium > 0)) {
        player.uranium -= 1;
        gameState.currCell = newcell;
        player.currLocation = gameState.currCell;
        [gameState.currCell.visitedBy addObject:(Player *)player];
    }
}

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

- (void) startGame
{

  
    [self.gameState setupTurnOrder];

}

- (void) addPlayerToGame:(NSString *)playerName
{
    [self.gameCreator addPlayer:self.gameCreator.defaultUranium playerName:playerName];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.gameState = [[GameState alloc] init];
    self.gameCreator = [[GameCreator alloc] initWithGameState:self.gameState];

    
    self.playGameVC = [[Quarkeon_ExpressViewController alloc] init];
    self.gameSetupVC = [[GameSetupScreen alloc] init];
    self.playerSetupVC = [[PlayerSetupScreen alloc] init];
    
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
