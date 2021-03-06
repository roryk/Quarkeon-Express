//
//  Quarkeon_ExpressViewController.m
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

#import "Quarkeon_ExpressViewController.h"
#import "GameState.h"
#import "Planet.h"
#import "SpaceLane.h"
#import "Player.h"
#include "PassGameVC.h"

@implementation Quarkeon_ExpressViewController

@synthesize northButton, southButton, eastButton, westButton;
@synthesize owner, planetName, planetDescription, planetsCount, uraniumCount;
@synthesize currPlayerName;
@synthesize buyButton;
@synthesize backgroundImageView;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (Quarkeon_ExpressAppDelegate *)[[UIApplication sharedApplication] delegate];    
    [self updateGameScreen];    
    
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

- (void)updateButton:(UIButton *)button buttonText:(NSString *)title {
    [button setEnabled:true];
    button.hidden=NO;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateSelected];
}

- (void)updateGameScreen {
    GameState *gs = appDelegate.gameState;
    Player *currPlayer = gs.currPlayer;
    Cell *currCell = gs.currCell;
    
    if ([currCell hasLane:@"north"]) {
        [northButton setEnabled:true];
        northButton.hidden=NO;
    } else {
        [northButton setEnabled:false];
        northButton.hidden=YES;
    }
    if ([currCell hasLane:@"south"]) {
        [southButton setEnabled:true];
        southButton.hidden=NO;
    } else {
        [southButton setEnabled:false];
        southButton.hidden=YES;
    }
    if ([currCell hasLane:@"east"]) {
        [eastButton setEnabled:true];
        eastButton.hidden=NO;
    } else {
        [eastButton setEnabled:false];
        eastButton.hidden=YES;
    }
    if ([currCell hasLane:@"west"]) {
        [westButton setEnabled:true];
        westButton.hidden=NO;
    } else {
        [westButton setEnabled:false];
        westButton.hidden=YES;
    }

    if(currCell.planet != nil) {
        self.planetName.hidden = NO;
        self.planetName.text = currCell.planet.name;
        self.planetDescription.hidden = NO;
        self.planetDescription.text = currCell.planet.description;
        self.owner.hidden = NO;
        if(currCell.planet.owner != nil) {
            self.owner.text = currCell.planet.owner.name;
        }
        else {
            self.owner.text = @"Unowned";
        }
        NSString *title = [NSString stringWithFormat:@"Buy For %@U", 
                           [[NSNumber numberWithInt:currCell.planet.currentCost] stringValue]];
        [self updateButton:self.buyButton buttonText:title];
        if ([currPlayer canBuyCurrPlanet]) {
            [self.buyButton setEnabled:true];
        }
        else {
            [self.buyButton setEnabled:false];
        }
    }
    else {
        self.planetName.hidden = YES;
        self.planetDescription.hidden = YES;
        self.owner.hidden = YES;
        self.buyButton.hidden = YES;
    }
    
    [backgroundImageView setImage:currCell.picture];
    self.currPlayerName.text = currPlayer.name;
    self.uraniumCount.text = [[NSNumber numberWithInt:currPlayer.uranium] stringValue];
    self.planetsCount.text = [NSString stringWithFormat:@"%d/%d", gs.currPlayer.planetsOwned, [gs.planets count]];
    
}
- (IBAction)goNorth:(id)sender {
    Player *player = appDelegate.gameState.currPlayer;
    [player movePlayerInDirection:@"north"];
    [self updateGameScreen];
}

- (IBAction)goSouth:(id)sender {
    Player *player = appDelegate.gameState.currPlayer;
    [player movePlayerInDirection:@"south"];
    [self updateGameScreen];

}

- (IBAction)goEast:(id)sender {
    Player *player = appDelegate.gameState.currPlayer;
    [player movePlayerInDirection:@"east"];
    [self updateGameScreen];

}

- (IBAction)goWest:(id)sender {
    Player *player = appDelegate.gameState.currPlayer;
    [player movePlayerInDirection:@"west"];
    [self updateGameScreen];

}

- (IBAction)buyPlanet:(id)sender {
    Player *player = appDelegate.gameState.currPlayer;
    [player buyCurrPlanet];
    [self updateGameScreen];
}

- (IBAction)endTurn:(id)sender {
    GameState *gs = appDelegate.gameState;

    [gs endTurn];
    
    appDelegate.passGameVC = [[PassGameVC alloc] init];
    [appDelegate.playGameVC.view removeFromSuperview];
    [appDelegate.window addSubview:appDelegate.passGameVC.view];
    if([[gs.turnQueue getHead] isKindOfClass:[AI class]]) {
        [appDelegate.passGameVC startTurn:(id)nil];
    }   
}

@end
