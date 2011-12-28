//
//  LoginViewController.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 11/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quarkeon_ExpressAppDelegate;

@interface LoginViewController : UIViewController
{
    IBOutlet UIButton *loginButton;
    IBOutlet UITextField *emailAddressField;
    Quarkeon_ExpressAppDelegate *appDelegate;

}

@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UITextField *emailAddressField;


- (IBAction)login:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;



@end
