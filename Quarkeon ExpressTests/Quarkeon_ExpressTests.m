//
//  Quarkeon_ExpressTests.m
//  Quarkeon ExpressTests
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Quarkeon_ExpressTests.h"
#import "Queue.h"
#import "MapGenerator.h"
#import "Cell.h"
#import "GameCreator.h"

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
    // generate a 4x4 map with 6 planets done
    // look at all of the cells make sure you hae 6 planets total done
    // make sure you can get to each planet
    // do this by starting at a random planet and going to all 
    // neighbors, recursively adding to a 'saw this planet' array
    // after 15 iterations you should have visited every cell
    // return true if all have been visited, false if not
    MapGenerator *mg = [[MapGenerator alloc] init];
    [mg setSize:4 y:4];
    GameCreator *gc = [[GameCreator alloc] init];
    mg.loadedPlanets = [gc loadPlanets];
    int max_planets = 6;
    [mg buildMap:max_planets];
    NSLog(@"Successfully built a 4x4 map with 6 planets.");
    NSMutableArray *planets = [[NSMutableArray alloc] init];
    for(Cell *cell in mg.cells) {
        if(cell.planet != nil) {
            [planets addObject:cell];
        }
    }
    // make sure we put in the correct number of planets
    STAssertTrue([planets count] == max_planets, @"did not add the correct total number of planets.");
    
    // make sure we can visit all of the planets from each other
    int n = arc4random() % max_planets;
    NSMutableArray *visited = [[NSMutableArray alloc] init];
    NSMutableArray *tovisit = [[NSMutableArray alloc] init];
    Cell *cell = [planets objectAtIndex:n];
    int vplanets = 0;
    [tovisit addObject:cell];
    vplanets = [self visitNeighbors:vplanets visited:visited tovisit:tovisit];
    STAssertTrue(vplanets == max_planets, @"was not able to visit all of the planets.");
    [mg release];
    [gc release];
}

// XXX this is messed up somehow, it doesnt return the right number of planets visited
- (int)visitNeighbors:(int)vplanets visited:(NSMutableArray *)visited tovisit:(NSMutableArray *)tovisit {
    
    NSMutableArray *newvisits = [NSMutableArray array];
    for(Cell *cell in tovisit) {
        if([visited containsObject:cell]) {
            continue;
        }
        [visited addObject:cell];
        if(cell.planet != nil) {
            vplanets = vplanets + 1;
        }
        else {
        }
        for(NSString *dir in cell.exits) {
            Cell *value = [cell.exits objectForKey:dir];
            
            if((id)value == (id)[NSNull null]) {
                continue;
            }
            if(![visited containsObject:value]) {
                [newvisits addObject:value];    
            }
        }
    }
    if([newvisits count] == 0) {
        return(vplanets);
    }
    else {
        [tovisit release];
        tovisit = [newvisits copy];
        [newvisits release];
        vplanets = [self visitNeighbors:vplanets visited:visited tovisit:tovisit];
    }
    return(vplanets);
}
@end