//
//  GameSetupScreen.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/3/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Quarkeon_ExpressAppDelegate;

@interface GameSetupScreen : UIViewController
{
    Quarkeon_ExpressAppDelegate *appDelegate;
    IBOutlet UIButton *smallMapButton;
    IBOutlet UIButton *largeMapButton;
    IBOutlet UIButton *mediumMapButton;
    
    IBOutlet UIButton *twoPlayerButton;
    IBOutlet UIButton *threePlayerButton;
    IBOutlet UIButton *fourPlayerButton;
    
    IBOutlet UIButton *nextButton;

    IBOutlet UIButton *backToMainMenuButton;
    
    

}
@property (nonatomic, retain) UIButton *smallMapButton;
@property (nonatomic, retain) UIButton *mediumMapButton;
@property (nonatomic, retain) UIButton *largeMapButton;

@property (nonatomic, retain) UIButton *twoPlayerButton;
@property (nonatomic, retain) UIButton *threePlayerButton;
@property (nonatomic, retain) UIButton *fourPlayerButton;

@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *backToMainMenuButton;


- (IBAction)pickSmallMap:(id)sender;
- (IBAction)pickMediumMap:(id)sender;
- (IBAction)pickLargeMap:(id)sender;

- (IBAction)pickTwoPlayer:(id)sender;
- (IBAction)pickThreePlayer:(id)sender;
- (IBAction)pickFourPlayer:(id)sender;

- (IBAction)backToMainMenu:(id)sender;
- (IBAction)nextScreen:(id)sender;

- (void)setButtonSelected:(UIButton *)selectedButton;

- (void)clearButtonStyle:(UIButton *)buttonToClear;


@end
