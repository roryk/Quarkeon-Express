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
@synthesize gamestate;

- (id)init
{
    self = [super init];
    if (self) {
        self.gamestate = [[GameState alloc] init];
        self.cells = [NSMutableArray array];
        // Initialization code here.
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

- (void)makeRandomMap:(int)x y:(int)y max_planets:(int)max_planets {
    MapGenerator *mg = [[MapGenerator alloc] init];
    mg.loadedPlanets = [self loadPlanets];
    [mg setSize:x y:y];
    [mg buildMap:max_planets];
    self.gamestate.cells = mg.cells;
    self.gamestate.planets = mg.usedPlanets;
    [mg release];
}

- (void)addPlayer:(int)startingUranium playerName:(NSString *)playerName
{
    Player *newPlayer = [[Player alloc] init];
    newPlayer.uranium = startingUranium;
    newPlayer.name = playerName;
    // set the current location to be a random 
    int cellID = (arc4random() % [self.gamestate.cells count]);
    Cell *startCell = [self.gamestate.cells objectAtIndex:cellID];
    while(!startCell.ongrid) {
        cellID = (arc4random() % [self.gamestate.cells count]);
        startCell = [self.gamestate.cells objectAtIndex:cellID];
    }
    newPlayer.currLocation = startCell;
    [self.gamestate.players addObject:newPlayer];
    [newPlayer release];
    
}

- (void)startSampleGame
// this is just a sample game for the time being, replace this with a proper game when we 
// hook up the add player screens, game select screens, that sort of thing
{
    [self makeRandomMap:4 y:4 max_planets:7];
    // XXX we create two players here. 
    [self addPlayer:100 playerName:@"Foo"];
    [self addPlayer:100 playerName:@"Bar"];
    
    // shuffle the player array
    int playerCount = [self.gamestate.players count];
    for(int i = 0; i < playerCount; i++) {
        int elements = playerCount - i;
        int n = (arc4random() % elements) + i;
        [self.gamestate.players exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    // load the queue up
    for(Player *player in self.gamestate.players) {
        [self.gamestate.turnQueue enqueue:player];
    }
    // select the first player
    self.gamestate.currPlayer = [self.gamestate.turnQueue dequeue];
    self.gamestate.currCell = self.gamestate.currPlayer.currLocation;
}

@end