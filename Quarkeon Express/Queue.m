//
//  Queue.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/20/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "Queue.h"

@implementation NSMutableArray(Queue)
- (id) dequeue {
    id head = [self objectAtIndex:0];
    if (head != nil) {
        [[head retain] autorelease];
        [self removeObjectAtIndex:0];
    }
    return head;
}

- (void) enqueue:(id)obj {
    [self addObject:obj];
}
@end