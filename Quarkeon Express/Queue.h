//
//  Queue.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/20/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Queue)
- (id) dequeue;
- (void) enqueue:(id)object;
- (id) getHead;
@end
