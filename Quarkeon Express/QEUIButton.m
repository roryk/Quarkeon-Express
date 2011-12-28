//
//  QEUIButton.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QEUIButton.h"
#import <QuartzCore/QuartzCore.h>


@implementation QEUIButton

- (void)awakeFromNib;
{

    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:5.0];
    [self.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];
    
}

@end
