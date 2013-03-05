//
//  Slider.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/21/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "Slider.h"
//#import "MainScene.h"

@implementation Slider
// @synthesize experiencePoints = _experiencePoints;



-(void)updateSlider:(double)experiencePoints{
    // get image
    CCSprite *slider = [CCSprite spriteWithFile:@"slider.png"];
    
    
    // where do I place the image?
    
    CGPoint startPoint = ccp(30, 391);
    CGFloat maxPoint = 270;
    CGFloat xPos = fmod((experiencePoints/100), maxPoint);
    if(xPos >= 300){
        xPos = xPos - 300 + startPoint.x;
    }
    
    slider.position = ccp(xPos, startPoint.y);

    NSLog(@"The Slider Position is %f", slider.position.x);
    
    // set scale
    [slider setScaleX:.5];
    [slider setScaleY:.5];
    
    
    // add to scene
    [self addChild:slider z:0 tag:1];
}


@end
