//
//  AvatarLayer.h
//  fitBud
//
//  Created by Mohammod Arafat on 1/25/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
// #import "GameData.h"
#include "Constants.h"

@interface AvatarLayer : CCLayer {
    
}


@property CCSprite *body;
@property int level;
//@property GameData *brain;

//@property CCSprite *head;
//@property CCSprite *mouth;
//@property CCSprite *hands;
//@property CCSprite *feet;

-(void)updateAvatarbyExperience:(double)exp andActivity:(double)act;
-(void)avatarBounce;
-(void)avatarRock;

@end
