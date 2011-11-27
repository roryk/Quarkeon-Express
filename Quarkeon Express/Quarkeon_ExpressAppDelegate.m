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
@synthesize playGameVC = playGameVC;
@synthesize loginVC = loginVC;
@synthesize pickMPGameVC = pickMPGameVC;
@synthesize myMultiplayerGames;
@synthesize QEClient;

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
    int requestStatus;

    NSMutableArray *playerEmailAddresses = [[NSMutableArray alloc] init];
    NSMutableDictionary *multiplayerGame = [[NSMutableDictionary alloc] init];
    for (Player *player in self.gameState.players) {
        [playerEmailAddresses addObject:player.name];
    }
    
    if (self.gameState.isMultiplayer) {
        GameCreator *gc = self.gameCreator;
        if ([self.gameState.mapSize isEqualToString:@"Small"]) {
            
            multiplayerGame = [QEClient createGame:playerEmailAddresses width:gc.smallMapSize height:gc.smallMapSize 
                   planetDensity:gc.smallMapPlanetPercentage meanUranium:gc.smallMapMeanPlanetTotalU 
                                meanPlanetLifetime:gc.smallMapMeanPlanetLifetime startingUranium:gc.smallMapStartingU 
                          status:&requestStatus];
            
            NSDictionary *gameMap = [multiplayerGame objectForKey:@"map"];
            NSMutableArray *planets = [multiplayerGame objectForKey:@"planets"];
            [gc makeFixedMapWithPlanets:[[gameMap objectForKey:@"width"] intValue] 
                                 height:[[gameMap objectForKey:@"height"] intValue] planets:planets];

            
        } else if ([self.gameState.mapSize isEqualToString:@"Medium"]) {
        } else {
        }
        
        
    } else {
        [self.gameState setupTurnOrder];
    }
}

- (bool) login:(NSString *)emailAddress password:(NSString *)password
{
    int requestStatus;
    [QEClient login:emailAddress password:password status:&requestStatus];
    if (requestStatus == 200) {
        NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [arrayPaths objectAtIndex:0];
        NSString* filePath = [docDirectory stringByAppendingPathComponent:@"myemail.txt"];
        [emailAddress writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        self.gameState.myEmailAddress = emailAddress;
        return true;
    }
    return false;
    
}

- (void) startMultiplayer
{
    int requestStatus;
    self.gameState.isMultiplayer = true;
    self.myMultiplayerGames = [QEClient getMyGames:&requestStatus]; // XXX we do this to see if we are logged in.
    
    if (!self.QEClient.isLoggedIn) {
        [self.window addSubview:self.loginVC.view];
    } else {
        self.myMultiplayerGames = [QEClient getMyGames:&requestStatus];
        NSLog(@"getMyGames requestStatus: %d\n", requestStatus);
        if ([myMultiplayerGames count] > 0) {
            [self.window addSubview:self.pickMPGameVC.view];
        } else {
            [self.window addSubview:self.gameSetupVC.view];

        }
    }
        
}

- (void) addPlayerToGame:(NSString *)playerName isAI:(bool)isAI
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
