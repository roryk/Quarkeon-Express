//
//  Quarkeon_ExpressViewController.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 10/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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





- (IBAction)goNorth:(id)sender;
- (IBAction)goSouth:(id)sender;
- (IBAction)goEast:(id)sender;
- (IBAction)goWest:(id)sender;

- (IBAction)buyPlanet:(id)sender;

- (void)updateGameScreen;
- (void)updateButton:(UIButton *)button buttonText:(NSString *)title;

@end
