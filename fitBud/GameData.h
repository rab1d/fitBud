//
//  GameData.h
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAToken.h"

@interface GameData : NSObject

-(void)plistStartup;
-(void)writeAccessTokenPlist:(OAToken *)accessToken;
-(OAToken *)readAcessTokenPlist;
-(void)writeCaloriesOutPlist:(NSString *)caloriesOut wirteStepsPlist:(NSString *)steps;
-(double)readPointsPlist;
@end

