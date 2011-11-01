//
//  Cell.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/28/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpaceLane.h"
#import "Planet.h"

@interface Cell : NSObject {
    Planet *planet;
    NSMutableArray *players;
    NSMutableDictionary *exits;
}


@property (readwrite, assign) Planet *planet;
@property (nonatomic, retain) NSMutableArray *players;
@property (nonatomic, retain) NSMutableDictionary *exits;

@end
