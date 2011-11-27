//
//  GameCreator.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/2/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "GameCreator.h"

@implementation GameCreator

@synthesize cells;
@synthesize gameState;
@synthesize mg;
@synthesize defaultUranium;
@synthesize largeMapSize, mediumMapSize, smallMapSize;
@synthesize largeMapMaxPlanets, mediumMapMaxPlanets, smallMapMaxPlanets;
@synthesize largeMapStartingU, mediumMapStartingU, smallMapStartingU;
@synthesize largeMapMeanPlanetTotalU, mediumMapMeanPlanetTotalU, smallMapMeanPlanetTotalU;
@synthesize largeMapMeanPlanetLifetime, mediumMapMeanPlanetLifetime, smallMapMeanPlanetLifetime;
@synthesize largeMapPlanetPercentage, mediumMapPlanetPercentage, smallMapPlanetPercentage;

- (id) initWithGameState:(GameState *)gs
{
    self = [super init];
    if (self) {
        self.gameState = gs;
        self.cells = [NSMutableArray array];
        // Initialization code here.
        
        // single player defaults
        self.defaultUranium = 100;
        
        self.largeMapSize = 10;
        self.largeMapMaxPlanets = 50;
        
        self.mediumMapSize = 7;
        self.mediumMapMaxPlanets = 25;
        
        self.smallMapSize = 4;
        self.smallMapMaxPlanets = 7;
        
        // multiplayer defaults
        self.largeMapMeanPlanetLifetime = 100;
        self.mediumMapMeanPlanetLifetime = 50;
        self.smallMapMeanPlanetLifetime = 25;
        
        self.largeMapMeanPlanetTotalU = 1000;
        self.mediumMapMeanPlanetTotalU = 750;
        self.smallMapMeanPlanetTotalU = 500;
        
        self.largeMapStartingU = 4000;
        self.mediumMapStartingU = 3000;
        self.smallMapStartingU = 2000;
            
        self.largeMapPlanetPercentage = 50;
        self.mediumMapPlanetPercentage = 40;
        self.smallMapPlanetPercentage = 30;
        
        // various generators & loaders
        self.mg = [[MapGenerator alloc] init];
        self.mg.loadedPlanets = [self loadPlanets];
    }
    
    return self;
}

- (NSMutableArray *)loadPlist:(NSString *)fileName rootKey:(NSString *)rootKey
{
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:rootKey ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        return nil;
    }
    NSMutableArray *plistData = [NSMutableArray arrayWithArray:[temp objectForKey:rootKey]];
    return plistData;
    
}

- (NSMutableArray *)loadPlanets
{
    
    NSLog(@"loading planets....");
    NSMutableArray *newPlanets = [NSMutableArray array];
    NSMutableArray *plistPlanets = [self loadPlist:@"Planets.plist" rootKey:@"Planets"];
    int planetID = 0; // XXX adamf: we should find a better way to assign these. GUIDs in the plist?
    
    for (NSDictionary *planetDict in plistPlanets) {    
        Planet *newPlanet = [[Planet alloc] init];
        newPlanet.name = [planetDict objectForKey:@"Name"];
        newPlanet.description = [planetDict objectForKey:@"Description"];
        NSString *imagePath = [NSString stringWithString:[planetDict objectForKey:@"Picture"]];
        if ([imagePath isEqualToString:@""]) {
            imagePath = @"Nu Earth.jpg";
        }
        newPlanet.picture = [UIImage imageNamed:imagePath];
        newPlanet.type = [[planetDict objectForKey:@"Type"] intValue];
        newPlanet.earnRate = [[planetDict objectForKey:@"Earn Rate"] intValue];
        newPlanet.initialCost = [[planetDict objectForKey:@"Cost"] intValue];
        newPlanet.currentCost = newPlanet.initialCost;
        newPlanet.planetID = planetID;
        [newPlanets addObject:newPlanet];
        NSLog(@"loaded planet: %@", newPlanet.name);
        [newPlanet release];
    }
    
    return newPlanets;
}

- (void)makeFixedMapWithPlanets:(int)width height:(int)height planets:(NSMutableArray *)planets
{
    [self.mg setSize:width y:height];
    self.mg.backgroundImages = [self loadBackgrounds];
    [self.mg initCellsWithCoords];
    [self.mg buildMapWithPlanets:planets];
    self.gameState.cells = self.mg.cells;
    self.gameState.planets = self.mg.usedPlanets;
    
}
- (void)makeRandomMap:(int)x y:(int)y max_planets:(int)max_planets {
    [self.mg setSize:x y:y];
    self.mg.backgroundImages = [self loadBackgrounds];
    [self.mg initCells];
    [self.mg buildMap:max_planets];
    self.gameState.cells = self.mg.cells;
    self.gameState.planets = self.mg.usedPlanets;
}

- (void)addPlayer:(int)startingUranium playerName:(NSString *)playerName isAI:(bool)isAI
{
    /**
     XXX we should break up this function into pieces since we are now going to be
     adding different types of players (different AI types, possibly network players,
     etc
     **/
    Player *newPlayer;
    
    if(isAI) {
        newPlayer = [[DumbAI alloc] init];
    }
    else {
        newPlayer = [[Player alloc] init];
    }
    newPlayer.uranium = startingUranium;
    // XXX adamf i think we need to copy this string...
    newPlayer.name = playerName;
    // set the current location to be a random 
    int cellID = (arc4random() % [self.gameState.cells count]);
    Cell *startCell = [self.gameState.cells objectAtIndex:cellID];
    while(!startCell.ongrid) {
        cellID = (arc4random() % [self.gameState.cells count]);
        startCell = [self.gameState.cells objectAtIndex:cellID];
    }
    newPlayer.currLocation = startCell;
    [self.gameState.players addObject:newPlayer];
    [newPlayer release];
    
}

- (void)addMultiplayerPlayer:(NSString *)emailAddress
{
    Player *newPlayer = [[Player alloc] init];
    newPlayer.name = [[NSString alloc] initWithString:emailAddress];
    [self.gameState.players addObject:newPlayer];
    [newPlayer release];

}

- (void)startSampleGame
// this is just a sample game for the time being, replace this with a proper game when we 
// hook up the add player screens, game select screens, that sort of thing
{
    [self makeRandomMap:4 y:4 max_planets:7];
    // XXX we create two players here. 
    [self addPlayer:100 playerName:@"Foo" isAI:false];
    [self addPlayer:100 playerName:@"Bar" isAI:false];
    
    [self.gameState setupTurnOrder];
}

- (NSArray *)loadBackgrounds {
    UIImage *image;
    NSMutableArray *backgroundImages = [NSMutableArray array];
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundleRoot error:nil];
    
    NSArray *backgroundFiles = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.png' AND self CONTAINS 'stars'"]];
    
    for(NSString *file in backgroundFiles) {
        image = [UIImage imageNamed:file];
        [backgroundImages addObject:image];
        [image release];
    }
    return(backgroundImages);
}

@end
