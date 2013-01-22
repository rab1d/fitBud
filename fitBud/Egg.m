//
//  Egg.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "Egg.h"


@implementation Egg
@synthesize eggSprite;

-(void)loadEgg{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    self.eggSprite = [CCSprite spriteWithFile:@"egg.png"];
    self.eggSprite.position = ccp(winSize.width/2, winSize.height/2);
    [self.eggSprite setScaleX:.5];
    [self.eggSprite setScaleY:.5];
    [self addChild:self.eggSprite z:0];
    self.eggSprite.tag = 1;
    
    
    
    
    //    self.isTouchEnabled = YES;
    
}

-(void)eggBounce{
    
    // Bounce at the beginning and at the end
    //id move = [CCMoveBy actionWithDuration:3 position:ccp(350,0)];
    //id action = [CCEaseBounceInOut actionWithAction:move];
    
    //return action;
    //CCSprite *sprite = (CCSprite *)[self getChildByTag:1];
    //[sprite runAction: action];
    
    
   // id a1 = [CCRotateBy actionWithDuration:2 angle:10
    // id action2 = [CCRepeatForever actionWithAction:];
             //[CCRepeatForever actionWithAction:[CCSequence actions: a1, [a1 reverse], nil]];
   // [sprite runAction: action2];
}




@end

/*-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 UITouch * touch = [touches anyObject];
 
 //get touch coordinated
 CGPoint location = [touch locationInView:[touch view]];
 location = [[CCDirector sharedDirector] convertToGL:location];
 
 
 CCLOG(@"touch happened at x: %0.2f, y: %0.2f", location.x, location.y);
 
 }*/


