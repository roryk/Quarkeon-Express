//
//  LoginViewController.m
//  Quarkeon Express
//
//  Created by Adam Fletcher on 11/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Quarkeon_ExpressAppDelegate.h"

@implementation LoginViewController

@synthesize loginButton, emailAddressField;

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

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)login:(id)sender
{
    bool didLogin = [appDelegate login:emailAddressField.text password:@"foo"];
    if (didLogin) {
        [appDelegate.loginVC.view removeFromSuperview];
        [appDelegate startMultiplayer];
    } else {    
        // XXX need to handle failure to login with a create login option?
        NSLog(@"Failed to login! XXXXX DO SOMETHING HERE!");
    }
    
}

@end
