//
//  PlayerSetupScreen.h
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
