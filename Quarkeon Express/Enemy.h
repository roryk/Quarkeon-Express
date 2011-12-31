//
//  Enemy.h
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

#import <Foundation/Foundation.h>

@interface Enemy : NSObject {
/* 
 Enemy:
 -- hit points
 -- attack score
 -- defend score
 -- name
 -- defend
 -- lootType
 -- lootAmount
 -- wittyStatement
 -- image
 */
    int hitPoints;
    int attack;
    int defend;
    int lootAmount;
    int lootType; // XXX should be an enum
    NSString *name;
    NSString *wittyStatement;
    UIImage *picture;
    
}

@property (readwrite, assign) int hitPoints;
@property (readwrite, assign) int attack;
@property (readwrite, assign) int defend;
@property (readwrite, assign) int lootAmount;
@property (readwrite, assign) int lootType;
@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *wittyStatement;


@end
