//
//  Quarkeon_ExpressViewController.h
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
#import "Quarkeon_ExpressAppDelegate.h"

@class Planet;
@class Player;
@class SpaceLane;

@interface Quarkeon_ExpressViewController : UIViewController {
    Quarkeon_ExpressAppDelegate *appDelegate;
    IBOutlet UIButton *northButton;
    IBOutlet UIButton *southButton;
    IBOutlet UIButton *eastButton;
    IBOutlet UIButton *westButton;
    
    IBOutlet UIButton *buyButton;

    IBOutlet UILabel *planetName;
    IBOutlet UILabel *planetDescription;
    IBOutlet UILabel *owner;
    IBOutlet UILabel *uraniumCount;
    IBOutlet UILabel *planetsCount;
    IBOutlet UILabel *currPlayerName;
    IBOutlet UIImageView *backgroundImageView;

}

@property (nonatomic, retain) UIButton *northButton;
@property (nonatomic, retain) UIButton *southButton;
@property (nonatomic, retain) UIButton *westButton;
@property (nonatomic, retain) UIButton *eastButton;

@property (nonatomic, retain) UIButton *buyButton;

@property (nonatomic, retain) UILabel *planetName;
@property (nonatomic, retain) UILabel *planetsCount;
@property (nonatomic, retain) UILabel *owner;
@property (nonatomic, retain) UILabel *currPlayerName;
@property (nonatomic, retain) UILabel *uraniumCount;
@property (nonatomic, retain) UILabel *planetDescription;

@property (nonatomic, retain) UIImageView *backgroundImageView;




- (IBAction)goNorth:(id)sender;
- (IBAction)goSouth:(id)sender;
- (IBAction)goEast:(id)sender;
- (IBAction)goWest:(id)sender;

- (IBAction)buyPlanet:(id)sender;

- (void)updateGameScreen;
- (void)updateButton:(UIButton *)button buttonText:(NSString *)title;
- (IBAction)endTurn:(id)sender;

@end
