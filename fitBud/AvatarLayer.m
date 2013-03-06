//
//  AvatarLayer.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/25/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "AvatarLayer.h"
@interface AvatarLayer()
@property double experiencePoints;
@property double activityPoints;
//@property
-(NSString *)getLevel2HealthPicture:(double)act;
@end

@implementation AvatarLayer

@synthesize body, level, experiencePoints, activityPoints;


#pragma mark Avatar Update
-(void)updateAvatarbyExperience:(double)exp andActivity:(double)act{
    self.experiencePoints = exp;
    self.activityPoints = act;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // Which sprite am I? (based on experience Points)
    self.body = [CCSprite spriteWithFile:[self avatarName]];

    //How does the sprite look? (based on activitiy points);
    [self.body setScale:.25];
    //[self shouldGetMoreFit:[self didWorkOutHard]];
    
    
    // Place at the center of the screen
    self.body.position = ccp(winSize.width/2, winSize.height/2);
    
    // Add it to the layer
    [self addChild:self.body z:0 tag:1];
    
    NSLog(@"AvatarLayer||updateAvatar: exp: %f, act: %f:", self.experiencePoints, self.activityPoints);
    
}



-(NSString *)avatarName{
    NSString *avatarSpriteFile;
       
    switch ([self updateLevel]) {
        case 1:
            avatarSpriteFile= @"egg.png";
            
            break;
        case 2:
       //     [self getLevel2HealthPicture:self.activityPoints];
            avatarSpriteFile = @"b3_jj1.png";
            break;
        default:
            break;
    }

    NSLog(@"AvatarLayer || avatarname. Current Level %d", self.level); 
    return avatarSpriteFile;
}



-(int)updateLevel{
    if(self.experiencePoints < LEVEL_2){
        self.level = 1;
    }else if (self.experiencePoints >= LEVEL_2){
        self.level = 2;
    }
    return self.level;
}




#pragma mark Fatter/Skinnier
-(void)shouldGetMoreFit:(BOOL)didWorkOutHard{
    if(didWorkOutHard){
        self.body.scaleX = self.body.scaleX * 0.9;
        self.body.scaleY = 0.25;
    } else {
        self.body.scaleX = self.body.scaleX * 1.2;
        self.body.scaleY = 0.25;
    }
    
}

-(BOOL)didWorkOutHard{
    if (self.activityPoints > 500){
        return TRUE;
    } else { return FALSE;
    }
    
}


#pragma mark Avatar Animations

-(void)avatarBounce{
    
    id action = [CCMoveBy actionWithDuration:.2 position:ccp(0,20)];
    id action2 = [CCRepeat actionWithAction:
                  [CCSequence actions: [action copy] , [action reverse], nil]
                                      times: 6
                  ];
    CCSprite *sprite = self.body;
    [sprite runAction:action2];
}

-(void)avatarRock{
    id a1 = [CCRotateBy actionWithDuration:1    angle:5];
    id a2 = [CCRotateBy actionWithDuration:1    angle:-5];
    id action2 = [CCRepeatForever actionWithAction:
                  [CCSequence actions: [a1 copy] , [a1 reverse], [a2 copy] , [a2 reverse], nil]
                  ];
    
    [self.body runAction:action2];
}

/*
//this should probably not be done here...but in a model.
-(NSString *)getLevel2HealthPicture:(double)act{
    NSString *result;
    switch ((int)act) {
        case 0 ... 2:
            result = lvl1_avatar1;
            break;
        case 3 ... 5:
            result = lvl2_avatar1;
            break;
        case 6 ... 1000000:
            result = lvl2_avatar3;
            break;
    }
    return result;
}
*/

@end
