//
//  PlayerSetupScreen.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/3/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "PlayerSetupScreen.h"
#import "Quarkeon_ExpressAppDelegate.h"
#import "GameSetupScreen.h"
#import "Quarkeon_ExpressViewController.h"


@implementation PlayerSetupScreen

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
    if (appDelegate.gameState.numPlayers == 2) {
        self.player3Name.hidden = YES;
        self.player4Name.hidden = YES;
    } else if (appDelegate.gameState.numPlayers == 3) {
        self.player4Name.hidden = YES;
    }

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

- (IBAction)backToGameSetup:(id)sender
{
    [appDelegate.playerSetupVC.view removeFromSuperview];
    [appDelegate.window addSubview:appDelegate.gameSetupVC.view];
    
}

- (IBAction)startGame:(id)sender
{
    // XXX gather up all the game state data and pass it to the startGame in the delegateß
    [appDelegate.playerSetupVC.view removeFromSuperview];
    [appDelegate.window addSubview:appDelegate.playGameVC.view];
    
}

@end
