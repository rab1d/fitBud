//
//  AvatarLayerBrain.h
//  fitBud
//
//  Created by Mohammod Arafat on 2/25/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "AvatarLayer.h"
// #import "GameData.h"
// #import "MainScene.h"


@interface AvatarLayerBrain : CCLayer {
    
}

//@property GameData *gameDataClass;
@property NSString *AvatarSprite;


-(void)updateSprite;

// I want AvatarLayerBrain to accept GameData's experiencePoints and activityPoints and decide when to evolve. 


@end
