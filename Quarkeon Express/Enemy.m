//
//  Enemy.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

@synthesize name;
@synthesize wittyStatement;
@synthesize picture;
@synthesize attack, defend, hitPoints, lootType, lootAmount;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
