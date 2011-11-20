//
//  PlayerSetupScreen.m
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

#import "PlayerSetupScreen.h"
#import "Quarkeon_ExpressAppDelegate.h"
#import "GameSetupScreen.h"
#import "Quarkeon_ExpressViewController.h"


@implementation PlayerSetupScreen
@synthesize player1AI, player2AI, player3AI, player4AI;

@synthesize player1Name, player2Name, player3Name, player4Name;
@synthesize backToGameSetupButton, startGameButton;

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
    isPlayer1AI = false;
    [self clearAIButton:player1AI];
    isPlayer2AI = false;
    [self clearAIButton:player2AI];
    isPlayer3AI = false;
    [self clearAIButton:player3AI];
    isPlayer4AI = false;
    [self clearAIButton:player4AI];
    if (appDelegate.gameState.numPlayers == 2) {
        self.player3Name.hidden = YES;
        self.player3AI.hidden = YES;
        isPlayer4AI = false;
        self.player4Name.hidden = YES;
        self.player4AI.hidden = YES;
    } else if (appDelegate.gameState.numPlayers == 3) {
        self.player4Name.hidden = YES;
        self.player4AI.hidden = YES;
    }

}

- (void)viewDidUnload
{
    [self setPlayer1AI:nil];
    [player2AI release];
    player2AI = nil;
    [player1AI release];
    player1AI = nil;
    [player3AI release];
    player3AI = nil;
    [player4AI release];
    player4AI = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);

}

- (IBAction)backToGameSetup:(id)sender
{
    [appDelegate.playerSetupVC.view removeFromSuperview];
    [appDelegate.window addSubview:appDelegate.gameSetupVC.view];
    
}

- (IBAction)startGame:(id)sender
{

    [appDelegate addPlayerToGame:player1Name.text isAI:isPlayer1AI];
    [appDelegate addPlayerToGame:player2Name.text isAI:isPlayer2AI];

    if (appDelegate.gameState.numPlayers == 3) {
        [appDelegate addPlayerToGame:player3Name.text isAI:isPlayer3AI];
    }

    if (appDelegate.gameState.numPlayers == 4) {
        [appDelegate addPlayerToGame:player3Name.text isAI:isPlayer3AI];
        [appDelegate addPlayerToGame:player4Name.text isAI:isPlayer4AI];

    }
    
    [appDelegate startGame];

    
    // XXX gather up all the game state data and pass it to the startGame in the delegateß
    [appDelegate.playerSetupVC.view removeFromSuperview];
    [appDelegate.window addSubview:appDelegate.playGameVC.view];
    
}


- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)setPlayer1ToAI:(id)sender {
    if(isPlayer1AI) {
        [self clearAIButton:player1AI];
        isPlayer1AI = false;
    }
    else {
        [self setAIButtonSelected:player1AI];
        isPlayer1AI = true;
    }
}

- (IBAction)setPlayer2ToAI:(id)sender {
    if(isPlayer2AI) {
        [self clearAIButton:player2AI];
        isPlayer2AI = false;
    }
    else {
        [self setAIButtonSelected:player2AI];
        isPlayer2AI = true;
    }
}

- (IBAction)setPlayer3ToAI:(id)sender {
    if(isPlayer3AI) {
        [self clearAIButton:player3AI];
        isPlayer3AI = false;
    }
    else {
        [self setAIButtonSelected:player3AI];
        isPlayer3AI = true;
    }
}

- (IBAction)setPlayer4ToAI:(id) sender {
    if(isPlayer4AI) {
        [self clearAIButton:player4AI];
        isPlayer4AI = false;
    }
    else {
        [self setAIButtonSelected:player4AI];
        isPlayer4AI = true;
    }
}


- (void)dealloc {
    [player1AI release];
    [player2AI release];
    [player1AI release];
    [player3AI release];
    [player4AI release];
    [super dealloc];
}

- (void)setAIButtonSelected:(UIButton *)selectedButton {
    // clear the buttons
    [selectedButton.layer setBorderWidth:1.0];
    [selectedButton.layer setCornerRadius:5.0];
    [selectedButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];
    
}

- (void)clearAIButton:(UIButton *)selectedButton {
    [selectedButton.layer setBorderWidth:0.0];
}
         
@end
