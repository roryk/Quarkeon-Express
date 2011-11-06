//
//  AI.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/5/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "Player.h"

@interface AI : Player {
}

-(NSString *)chooseRandomDir;

@end


/**
 a dumb AI. it moves randomly and buys planets it can afford until it runs out of credits
 **/
@interface DumbAI : AI {
}

-(void)playTurn;

@end