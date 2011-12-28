//
//  MultiplayerGame.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 11/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiplayerGame : NSObject

@property (readwrite, assign) int numPlayers;
@property (readwrite, assign) int gameID;
@property (nonatomic, retain) NSString *name;

@end
