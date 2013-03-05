//
//  GameData.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

// GameData is designed to receive JSON Data, send it to GameBrain for managing
// and storing and retrieving information in an internal database

#import "GameData.h"
// #import "GameDataBrain.h"

@interface GameData()
@property (strong,nonatomic) NSString *listPath;
// @property (strong, nonatomic) GameDataBrain *myGDBrain;
@end

@implementation GameData
@synthesize listPath;
//@synthesize activityPoints = _activityPoints;
//@synthesize experiencePoints = _experiencePoints;
//@synthesize myGDBrain = _myGDBrain;


#pragma mark Initialization

// At start
-(id)init{
    // [super init];
    [self plistStartup];
    //self.activityPoints = [self readActivityPoints];
    //self.experiencePoints = [self readExperiencePoints];
    NSLog(@"GameData || init. actPoints = %f, expPoints = %f", [self readActivityPoints], [self readActivityPoints]);
    return self;
}

-(void)setActivityPoints:(double)activityPoints{
    self.activityPoints = [self readActivityPoints];
}

-(void)setExperiencePoints:(double)experiencePoints{
    self.experiencePoints = [self readExperiencePoints];
}


-(void)plistStartup{
    listPath = [[self documentDirectory] stringByAppendingPathComponent:@"fitBudData.plist"];
    
    // DEBUG: If manually editing pList, run this function
    // [self clearListPlistFile:listPath];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:listPath]){
        
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"fitBudData" ofType:@"plist"] toPath:listPath error:nil];
        
    }
}



-(NSString *)documentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}


/*****************************/
// Sync Data
/*****************************/
#pragma mark Sync Data

-(void)syncGameData{
    //Call OAuth
    FitbitViewController *FBView = [[FitbitViewController alloc] init];
    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    [app.navController pushViewController:FBView animated:YES];
    
    [self parseData:[FBView returnDataDictionary]];
    
}

- (void)parseData:(NSDictionary*)jsonData{
    
    double steps =           [[[jsonData objectForKey:@"summary"] objectForKey:@"steps"] doubleValue];
    double caloriesOut =     [[[jsonData objectForKey:@"summary"] objectForKey:@"caloriesOut"] doubleValue];
    double activityScore =   [[[jsonData objectForKey:@"summary"] objectForKey:@"activityScore"] doubleValue];
    

     [self receiveDataWithDate:[NSDate date] caloriesOut:caloriesOut steps:steps activeScore:activityScore];
}

-(void)receiveDataWithDate:(NSDate *)syncDate caloriesOut:(double)caloriesOut steps:(double)numSteps activeScore:(double)activeScore{
    
    //NSLog(@"GameData||receiveData. activeScore array before write: %@", [self readActiveScoreArray]);
    
    // once received we:
    // 1. call the write methods for calories, steps, and activeScore and Date
    [self writeCaloriesOutPlist:caloriesOut writeStepsPlist:numSteps writeActivityScorePlist:activeScore date:syncDate];
    
    //NSLog(@"GameData||receiveData. activeScore array after write: %@", [self readActiveScoreArray]);
    
    // 2. pass the calories, step and active score data to another class called GameDataBrain. GameDataBrain will use the data to modify the experiencePoints and the activityPoints properties
    
    
    // 4. We write self.activityPoints and self.experiencePoints to the pList, and update the Last Sync Date
    [self writeExperiencePoints:[self calculateExperiencePoints:[self readActiveScoreArray]]];
    [self writeActivityPoints:[self calculateActivityPoints:[self readActiveScoreArray]]];
    [self writeSyncDate:[NSDate date]];
    
}

/*****************************/
// Sync Data
/*****************************/
#pragma mark Send Data

-(double)sendActivityPoints{
    return [self calculateActivityPoints:[self readActiveScoreArray]];
}

