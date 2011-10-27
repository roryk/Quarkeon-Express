//
//  Player.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/21/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Spaceship;
@class Planet;

@interface Player : NSObject {
    NSString *name;
    Planet *currLocation;
    int xLocation;
    int yLocation;
    UIImage *picture;
    Spaceship *ship;
    int clones;
    int bucks;
    int uranium;
}

@property (readwrite, assign) int xLocation;
@property (readwrite, assign) int yLocation;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIImage *picture;
@property (readwrite, assign) Spaceship *ship;
@property (readwrite, assign) Planet *currLocation;

@property (readwrite, assign) int clones;
@property (readwrite, assign) int bucks;
@property (readwrite, assign) int uranium;

@end
