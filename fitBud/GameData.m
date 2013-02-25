//
//  GameData.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

// GameData is designed to receive JSON Data, send it to GameBrain for managing
// and storing and retrieving information in an internal database

/*
 helpful example code
 
 //create dictionary of plist
 //NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: listpath];
 
 //read from plist
 NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: listpath];
 NSString *value = [savedStock objectForKey:@"string1"];
 NSLog(@"Count: %@", value);
 
 ///write to plist
 [savedStock setObject:@"fred" forKey:@"string1"];
 [savedStock writeToFile:listpath atomically:YES];
 
 //check if write was successful
 NSMutableDictionary *savedStock2 = [[NSMutableDictionary alloc] initWithContentsOfFile: listpath];
 NSString *value2 = [savedStock2 objectForKey:@"string1"];
 NSLog(@"Count: %@", value2);
 */

#import "GameData.h"
#import "GameDataBrain.h"

@interface GameData()
@property (strong,nonatomic) NSString *listPath;
@end

@implementation GameData
@synthesize listPath;
@synthesize activityPoints = _activityPoints;
@synthesize experiencePoints = _experiencePoints;


#pragma mark Initialization

// At start
-(id)init{
    // [super init];
    [self plistStartup];
    return self;
}


-(void)plistStartup{
    listPath = [[self documentDirectory] stringByAppendingPathComponent:@"fitBudData.plist"];
    //[self clearListPlistFile:listPath];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:listPath]){
        
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"fitBudData" ofType:@"plist"] toPath:listPath error:nil];
        
    }
}



-(NSString *)documentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}


/*****************************/
// PList Management: Receive Data
/*****************************/
#pragma mark Receive Data

-(void)receiveDataWithDate:(NSDate *)syncDate caloriesOut:(double)caloriesOut steps:(double)numSteps activeScore:(double)activeScore{
    
    // once received we:
    // 1. call the write methods for calories, steps, and activeScore and Date
    [self writeCaloriesOutPlist:caloriesOut writeStepsPlist:numSteps writeActivityScorePlist:activeScore date:syncDate];
    
    // 2. pass the calories, step and active score data to another class called GameDataBrain
    GameDataBrain* myGDBrain = [[GameDataBrain alloc] init];
    [myGDBrain calculateActivityPoints:[self readActiveScoreArray]];
    [myGDBrain calculateExperiencePoints:[self readActiveScoreArray]];
    
    // 3. GameDataBrain will use the data to modify the experiencePoints and the activityPoints properties
    
    
    // 4. We write self.activityPoints and self.experiencePoints to the pList, and update the Last Sync Date
    [self writeExperiencePoints:self.experiencePoints];
    [self writeActivityPoints:self.activityPoints];
    [self writeSyncDate:[NSDate date]];
    
}


/*****************************/
// PList Management: Write
/*****************************/
#pragma mark Write Data

// Write Steps, Calories and Activity Score to a PList
-(void)writeCaloriesOutPlist:(double)caloriesOut
             writeStepsPlist:(double)steps
     writeActivityScorePlist:(double)activityScore
                        date:(NSDate *)syncDate{
    
    // Get my pList
    NSMutableDictionary *myPListDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
    NSLog(@"tempGameDataDict 1: %@", myPListDictionary);
    
    // grab calories array and add new calorie
    NSMutableArray *caloriesArray = [self readCaloriesOutArray];
    [caloriesArray addObject:[NSNumber numberWithFloat:caloriesOut]];
    
    // grab steps array and add new steps
    NSMutableArray *stepsArray = [self readStepsArray];
    [stepsArray addObject:[NSNumber numberWithFloat:steps]];
    
    // grab activity score array and add new activity score
    NSMutableArray *scoreArray = [self readActiveScoreArray];
    [scoreArray addObject:[NSNumber numberWithFloat:activityScore]];
    
    // grab date array and add new date
    NSMutableArray *datesArray = [self readDateArray];
    [datesArray addObject:syncDate];
    
    // add arrays to the pList dictionary
    [myPListDictionary setObject:caloriesArray forKey:@"Calories Out"];
    [myPListDictionary setObject:stepsArray forKey:@"Steps"];
    [myPListDictionary setObject:scoreArray forKey:@"Active Score"];
    [myPListDictionary setObject:datesArray forKey:@"Date"];
    
    // save temp Game Data dictionary to pList
    [myPListDictionary writeToFile:listPath atomically:YES];
    
    NSLog(@"tempGameDataDict 2: %@", myPListDictionary);
    
}

