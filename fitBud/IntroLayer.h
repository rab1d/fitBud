//
//  IntroLayer.h
//  fitBud
//
//  Created by Mohammod Arafat on 1/6/13.
//  Copyright CUNY City College 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameData.h"
#import "HelloWorldLayer.h"
#import "FitbitViewController.h"
#import "AppDelegate.h"

// HelloWorldLayer
@interface IntroLayer : CCLayer 
{
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
