//
//  Game.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Planet;

@interface Game : NSObject {
    NSString *name;
    NSString *difficulty;
    int startPlanetID;
    int endPlanetID;
    NSMutableArray *maze;
    
}

@property (nonatomic, retain) NSMutableArray *maze;
@property (readwrite, assign) int startPlanetID;
@property (readwrite, assign) int endPlanetID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *difficulty;

-(Planet *)getPlanetByID:(int)pID;

@end
