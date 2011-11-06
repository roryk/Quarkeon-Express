//
//  AI.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/5/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "Player.h"
#import "Quarkeon_ExpressAppDelegate.h"

@interface AI : Player {
    Quarkeon_ExpressAppDelegate *appDelegate;
}

-(void) move:(NSString *)dir;
@end


/**
 a dumb AI. it moves randomly and buys planets it can afford until it runs out of credits
 **/
@interface DumbAI : AI {
}
@end