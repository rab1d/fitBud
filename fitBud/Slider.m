//
//  Slider.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/21/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "Slider.h"

@implementation Slider
@synthesize experiencePoints = _experiencePoints;

-(void)setExperiencePoints:(double)experiencePoints{
    if (!self.experiencePoints){
        self.experiencePoints = 0;}
    
    //grab self.experiencePoints from a pList somewhere
}

-(void)updateSlider{
    // get image
    CCSprite *slider = [CCSprite spriteWithFile:@"slider.png"];
    
    // where do I place the image?
    CGPoint startPoint = ccp(31, 391);
    slider.position = ccp(self.experiencePoints + startPoint.x, startPoint.y);
    
    // set scale
    [slider setScaleX:.5];
    [slider setScaleY:.5];
    
    // add to scene
    [self addChild:slider z:0];
    
}

@end
