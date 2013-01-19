//
//  GameData.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

#import "GameData.h"

@implementation GameData

-(void)loadUserData{
    // Try to load game save data
    // Find the Directory with PList
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * userDataName = @"UserData";
    
    /*
     if(![fileManager fileExistsAtPath:userDataName])
     {
      NSError *error;
      NSString * sourcePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
      [fileManager copyItemAtPath:sourcePath toPath:finalPath error:&error];
     
      //open to the login and setup layer
     
    [self loadMyViewController];
    /*
     } else{
     */
    //   [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
    //  }

    
}

@end
