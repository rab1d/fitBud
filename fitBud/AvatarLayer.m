//
//  AvatarLayer.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/25/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "AvatarLayer.h"


@implementation AvatarLayer

@synthesize body, head;

-(void)updateAvatar{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    self.body = [CCSprite spriteWithFile:@"b3_jj1.png"];
    self.body.position = ccp(winSize.width/2, winSize.height/2);
    [self.body setScale:.25];
    [self addChild:self.body z:0 tag:1];
    
}



-(void)avatarBounce{
    
    id action = [CCMoveBy actionWithDuration:.2 position:ccp(0,20)];
    id action2 = [CCRepeat actionWithAction:
                  [CCSequence actions: [action copy] , [action reverse], nil]
                                      times: 6
                  ];
    CCSprite *sprite = self.body;
    [sprite runAction:action2];
}

-(void)eggRock{
    id a1 = [CCRotateBy actionWithDuration:1    angle:5];
    id a2 = [CCRotateBy actionWithDuration:1    angle:-5];
    id action2 = [CCRepeatForever actionWithAction:
                  [CCSequence actions: [a1 copy] , [a1 reverse], [a2 copy] , [a2 reverse], nil]
                  ];
    
    [self.body runAction:action2];
}




@end