-(void)writeExperiencePoints:(double)experiencePoints{
    // Get my pList
    NSMutableDictionary *myPListDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
    
    
    NSString *temp = [NSString stringWithFormat:@"%f", experiencePoints];
    
    [myPListDictionary setObject:temp  forKey:@"Experience Points"];
    [myPListDictionary writeToFile:listPath atomically:YES];
    //[myPListDictionary release];
}


-(void)writeActivityPoints:(double)activityPoints{
    NSMutableDictionary *myPListDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
    
    NSString *temp = [NSString stringWithFormat:@"%f", activityPoints];
    
    [myPListDictionary setObject:temp  forKey:@"Activity Points"];
    [myPListDictionary writeToFile:listPath atomically:YES];
    //[myPListDictionary release];
    
}

-(void)writeSyncDate:(NSDate *)date{
    NSMutableDictionary *myPListDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
    
    [myPListDictionary setObject:date  forKey:@"Last Sync Date"];
    [myPListDictionary writeToFile:listPath atomically:YES];
    //[myPListDictionary release];
    
}


/*****************************/
// PList Management: Read
/*****************************/
#pragma mark Read Data

/*
 //reads the plsit and returns the points value
 -(NSDictionary *)readGameData{
 NSMutableDictionary *plistContents = [self getListContents];
 NSDictionary *dataDictionary = [plistContents objectForKey:@"Active Score"];
 NSLog(@"gd Game data: %@", dataDictionary);
 return dataDictionary;
 }
 */

-(NSMutableArray *)readActiveScoreArray{
    NSMutableDictionary *plistContents = [self getListContents];
    NSMutableArray *scoreArray = [plistContents objectForKey:@"Active Score"];
    return scoreArray;
}

-(NSMutableArray *)readCaloriesOutArray{
    NSMutableDictionary *plistContents = [self getListContents];
    NSMutableArray *calArray = [plistContents objectForKey:@"Calories Out"];
    return calArray;
}

-(NSMutableArray *)readStepsArray{
    NSMutableDictionary *plistContents = [self getListContents];
    NSMutableArray *stepsArray = [plistContents objectForKey:@"Steps"];
    return stepsArray;
}

-(NSMutableArray *)readDateArray{
    NSMutableDictionary *plistContents = [self getListContents];
    NSMutableArray *dateArray = [plistContents objectForKey:@"Date"];
    return dateArray;
}


-(double)readExperiencePoints{
    NSMutableDictionary *plistContents = [self getListContents];
    double expPoints = [[plistContents objectForKey:@"Experience Points"] doubleValue];
    return expPoints;
}

-(double)readActivityPoints{
    NSMutableDictionary *plistContents = [self getListContents];
    double actPoints = [[plistContents objectForKey:@"Activity Points"] doubleValue];
    // NSLog(@"gd activity: %f", actPoints);
    return actPoints;
}


// Gives all the contents from the pList
-(NSMutableDictionary *)getListContents{
    NSMutableDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
    
    // NSLog(@"gd plist: %@", plistContents);
    return plistContents;
    
}


#pragma mark Clear pList

//this is used to delete the plist file fromt the NSFileManager. The file is still in the App Bundle however.
-(void)clearListPlistFile:(NSString *)str{
    //further improvements can be made here as the error can be specified particularly instead of being set to nil.
    if( [[NSFileManager defaultManager] removeItemAtPath:str error:nil] !=YES)
        NSLog(@"Unable to delete file");
    
}

/*****************************/
// Access Token Read Write
/*****************************/
#pragma mark Access Token Read/Write
/*
 -(void)writeAccessTokenPlist:(OAToken *)accessToken{
 
 //NSKeyedArchiver should be used here in the next iteration. It is much cleaner. This allowed custom data types to be store in plists.
 
 NSString *str=[NSString stringWithFormat:@"oauth_token=%@&oauth_token_secret=%@",accessToken.key, accessToken.secret];
 //NSLog([NSString stringWithFormat:@"This is str %@", str]);
 NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
 [savedStock setObject:str forKey:@"AccessToken"];
 [savedStock writeToFile:listPath atomically:YES];
 //[savedStock release];
 }
 
 //this is a method to read the AccessToken from the plist.
 -(OAToken *)readAcessTokenPlist{
 //NSKeyedUnarchiver will be used here to retrieve the original object.
 NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
 NSString *value = [savedStock objectForKey:@"AccessToken"];
 OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:value];
 
 // NSLog([NSString stringWithFormat:@"This is value %@", value]);
 // NSLog([NSString stringWithFormat:@"This is value %@", token.key]);
 // NSLog([NSString stringWithFormat:@"This is value %@", token.secret]
 // );
 //[savedStock release];
 return token;
 }
 
 */

@end