-(double)sendExperiencePoints{
    return [self calculateExperiencePoints:[self readActiveScoreArray]];
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
    
    
    //NSLog(@"Cal: %f, Steps: %f, Act: %f, Date: %@", caloriesOut, steps, activityScore, syncDate);
    
    // Get my pList
    NSMutableDictionary *myPListDictionary = [self getListContents];
    NSMutableDictionary *myGameDataDictionary = [self readGameData];
    //NSLog(@" GameData|| write. Whole Dictionary before write: %@", myPListDictionary);
    
    // grab calories array and add new calorie
    NSMutableArray *caloriesArray = [self readCaloriesOutArray];
    [caloriesArray addObject:[NSNumber numberWithFloat:caloriesOut]];
    //NSLog(@"GameData|| write.  Calories Array before write:%@", caloriesArray);
    
    // grab steps array and add new steps
    NSMutableArray *stepsArray = [self readStepsArray];
    [stepsArray addObject:[NSNumber numberWithFloat:steps]];
    //NSLog(@"GameData|| write. Steps Array before write: %@", stepsArray);
    
    
    // grab activity score array and add new activity score
    NSMutableArray *scoreArray = [self readActiveScoreArray];
    [scoreArray addObject:[NSNumber numberWithFloat:activityScore]];
    //NSLog(@"GameData|| write. Score Array before write: %@", scoreArray);
    
    
    // grab date array and add new date
    NSMutableArray *datesArray = [self readDateArray];
    [datesArray addObject:syncDate];
    //NSLog(@"GameData|| write. Dates Array before write: %@", datesArray);
    
    
    // add arrays to the pList dictionary
    [myGameDataDictionary setObject:caloriesArray forKey:@"Calories Out"];
    [myGameDataDictionary setObject:stepsArray forKey:@"Steps"];
    [myGameDataDictionary setObject:scoreArray forKey:@"Active Score"];
    [myGameDataDictionary setObject:datesArray forKey:@"Date"];
    [myPListDictionary setObject:myGameDataDictionary forKey:@"Game Data"];
    
    // save temp Game Data dictionary to pList
    [myPListDictionary writeToFile:listPath atomically:YES];
    
     //NSLog(@" GameData|| write. Whole Dictionary after write: %@", myPListDictionary);
    
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


 //reads the plsit and returns the points value
 -(NSMutableDictionary *)readGameData{
     NSMutableDictionary *plistContents = [self getListContents];
     NSMutableDictionary *dataDictionary = [plistContents objectForKey:@"Game Data"];
    // NSLog(@"gd Game data: %@", dataDictionary);
     return dataDictionary;
 }
 

-(NSMutableArray *)readActiveScoreArray{
    NSMutableDictionary *plistContents = [self readGameData];
    NSMutableArray *scoreArray = [plistContents objectForKey:@"Active Score"];
    return scoreArray;
}

-(NSMutableArray *)readCaloriesOutArray{
    NSMutableDictionary *plistContents = [self readGameData];
    NSMutableArray *calArray = [plistContents objectForKey:@"Calories Out"];
    //NSLog(@"Calories Array: %@", calArray);
    return calArray;
}

-(NSMutableArray *)readStepsArray{
    NSMutableDictionary *plistContents = [self readGameData];
    NSMutableArray *stepsArray = [plistContents objectForKey:@"Steps"];
    return stepsArray;
}

-(NSMutableArray *)readDateArray{
    NSMutableDictionary *plistContents = [self readGameData];
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
// Brain Functionality
/*****************************/
#pragma mark Calculate Experience Points and Activit Points

-(double)calculateActivityPoints:(NSArray*)activeScoreArray{
    NSMutableArray *temp = [activeScoreArray mutableCopy];
    double result;
    //NSLog(@"DataBrain || calcActivityPoints. Received activeScoreArray: %@", activeScoreArray);
    
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
    //NSLog(@"DataBrain || calcActivityPoints. Calculated Activity Points = %f", result);
}
-(double)calculateExperiencePoints:(NSArray*)activeScoreArray{
    NSInteger sum = 0;
    for (NSNumber *num in activeScoreArray)
    {
        sum += [num doubleValue];
    }
    
    return sum;
}


/*
[self writeExperiencePoints:[self.myGDBrain calculateExperiencePoints:[self readActiveScoreArray]]];
[self writeActivityPoints:[self.myGDBrain calculateActivityPoints:[self readActiveScoreArray]]];
[self writeSyncDate:[NSDate date]];
*/

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
