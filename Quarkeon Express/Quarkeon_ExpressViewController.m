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
        if ([gs canBuyCurrPlanet]) {
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
    [appDelegate movePlayer:@"north"];
    [self updateGameScreen];
}

- (IBAction)goSouth:(id)sender {
    [appDelegate movePlayer:@"south"];
    [self updateGameScreen];

}

- (IBAction)goEast:(id)sender {
    [appDelegate movePlayer:@"east"];
    [self updateGameScreen];

}

- (IBAction)goWest:(id)sender {
    [appDelegate movePlayer:@"west"];
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
    [appDelegate.playGameVC.view removeFromSuperview];
    //[appDelegate.viewController release];
    [appDelegate.window addSubview:appDelegate.passGameVC.view];


}

@end
