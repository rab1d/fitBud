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
@property (nonatomic) double experiencePoints;
@property (nonatomic) double activityPoints;

// Access Token Read/Write
-(void)writeAccessTokenPlist:(OAToken *)accessToken;
-(OAToken *)readAcessTokenPlist;

// Get Data
-(void)receiveDataWithDate:(NSDate *)syncDate caloriesOut:(NSString *)caloriesOut steps:(NSString *)numSteps activeScore:(NSString *)activeScore;

// Read Data
-(NSDictionary *)readGameData;
-(double)readExperiencePoints;
-(double)readActivityPoints;

// Write Data
-(void)writeExperiencePoints:(double)experiencePoints;
-(void)writeCaloriesOutPlist:(NSString *)caloriesOut writeStepsPlist:(NSString *)steps writeActivityScorePlist:(NSString *)activityScore;


@end

