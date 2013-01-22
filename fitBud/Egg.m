//
//  Egg.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "Egg.h"


@implementation Egg


-(void)loadEgg{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *avatar = [CCSprite spriteWithFile:@"egg.png"];
    avatar.position = ccp(winSize.width/2, winSize.height/2);
    [avatar setScaleX:.5];
    [avatar setScaleY:.5];
    [self addChild:avatar z:0];
    avatar.tag = 1;
    
//    self.isTouchEnabled = YES;
    
}

@end

/*-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    
    //get touch coordinated
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
    CCLOG(@"touch happened at x: %0.2f, y: %0.2f", location.x, location.y);
    
}*/