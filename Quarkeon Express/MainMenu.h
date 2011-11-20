//
//  MainMenu.h
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

@interface MainMenu : UIViewController
{
    IBOutlet UIButton *newGameButton;
    IBOutlet UIButton *loadGameButton;
    IBOutlet UIButton *helpButton;
    
    Quarkeon_ExpressAppDelegate *appDelegate;

    
}

@property (nonatomic, retain) UIButton *newGameButton;
@property (nonatomic, retain) UIButton *loadGameButton;
@property (nonatomic, retain) UIButton *helpButton;


- (IBAction)newGame:(id)sender;


@end
