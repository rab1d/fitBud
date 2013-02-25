//
//  GameDataBrain.h
//  gamedataTester
//
//  Created by Mohammod Arafat on 2/24/13.
//  Copyright (c) 2013 MAInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameData.h"

@interface GameDataBrain : NSObject

-(void)calculateActivityPoints:(NSArray*)activeScoreArray;
-(void)calculateExperiencePoints:(NSArray*)activeScoreArray;


@end
