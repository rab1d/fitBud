//
//  Egg.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/16/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "Egg.h"


@implementation Egg
@synthesize eggSprite, hair, mouth, hands, feet;

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
    
    id action = [CCMoveBy actionWithDuration:.2 position:ccp(0,20)];
    id action2 = [CCRepeat actionWithAction:
                  [CCSequence actions: [[action copy] autorelease], [action reverse], nil]
                                      times: 6
                  ];
    CCSprite *sprite = self.eggSprite;
    [sprite runAction:action2];
}

-(void)eggRock{
    id a1 = [CCRotateBy actionWithDuration:1    angle:5];
    id a2 = [CCRotateBy actionWithDuration:1    angle:-5];
    id action2 = [CCRepeatForever actionWithAction:
                  [CCSequence actions: [[a1 copy] autorelease], [a1 reverse], [[a2 copy] autorelease], [a2 reverse], nil]
                  ];

    [self.eggSprite runAction:action2];
}



@end

/*-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 UITouch * touch = [touches anyObject];
 
 //get touch coordinated
 CGPoint location = [touch locationInView:[touch view]];
 location = [[CCDirector sharedDirector] convertToGL:location];
 
 
 CCLOG(@"touch happened at x: %0.2f, y: %0.2f", location.x, location.y);
 
 }*/


