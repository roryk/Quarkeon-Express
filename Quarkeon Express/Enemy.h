//
//  Enemy.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enemy : NSObject {
/* 
 Enemy:
 -- hit points
 -- attack score
 -- defend score
 -- name
 -- defend
 -- lootType
 -- lootAmount
 -- wittyStatement
 -- image
 */
    int hitPoints;
    int attack;
    int defend;
    int lootAmount;
    int lootType; // XXX should be an enum
    NSString *name;
    NSString *wittyStatement;
    UIImage *picture;
    
}

@property (readwrite, assign) int hitPoints;
@property (readwrite, assign) int attack;
@property (readwrite, assign) int defend;
@property (readwrite, assign) int lootAmount;
@property (readwrite, assign) int lootType;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *wittyStatement;


@end
