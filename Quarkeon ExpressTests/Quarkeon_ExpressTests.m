//
//  Quarkeon_ExpressTests.m
//  Quarkeon ExpressTests
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Quarkeon_ExpressTests.h"
#import "Queue.h"

@implementation Quarkeon_ExpressTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.

}
- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testQueue
{
    NSMutableArray *queue;
    id first;
    id second;
    
    [queue enqueue:first];
    [queue enqueue:second];
    STAssertTrue([queue dequeue] == first, @"Queue failed at first dequeue.");
    STAssertTrue([queue dequeue] == second, @"Queue failed at second dequeue.");
    STAssertTrue([queue dequeue] == nil, @"Queue failed at dequeuing empty queue.");
}

- (void)testMapGenerator {
    // XXX implement the test
    // generate a 4x4 map with 7 planets
    // look at all of the cells make sure you hae 7 planets total
    // make sure you can get to each planet
    // do this by starting at a random planet and going to all 
    // neighbors, recursively adding to a 'saw this planet' array
    // after 15 iterations you should have visited every cell
    // return true if all have been visited, false if not
    

}
@end