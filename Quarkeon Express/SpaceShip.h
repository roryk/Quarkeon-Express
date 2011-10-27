//
//  SpaceShip.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpaceShip : NSObject {
    int attack;
    int defend;
    int speed;
    int uraniumStorage;
    NSString *name;
    UIImage *picture;
    
}

@property (nonatomic, retain) NSString *name;
@property (readwrite, assign) int speed;
@property (readwrite, assign) int attack;
@property (readwrite, assign) int defend;
@property (readwrite, assign) int uraniumStorage;
@property (nonatomic, retain) UIImage *picture;



@end
