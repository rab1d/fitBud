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

-(double)calculateActivityPoints:(NSArray *)activeScoreArray{
    NSMutableArray *temp = [activeScoreArray mutableCopy];
    double result;
    NSLog(@"DataBrain || calcActivityPoints. Received activeScoreArray: %@", activeScoreArray);
    
    // self.activityPoints = sum(activeScore of last three days
    if ([activeScoreArray count]==0){
        result = 0;
    } else if ([activeScoreArray count] == 1){
        result = [[temp lastObject] doubleValue];
    } else if ([activeScoreArray count] == 2){
        double first = [[temp lastObject] doubleValue];
        [temp removeLastObject];
        double second = [[temp lastObject] doubleValue];
        
        result = first + second;
    } else {
        double first = [[temp lastObject] doubleValue];
        [temp removeLastObject];
        double second = [[temp lastObject] doubleValue];
        [temp removeLastObject];
        double third = [[temp lastObject] doubleValue];
        
        result = first + second + third;
    }
    
    return result;
    NSLog(@"DataBrain || calcActivityPoints. Calculated Activity Points = %f", result);
}


-(double)calculateExperiencePoints:(NSArray *)activeScoreArray{
    NSInteger sum = 0;
    for (NSNumber *num in activeScoreArray)
    {
        sum += [num doubleValue];
    }
    
    return sum;
}

@end
