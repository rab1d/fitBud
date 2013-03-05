//
//  GameData.h
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "FitbitViewController.h"
// #import "OAToken.h"

@interface GameData : NSObject
//@property (nonatomic) double experiencePoints;
//@property (nonatomic) double activityPoints;



// Get Data
-(void)syncGameData;
-(void)receiveDataWithDate:(NSDate *)syncDate
               caloriesOut:(double)caloriesOut
                     steps:(double)numSteps
               activeScore:(double)activeScore;

// Read Data
-(double)readExperiencePoints;
-(double)readActivityPoints;

// Send Experience and Activity Points
-(double)sendExperiencePoints;
-(double)sendActivityPoints;

/*
// Write Data
-(void)writeExperiencePoints:(double)experiencePoints;
-(void)writeActivityPoints:(double)activityPoints;

-(void)writeCaloriesOutPlist:(double)caloriesOut
             writeStepsPlist:(double)steps
     writeActivityScorePlist:(double)activityScore
                        date:(NSDate *)syncDate;
 
 


*/

// Access Token Read/Write
// -(void)writeAccessTokenPlist:(OAToken *)accessToken;
// -(OAToken *)readAcessTokenPlist;


@end

