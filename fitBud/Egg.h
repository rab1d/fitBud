//
//  Egg.h
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Egg : CCLayer {

}
@property CCSprite *eggSprite;
@property CCSprite *hair;
@property CCSprite *mouth;
@property CCSprite *hands;
@property CCSprite *feet;

- (void) loadEgg;
- (void) eggBounce;
-(void) eggRock;

@end
