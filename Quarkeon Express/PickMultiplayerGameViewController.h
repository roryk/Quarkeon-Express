//
//  PickMultiplayerGameViewController.h
//  Quarkeon Express
//
//  Created by Adam Fletcher on 11/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Quarkeon_ExpressAppDelegate;
@class QEUIButton;


@interface PickMultiplayerGameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    Quarkeon_ExpressAppDelegate *appDelegate;
    IBOutlet UITableView *myGamesTableView;
    IBOutlet QEUIButton *newGameButton;


}
@property (nonatomic, retain) UITableView *myGamesTableView;
@property (nonatomic, retain) QEUIButton *newGameButton;

- (IBAction)newGame:(id)sender;


@end
