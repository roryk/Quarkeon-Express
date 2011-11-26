//
//  MainMenu.h
//  Quarkeon Express
//
//  Created by Rory Kirchner on 11/3/11.
//  Copyright 2011 MIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quarkeon_ExpressAppDelegate;

@interface MainMenu : UIViewController
{
    IBOutlet UIButton *newGameButton;
    IBOutlet UIButton *loadGameButton;
    IBOutlet UIButton *multiplayerButton;
    
    Quarkeon_ExpressAppDelegate *appDelegate;

    
}

@property (nonatomic, retain) UIButton *newGameButton;
@property (nonatomic, retain) UIButton *loadGameButton;
@property (nonatomic, retain) UIButton *multiplayerButton;


- (IBAction)newGame:(id)sender;

- (IBAction)multiplayerGame:(id)sender;

@end
