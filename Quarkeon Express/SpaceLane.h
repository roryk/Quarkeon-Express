//
//  SpaceLane.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Planet;
@class Challenge;

@interface SpaceLane : NSObject {
    int distance;
    NSMutableArray *planets;
    NSString *name;
    bool beenTraveled;
    Challenge *challenge;
    
    /* 
     -- distance (in energy bucks)
     -- planet pair *planet[]
     -- name
     -- boolean beenTraveled
     -- challenge *Challenge (or null)
     */
}

@property (readwrite, assign) int distance;
@property (readwrite, assign) bool beenTraveled;
@property (nonatomic, retain) Challenge *challenge;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *planets;

- (Planet *)getNextPlanet:(Planet *)planet;
@end
