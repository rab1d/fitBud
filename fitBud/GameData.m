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
        
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"plist" ofType:@"plist"] toPath:listPath error:nil];
        
    }
}

 

-(NSString *)documentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}


/*****************************/
// Access Token Read Write
/*****************************/
#pragma mark Access Token Read/Write

-(void)writeAccessTokenPlist:(OAToken *)accessToken{
    
    //NSKeyedArchiver should be used here in the next iteration. It is much cleaner. This allowed custom data types to be store in plists.******************************/
    
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
    /*
     NSLog([NSString stringWithFormat:@"This is value %@", value]);
     NSLog([NSString stringWithFormat:@"This is value %@", token.key]);
     NSLog([NSString stringWithFormat:@"This is value %@", token.secret]
     );*/
    //[savedStock release];
    return token;
}

/*****************************/
// PList Management: Receive Data
/*****************************/
#pragma mark Receive Data

-(void)receiveDataWithDate:(NSDate *)syncDate caloriesOut:(NSString *)caloriesOut steps:(NSString *)numSteps activeScore:(NSString *)activeScore{
    
    // once received we:
        // 1. call the write methods for calories, steps, and activeScore and Date
    
        // 2. pass the calories, step and active score data to another class called GameDataBrain
    
        // 3. GameDataBrain will use the data to modify the experiencePoints and the activityPoints properties
                    // self.activityPoints = sum(activeScore of last three daays
                    // self.experiencePoints = sum(all activeScore + sum all steps + sum all calories)
    
        // 4. We write self.activityPoints and self.experiencePoints to the pList, and update the Last Sync Date
    
    
}


/*****************************/
// PList Management: Write
/*****************************/
#pragma mark Write Data

// Write Steps, Calories and Activity Score to a PList
-(void)writeCaloriesOutPlist:(NSString *)caloriesOut writeStepsPlist:(NSString *)steps writeActivityScorePlist:(NSString *)activityScore{
    
    /*
     //possible future improvement could be to have a dictionary as a class property.
     NSMutableDictionary *myPListDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
     
     //Get experiencePoints
     self.experiencePoints = [self experiencePointCalculator];
     
     //Get activityPoints
     self.activityPoints = [self activityPointCalculator];
     
     
     //%d is for ints
     
     NSString *temp = [NSString stringWithFormat:@"%d",self.experiencePoints];
     NSString *temp2 = [NSString stringWithFormat:@"%d",self.activityPoints];
     
     [myPListDictionary setObject:temp forKey:@"Points"];
     [myPListDictionary setObject:temp2 forKey:@"ActivityScore"];
     [myPListDictionary writeToFile:listPath atomically:YES];
     [myPListDictionary release];
     
     */
}

-(void)writeExperiencePoints:(double)experiencePoints{
    
    
    NSMutableDictionary *myPListDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
    
    NSString *temp = [NSString stringWithFormat:@"%f", experiencePoints];
    
    [myPListDictionary setObject:temp  forKey:@"Experience Points"];
    [myPListDictionary writeToFile:listPath atomically:YES];
    //[myPListDictionary release];
}




/*****************************/
// PList Management: Read
/*****************************/
#pragma mark Read Data


//reads the plsit and returns the points value
-(NSDictionary *)readGameData{
    NSMutableDictionary *plistContents = [self getListContents];
    
    NSDictionary *dataDictionary = [plistContents objectForKey:@"Game Data"];
    
    NSLog(@"gd Game data: %@", dataDictionary);
    
    //[plistContents release];
    return dataDictionary;
}


-(double)readExperiencePoints{
    NSMutableDictionary *plistContents = [self getListContents];
   
    double expPoints = [[plistContents objectForKey:@"Experience Points"] doubleValue];
    
    //[plistContents release];
    return expPoints;
}

-(double)readActivityPoints{
    NSMutableDictionary *plistContents = [self getListContents];
    
    double actPoints = [[plistContents objectForKey:@"Activity Points"] doubleValue];
    //[plistContents release];
    NSLog(@"gd activity: %f", actPoints);
    return actPoints;
}


// Gives all the contents from the pList
-(NSMutableDictionary *)getListContents{
    NSMutableDictionary *plistContents = [[NSMutableDictionary alloc] initWithContentsOfFile: listPath];
    
    NSLog(@"gd plist: %@", plistContents);
    return plistContents;
    
}


/*****************************/
// Brain Functionality
/*****************************/
#pragma mark Brain Stuff
// this is where we either send stuff to the GameDataBrain
// or implement the methods our self.


/*
-(double)activityPointCalculator{
    // Sum the past 3 days of activity
    
    
    return 0;
}

-(double)experiencePointCalculatorWith:(NSString *)caloriesOut (NSString *):steps (NSString *):activityScore {
    // Sum all calories, steps and activity
    
    
    //remove the pointer here because we are adding.
    //add the previous points to the current one.
    NSInteger intCaloriesOut = [caloriesOut intValue];
    NSInteger intSteps = [steps intValue];
    NSInteger intActivityScore = [activityScore intValue];
    
    intCaloriesOut+=intSteps;
    return 0;
}

*/


#pragma mark Clear pList

//this is used to delete the plist file fromt the NSFileManager. The file is still in the App Bundle however.
-(void)clearListPlistFile:(NSString *)str{
    //further improvements can be made here as the error can be specified particularly instead of being set to nil.
    if( [[NSFileManager defaultManager] removeItemAtPath:str error:nil] !=YES)
        NSLog(@"Unable to delete file");
    
}



@end
