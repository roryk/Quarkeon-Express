//
//  PassGameVC.m
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
    [gs setupTurn];
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
//        [gs startTurn];
        [appDelegate.passGameVC.view removeFromSuperview];
        //[appDelegate.passGameVC release];
        [appDelegate.playGameVC updateGameScreen];
        [appDelegate.window addSubview:appDelegate.playGameVC.view];
//        [appDelegate.viewController updateGameScreen];
        [gs startTurn];
        
    }
    
}

@end
