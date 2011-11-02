//
//  PassGameVC.m
//  Quarkeon Express
//
//  Created by Rory Kirchner on 10/24/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import "PassGameVC.h"
#import "Quarkeon_ExpressAppDelegate.h"
#import "GameState.h"
#import "Quarkeon_ExpressViewController.h"
#import "WinScreenVC.h"

@implementation PassGameVC

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
    appDelegate = (Quarkeon_ExpressAppDelegate *)[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view from its nib.
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

- (IBAction)startTurn:(id)sender {
    GameState *gs = appDelegate.gameState;
    [gs startTurn];
    if([gs didCurrentPlayerWin]) {
        appDelegate.winScreenVC = [[WinScreenVC alloc] init];
        [appDelegate.passGameVC.view removeFromSuperview];
        //[appDelegate.passGameVC release];
        [appDelegate.window addSubview:appDelegate.winScreenVC.view];
        [gs gameOverCleanup];
    }
    else {
        //appDelegate.window.rootViewController = (UIViewController *) appDelegate.viewController;
        //[appDelegate.window makeKeyAndVisible];
        //[UIWindow addSubview:self.viewController];
        [appDelegate.passGameVC.view removeFromSuperview];
        //[appDelegate.passGameVC release];
        [appDelegate.viewController updateGameScreen];
        [appDelegate.window addSubview:appDelegate.viewController.view];
//        [appDelegate.viewController updateGameScreen];
        
    }
    
}

@end
