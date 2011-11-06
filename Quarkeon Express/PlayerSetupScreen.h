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

    IBOutlet UIButton *player1AI;
    IBOutlet UIButton *player2AI;
    IBOutlet UIButton *player3AI;
    IBOutlet UIButton *player4AI;
    
    bool isPlayer1AI;
    bool isPlayer2AI;
    bool isPlayer3AI;
    bool isPlayer4AI;
}
@property (nonatomic, retain) IBOutlet UIButton *player1AI;
@property (nonatomic, retain) IBOutlet UIButton *player2AI;
@property (nonatomic, retain) IBOutlet UIButton *player3AI;
@property (nonatomic, retain) IBOutlet UIButton *player4AI;

@property (nonatomic, retain) UITextField *player1Name;
@property (nonatomic, retain) UITextField *player2Name;
@property (nonatomic, retain) UITextField *player3Name;
@property (nonatomic, retain) UITextField *player4Name;

@property (nonatomic, retain) UIButton *startGameButton;
@property (nonatomic, retain) UIButton *backToGameSetupButton;

- (IBAction)backToGameSetup:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

- (IBAction)setPlayer4ToAI:(id)sender;
- (IBAction)setPlayer1ToAI:(id)sender;
- (IBAction)setPlayer2ToAI:(id)sender;
- (IBAction)setPlayer3ToAI:(id)sender;
- (void)clearAIButton:(UIButton *)selectedButton;
- (void)setAIButtonSelected:(UIButton *)selectedButton;


@end
