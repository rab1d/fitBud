//
//  syncScene.m
//  fitBud
//
//  Created by Mohammod Arafat on 2/24/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "syncScene.h"


@implementation syncScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.

/*
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	syncScene *layer = [syncScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
 */

-(id)init{
    if( (self=[super init]) ) {
        //[self loadBackground];
        [self loadButtons];
    }
    
    return self;
}



-(void) loadBackground{
        // add the background
        CCSprite *background = [CCSprite spriteWithFile:@"main-background.png"];
        background.anchorPoint = ccp(0,0);
        
        background.position = ccp(0,0);
        //background.position = ccp(self.windowSize.width/2, self.windowSize.height/2);
        [self addChild:background z:-1];
};

-(void) loadButtons{
    CCMenuItemFont *lazy = [CCMenuItemFont itemWithString:@"Lazy" target:self selector:@selector(doLazySync)];
    CCMenuItemFont *medium = [CCMenuItemFont itemWithString:@"Medium" target:self selector:@selector(doMediumSync)];
    CCMenuItemFont *marathoner = [CCMenuItemFont itemWithString:@"Marathoner" target:self selector:@selector(doMarathonerSync)];
    CCMenuItemFont *fitBitSync = [CCMenuItemFont itemWithString:@"FitBit Sync" target:self selector:@selector(doFitBitSync)];
    CCMenuItemFont *back = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBackToMainScene)];
    
    CCMenu *myMenu = [CCMenu menuWithItems:lazy, medium, marathoner, fitBitSync, back, nil];
    [myMenu alignItemsVertically];
    [self addChild:myMenu z:1];
    
};


-(void)doLazySync{
    double steps =           10;
    double caloriesOut =     10;
    double activityScore =   10;
    
    //posible problem here as the gamedata function should not be called. Improper MVC model
    GameData *gameData = [[GameData alloc]init];
    [gameData receiveDataWithDate:[NSDate date] caloriesOut:caloriesOut steps:steps activeScore:activityScore];
    //[gameData release];
    
    NSLog(@"syncScene||doLazySync. experiencePoints: %f, activityPoints: %f", [gameData sendExperiencePoints], [gameData sendActivityPoints]);
    
    [self goBackToMainScene];
    
}

-(void)doMediumSync{
    double steps =           500;
    double caloriesOut =     250;
    double activityScore =   50;
    
    //posible problem here as the gamedata function should not be called. Improper MVC model
    GameData *gameData = [[GameData alloc]init];
    [gameData receiveDataWithDate:[NSDate date] caloriesOut:caloriesOut steps:steps activeScore:activityScore];
    //[gameData release];
    NSLog(@"syncScene||doMediumSync. experiencePoints: %f, activityPoints: %f", [gameData sendExperiencePoints], [gameData sendActivityPoints]);
    [self goBackToMainScene];
  

}

-(void)doMarathonerSync{
    double steps =           1500;
    double caloriesOut =     750;
    double activityScore =   10000;
    
    //posible problem here as the gamedata function should not be called. Improper MVC model
    GameData *gameData = [[GameData alloc]init];
    [gameData receiveDataWithDate:[NSDate date] caloriesOut:caloriesOut steps:steps activeScore:activityScore];
    //[gameData release];
    NSLog(@"syncScene||doMarathonerSync. experiencePoints: %f, activityPoints: %f", [gameData sendExperiencePoints], [gameData sendActivityPoints]);
    [self goBackToMainScene];
    

}

-(void)doFitBitSync{
    GameData *gameData = [[GameData alloc]init];
    [gameData syncGameData];

    /*
    FitbitViewController *FBView = [[FitbitViewController alloc] init];
    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    [app.navController pushViewController:FBView animated:YES];
    //[CCDirector sharedDirector].pause;
    
    [self goBackToMainScene];
    
    //[self.SliderLayer updateSlider];
    */
        NSLog(@"syncScene||doFitBitSync. experiencePoints: %f, activityPoints: %f", [gameData sendExperiencePoints], [gameData sendActivityPoints]);
}



-(void)goBackToMainScene{
     [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainScene scene] withColor:ccc3(0, 0, 0)]];
}


@end
