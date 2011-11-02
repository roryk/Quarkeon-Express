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
        self.exits = [NSMutableDictionary dictionary];
        [self.exits setObject:[NSNull null] forKey:@"north"];
        [self.exits setObject:[NSNull null] forKey:@"south"];
        [self.exits setObject:[NSNull null] forKey:@"east"];
        [self.exits setObject:[NSNull null] forKey:@"west"];
        self.planet = nil;
        self.players = [NSMutableArray array];
    }
    
    return self;
}

- (void) dealloc {
    [super dealloc];
}
@end
