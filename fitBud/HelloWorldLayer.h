//
//  HelloWorldLayer.h
//  fitBud
//
//  Created by Mohammod Arafat on 1/6/13.
//  Copyright CUNY City College 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"



// HelloWorldLayer
@interface HelloWorldLayer : CCLayer {
}

@property double experiencePoints;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
