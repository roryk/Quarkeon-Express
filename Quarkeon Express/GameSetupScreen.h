//
//  GameSetupScreen.h
//  Quarkeon Express
//
//   Copyright 2011 Rory Kirchner
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

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
