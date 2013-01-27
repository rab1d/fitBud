//
//  GameData.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

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
@property (strong,nonatomic) NSString *listpath;
@end

@implementation GameData
@synthesize listpath;

-(id)init{
    [super init];
    [self plistStartup];
    return self;
}

-(NSString *)docsDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

-(void)plistStartup{
    ///Prob put stuff
    listpath = [[self docsDir] stringByAppendingPathComponent:@"plist.plist"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:listpath]){
        //NSLog([NSString stringWithFormat:@"ssgg %@",listpath]);
        ///the plist will not exist in the document directory for first use of app.
        [[NSFileManager defaultManager]copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"plist" ofType:@"plist"] toPath:listpath error:nil];
    }
}


-(void)writeAccessTokenPlist:(OAToken *)accessToken{
    //NSKeyedArchiver should be used here in the next iteration. It is much cleaner. This allowed custom data types to be store in plists.******************************/
    NSString *str=[NSString stringWithFormat:@"oauth_token=%@&oauth_token_secret=%@",accessToken.key, accessToken.secret];
    NSLog([NSString stringWithFormat:@"This is str %@", str]);
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: listpath];
    [savedStock setObject:str forKey:@"AccessToken"];
    [savedStock writeToFile:listpath atomically:YES];
    [savedStock release];
}

//this is a method to read the AccessToken from the plist.
-(OAToken *)readAcessTokenPlist{
    //NSKeyedUnarchiver will be used here to retrieve the original object.
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: listpath];
    NSString *value = [savedStock objectForKey:@"AccessToken"];
    OAToken *token = [[OAToken alloc] initWithHTTPResponseBody:value];
    /*
     NSLog([NSString stringWithFormat:@"This is value %@", value]);
     NSLog([NSString stringWithFormat:@"This is value %@", token.key]);
     NSLog([NSString stringWithFormat:@"This is value %@", token.secret]
     );*/
    [savedStock release];
    return token;
}

//this will write the "points" or xp to the plist
//improvement needs to made so that when program is synced it does not keep accumulating total calories but rather only adds that which has not been added since the last sync. Possibly can be done by using the date and subtracting the current days totals.
-(void)writeCaloriesOutPlist:(NSString *)caloriesOut wirteStepsPlist:(NSString *)steps{
    //possible future improvement could be to have a dictionary as a class property.
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: listpath];
    //remove the pointer here because we are adding.
    //add the previous points to the current one.
    NSInteger intCaloriesOut = [caloriesOut intValue];
    NSInteger intSteps = [steps intValue];
    
    intCaloriesOut+=intSteps;
    //%d is for ints
    NSString *temp = [NSString stringWithFormat:@"%d",intCaloriesOut];
    [dictionary setObject:temp forKey:@"Points"];
    [dictionary writeToFile:listpath atomically:YES];
}

//reads the plsit and returns the points value
-(double)readPointsPlist{
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: listpath];
    double value = [[savedStock objectForKey:@"Points"] doubleValue];
    return value;
}


//this is used to delete the plist file fromt the NSFileManager. The file is still in the App Bundle however.
-(void)clearListPlistFile:(NSString *)str{
    //further improvements can be made here as the error can be specified particularly instead of being set to nil.
    if( [[NSFileManager defaultManager] removeItemAtPath:str error:nil] !=YES)
        NSLog(@"Unable to delete file");
    
}



@end
