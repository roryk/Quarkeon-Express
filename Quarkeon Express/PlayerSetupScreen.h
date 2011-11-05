//
//  PlayerSetupScreen.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/3/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quarkeon_ExpressAppDelegate;

@interface PlayerSetupScreen : UIViewController
{
    Quarkeon_ExpressAppDelegate *appDelegate;
    IBOutlet UITextField *player1Name;
    IBOutlet UITextField *player2Name;
    IBOutlet UITextField *player3Name;
    IBOutlet UITextField *player4Name;
    
    IBOutlet UIButton *startGameButton;
    IBOutlet UIButton *backToGameSetupButton;

}

@property (nonatomic, retain) UITextField *player1Name;
@property (nonatomic, retain) UITextField *player2Name;
@property (nonatomic, retain) UITextField *player3Name;
@property (nonatomic, retain) UITextField *player4Name;

@property (nonatomic, retain) UIButton *startGameButton;
@property (nonatomic, retain) UIButton *backToGameSetupButton;

- (IBAction)backToGameSetup:(id)sender;
- (IBAction)startGame:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;



@end
