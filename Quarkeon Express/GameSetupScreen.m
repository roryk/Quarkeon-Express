//
//  GameSetupScreen.m
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

#import "GameSetupScreen.h"
#import "Quarkeon_ExpressAppDelegate.h"
#import "MainMenu.h"
#import "PlayerSetupScreen.h"

@implementation GameSetupScreen

@synthesize smallMapButton, mediumMapButton, largeMapButton;
@synthesize twoPlayerButton, threePlayerButton, fourPlayerButton;
@synthesize nextButton, backToMainMenuButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate = (Quarkeon_ExpressAppDelegate *)[[UIApplication sharedApplication] delegate];

    appDelegate.gameState.mapSize = @"Medium";
    appDelegate.gameState.numPlayers = 2;
    [self setButtonSelected:mediumMapButton];
    [self setButtonSelected:twoPlayerButton];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);

}

- (IBAction)pickSmallMap:(id)sender
{
    appDelegate.gameState.mapSize = @"Small";
    [self setButtonSelected:smallMapButton];
    
}

- (IBAction)pickMediumMap:(id)sender
{
    appDelegate.gameState.mapSize = @"Medium";
    [self setButtonSelected:mediumMapButton];
}

- (IBAction)pickLargeMap:(id)sender
{
    appDelegate.gameState.mapSize = @"Large";
    [self setButtonSelected:largeMapButton];
}

- (IBAction)pickTwoPlayer:(id)sender
{
    appDelegate.gameState.numPlayers = 2;
    [self setButtonSelected:twoPlayerButton];

}

- (IBAction)pickThreePlayer:(id)sender
{
    appDelegate.gameState.numPlayers = 3;
    [self setButtonSelected:threePlayerButton];

}

- (IBAction)pickFourPlayer:(id)sender
{
    appDelegate.gameState.numPlayers = 4;
    [self setButtonSelected:fourPlayerButton];
    
}

- (IBAction)backToMainMenu:(id)sender
{
    [appDelegate.gameSetupVC.view removeFromSuperview];
    [appDelegate.window addSubview:appDelegate.mainMenuVC.view];
}

- (IBAction)nextScreen:(id)sender
{
    [appDelegate generateMap];
    [appDelegate.gameSetupVC.view removeFromSuperview];
    [appDelegate.window addSubview:appDelegate.playerSetupVC.view];

}

- (void)setButtonSelected:(UIButton *)selectedButton
{
    if (selectedButton == smallMapButton || selectedButton == largeMapButton || selectedButton == mediumMapButton) {
        [self clearButtonStyle:mediumMapButton];
        [self clearButtonStyle:largeMapButton];
        [self clearButtonStyle:smallMapButton];
    } 
    
    if (selectedButton == twoPlayerButton || selectedButton == threePlayerButton || selectedButton == fourPlayerButton) {
        [self clearButtonStyle:twoPlayerButton];
        [self clearButtonStyle:threePlayerButton];
        [self clearButtonStyle:fourPlayerButton];
    } 
    
    [selectedButton.layer setBorderWidth:1.0];
    [selectedButton.layer setCornerRadius:5.0];
    [selectedButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];
}

- (void)clearButtonStyle:(UIButton *)buttonToClear
{
    [buttonToClear.layer setBorderWidth:0.0];
}

@end
