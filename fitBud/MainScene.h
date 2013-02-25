//
//  MainScene.h
//  fitBud
//
//  Created by Mohammod Arafat on 2/24/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//
#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Egg.h"
#import "Slider.h"
#import "AvatarLayer.h"

#import "syncScene.h"

@interface MainScene : CCLayer {
    
}

// @property double experiencePoints;
@property (nonatomic) Slider *SliderLayer;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
