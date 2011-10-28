//
//  Quarkeon_ExpressViewController.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
    Planet *currPlanet = gs.currPlanet;
    
    if ([currPlanet hasLane:@"n"]) {
        NSString *title = [[NSNumber numberWithInt:gs.currPlanet.north.distance] stringValue];
        [self updateButton:northButton buttonText:title];
    } else {
        [northButton setEnabled:false];
        northButton.hidden=YES;
    }
    if ([currPlanet hasLane:@"s"]) {
        NSString *title = [[NSNumber numberWithInt:gs.currPlanet.south.distance] stringValue];
        [self updateButton:southButton buttonText:title];
    } else {
        [southButton setEnabled:false];
        southButton.hidden=YES;
    }
    if ([currPlanet hasLane:@"e"]) {
        NSString *title = [[NSNumber numberWithInt:gs.currPlanet.east.distance] stringValue];
        [self updateButton:eastButton buttonText:title];
    } else {
        [eastButton setEnabled:false];
        eastButton.hidden=YES;
    }
    if ([currPlanet hasLane:@"w"]) {
        NSString *title = [[NSNumber numberWithInt:gs.currPlanet.west.distance] stringValue];
        [self updateButton:westButton buttonText:title];
    } else {
        [westButton setEnabled:false];
        westButton.hidden=YES;
    }

    self.planetName.text = currPlanet.name;
    self.planetDescription.text = currPlanet.description;
    if (currPlanet.owner != nil) {
        self.owner.text = currPlanet.owner.name;
    } else {
        self.owner.text = @"Unowned";
    }
    
    
    self.currPlayerName.text = currPlayer.name;
    self.uraniumCount.text = [[NSNumber numberWithInt:currPlayer.uranium] stringValue];
    
    NSString *title = [NSString stringWithFormat:@"Buy For %@U", 
                    [[NSNumber numberWithInt:gs.currPlanet.currentCost] stringValue]];
    
    [self updateButton:self.buyButton buttonText:title];
    
    if ([gs canBuyCurrPlanet]) {
        [self.buyButton setEnabled:true];
    } else {
        [self.buyButton setEnabled:true];

    }
    
    [backgroundImageView setImage:gs.currPlanet.picture];
    
   // redraw the screen with the new planet info, etc. 

}
- (IBAction)goNorth:(id)sender {
    [appDelegate movePlayer:@"n"];
    [self updateGameScreen];
}

- (IBAction)goSouth:(id)sender {
    [appDelegate movePlayer:@"s"];
    [self updateGameScreen];

}

- (IBAction)goEast:(id)sender {
    [appDelegate movePlayer:@"e"];
    [self updateGameScreen];

}

- (IBAction)goWest:(id)sender {
    [appDelegate movePlayer:@"w"];
    [self updateGameScreen];

}

- (IBAction)buyPlanet:(id)sender {
    GameState *gs = appDelegate.gameState;
    [gs buyCurrPlanet];
    [self updateGameScreen];
}

- (IBAction)endTurn:(id)sender {
    GameState *gs = appDelegate.gameState;

    [gs endTurn];
    // switch views to the pass the game screen
    appDelegate.passGameVC = [[PassGameVC alloc] init];
    [appDelegate.viewController.view removeFromSuperview];
    //[appDelegate.viewController release];
    [appDelegate.window addSubview:appDelegate.passGameVC.view];


}

@end
