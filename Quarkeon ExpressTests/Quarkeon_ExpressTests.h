//
//  Quarkeon_ExpressTests.h
//  Quarkeon ExpressTests
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface Quarkeon_ExpressTests : SenTestCase

- (int) visitNeighbors:(int)vplanets visited:(NSMutableArray *)visited tovisit:(NSMutableArray *)tovisit;
@end
