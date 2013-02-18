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

/*
-(void)setExperiencePoints:(double)experiencePoints{
    if (!self.experiencePoints){
        self.experiencePoints = 0;}
    
    grab self.experiencePoints from a pList somewhere
}
 */

-(void)updateSlider{
    // get image
    CCSprite *slider = [CCSprite spriteWithFile:@"slider.png"];
    [self updateExperiencePoints];
    
    
    // where do I place the image?
    CGPoint startPoint = ccp(31, 391);
    slider.position = ccp(self.experiencePoints + startPoint.x, startPoint.y);
    NSLog(@"The Slider Position is %f", slider.position.x);
    
    // set scale
    [slider setScaleX:.5];
    [slider setScaleY:.5];
    
    // add to scene
    [self addChild:slider z:0];
}

-(void)updateExperiencePoints{
    GameData *gamedata2 = [[GameData alloc]init];
    
    self.experiencePoints = [gamedata2 readPointsPlist]/20;
    NSLog(@"My GameData is: %f", self.experiencePoints*20);
    NSLog(@"My Activity Score is: %f", [gamedata2 readActivityScorePlist]);
    NSLog(@"My Experience Points Are: %f", self.experiencePoints);
    
}
@end
