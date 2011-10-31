//
//  Cell.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/28/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize planet;
@synthesize players;
@synthesize exits;

- (id)init
{
    self = [super init];
    if (self) {
        self.exits = [[NSMutableDictionary alloc] init];
        [self.exits setObject:nil forKey:@"north"];
        [self.exits setObject:nil forKey:@"south"];
        [self.exits setObject:nil forKey:@"east"];
        [self.exits setObject:nil forKey:@"west"];
        self.planet = nil;
        self.players = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
