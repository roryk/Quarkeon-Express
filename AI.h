//
//  AI.h
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


@interface AI : Player {
}

-(NSString *)chooseRandomDir;

@end


/**
 a dumb AI. it moves randomly and buys planets it can afford until it runs out of credits
 **/
@interface DumbAI : AI {
}

-(void)playTurn;

@end