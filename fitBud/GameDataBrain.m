//
//  GameDataBrain.m
//  gamedataTester
//
//  Created by Mohammod Arafat on 2/24/13.
//  Copyright (c) 2013 MAInc. All rights reserved.
//

#import "GameDataBrain.h"

@interface GameDataBrain()
@property GameData *myGameData;

@end

@implementation GameDataBrain
@synthesize myGameData = _myGameData;

-(void)calculateActivityPoints:(NSArray *)activeScoreArray{
    NSMutableArray *temp = [activeScoreArray mutableCopy];
    
    // self.activityPoints = sum(activeScore of last three days
    if ([activeScoreArray count]==0){
        self.myGameData.activityPoints = 0;
    } else if ([activeScoreArray count] == 1){
        self.myGameData.activityPoints = [[temp lastObject] doubleValue];
    } else if ([activeScoreArray count] == 2){
        double first = [[temp lastObject] doubleValue];
        [temp removeLastObject];
        double second = [[temp lastObject] doubleValue];
        
        self.myGameData.activityPoints = first + second;
    } else {
        double first = [[temp lastObject] doubleValue];
        [temp removeLastObject];
        double second = [[temp lastObject] doubleValue];
        [temp removeLastObject];
        double third = [[temp lastObject] doubleValue];
        
        self.myGameData.activityPoints = first + second + third;
    }
}


-(void)calculateExperiencePoints:(NSArray *)activeScoreArray{
    NSInteger sum = 0;
    for (NSNumber *num in activeScoreArray)
    {
        sum += [num doubleValue];
    }
    
    self.myGameData.experiencePoints = sum;
}

@end
