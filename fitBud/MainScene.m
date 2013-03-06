//
//  MainScene.m
//  fitBud
//
//  Created by Mohammod Arafat on 2/24/13.
//  Copyright 2013 CUNY City College. All rights reserved.
//

#import "MainScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "FitbitViewController.h"

@interface MainScene ()
@property (strong,nonatomic) UIWebView *googleView;
@property (nonatomic) CGSize windowSize;
@property (nonatomic) AvatarLayer *myAvatar;
@property (nonatomic) BOOL syncMenuDisplayed;

@end

@implementation MainScene

// Experience points need to be fetched from somewhere
//@synthesize experiencePoints = _experiencePoints;
@synthesize windowSize  = _windowSize;
@synthesize SliderLayer = _SliderLayer;
@synthesize myAvatar = _myAvatar;
@synthesize syncMenuDisplayed;

#pragma mark Initial Stuff

-(void)setWindowSize:(CGSize)winSize{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
}


-(Slider *)SliderLayer{
    if(!_SliderLayer) _SliderLayer = [Slider node];
    return _SliderLayer;
}

-(AvatarLayer *)myAvatar{
    if(!_myAvatar) _myAvatar = [AvatarLayer node];
    return _myAvatar;
}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *layer = [MainScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

/******************************/
// Init and On Enter
/******************************/
#pragma mark Init and On Enter

/*
 -(void)onEnter{
 NSLog(@"You have entered");
 
 //[self.EggLayer eggRock];
 
 }
 */
/*
-(void)onEnterTransitionDidFinish{
    [self.SliderLayer updateSlider:self.experiencePoints];
}*/

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
    
	if( (self=[super init]) ) {
        self.isTouchEnabled = YES;

        //get user game data
        
        
        // Load assets
        [self loadSliderLayer];
        [self loadAvatar];
        [self loadButtons];
        [self loadBackground];
        
        // give some life to the avatar
        [self.myAvatar avatarRock];
	}
    
	return self;
}





/**************************************************/
// Load Initial Sprites
/**************************************************/
#pragma mark Load Initial Sprites 

-(void) loadAvatar{
    
    //load egg
    // [self addChild:self.EggLayer z:1];
    //[self.EggLayer loadEgg];
    
     // load dog
     [self addChild: self.myAvatar z:20];
     [self.myAvatar updateAvatarbyExperience:self.experiencePoints andActivity:self.activityPoints];
     
    
};


-(void) loadSliderLayer{
    //Slider * sliderLayer = [Slider node];
    // NSLog(@"Slider loaded");
    [self addChild: self.SliderLayer z:0];
    [self.SliderLayer updateSlider:self.experiencePoints];
    
};

-(void) loadBackground{
    // add the background
    CCSprite *background = [CCSprite spriteWithFile:@"main-background.png"];
    background.anchorPoint = ccp(0,0);
    
    background.position = ccp(0,0);
    //background.position = ccp(self.windowSize.width/2, self.windowSize.height/2);
    [self addChild:background z:-1];
};


-(void) loadButtons{
    CCMenuItemImage *syncItem = [CCMenuItemImage itemWithNormalImage:@"sync-button.png"
                                                       selectedImage: @"sync-button-pressed.png"
                                                              target:self
                                                            selector:@selector(syncBudWithFitBit:)];
    syncItem.position = ccp(85, 31);
    [syncItem setScaleX:.5]; [syncItem setScaleY:.5];
    
    CCMenuItemImage *logItem = [CCMenuItemImage itemWithNormalImage:@"log-button.png"
                                                      selectedImage: @"log-button-pressed.png"
                                                             target:self
                                                           selector:@selector(getLoggedData:)];
    logItem.position = ccp(238, 37);
    [logItem setScaleX:.5]; [logItem setScaleY:.5];
    
    // Create a menu and add your menu items to it
    CCMenu * myMenu = [CCMenu menuWithItems:syncItem, logItem, nil];
    myMenu.position = CGPointZero;
    // Arrange the menu items vertically
    //[myMenu alignItemsVertically];
    
    // add the menu to your scene
    [self addChild:myMenu z:1];
};

#pragma mark Update Slider and Avatar and Properties
-(void)updateExperiencePoints:(double)exp AndActivityPoints:(double)act{
    self.experiencePoints = exp;
    self.activityPoints = act;
}

-(void)updateSlider{
    [self.SliderLayer removeChildByTag:1];
    [self.SliderLayer updateSlider:self.experiencePoints];

}

-(void)updateAvatar{
    [self.myAvatar removeChildByTag:1];
    [self.myAvatar updateAvatarbyExperience:self.experiencePoints andActivity:self.activityPoints];
}

/**************************************************/
// Touches
/**************************************************/
#pragma mark Touch Events 

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    
    //get touch coordinated
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
    //logs where you have touch in the screen
    NSLog(@"touch happened at x: %0.2f, y: %0.2f", location.x, location.y);
    
    //if avatar is touch, calls an animate
    //if (CGRectContainsPoint([self.EggLayer.eggSprite boundingBox], location)){
      if (CGRectContainsPoint([self.myAvatar.body boundingBox], location)){
        [self avatarTouched];
    } else {
        [self bgTouched:location];
    }
    
}

-(void)avatarTouched{
    [self.myAvatar avatarBounce];
}

-(void)bgTouched:(CGPoint)location{
    //move avatar to the touched position
    
    id moveAction = [CCMoveTo actionWithDuration:5 position:location];
    id bounceAction = [CCMoveBy actionWithDuration:.2 position:ccp(0,20)];
    
    id action2 = [CCRepeat actionWithAction:
                  [CCSequence actions: [bounceAction copy], [bounceAction reverse], nil]
                                      times: 6
                  ];
    
    [self.myAvatar.body runAction:moveAction];
}

/**************************************************/
// Buttons
/**************************************************/
#pragma mark Buttons

- (void) syncBudWithFitBit: (CCMenuItem  *) menuItem
{
	NSLog(@"The sync menu was called");
    [self loadSyncButtons];
    self.syncMenuDisplayed = TRUE;
}


- (void) getLoggedData: (CCMenuItem  *) menuItem
{
	NSLog(@"The log menu was called");
}


#pragma mark Sync Layer

/**************************************************/
// Actions
/**************************************************/
// Should only be call once at a time
-(void) loadSyncButtons{
    if(!self.syncMenuDisplayed){
    CCMenuItemFont *lazy = [CCMenuItemFont itemWithString:@"Lazy" target:self selector:@selector(doLazySync)];
    CCMenuItemFont *medium = [CCMenuItemFont itemWithString:@"Medium" target:self selector:@selector(doMediumSync)];
    CCMenuItemFont *marathoner = [CCMenuItemFont itemWithString:@"Marathoner" target:self selector:@selector(doMarathonerSync)];
    CCMenuItemFont *fitBitSync = [CCMenuItemFont itemWithString:@"FitBit Sync" target:self selector:@selector(syncAvailability)];
    
    CCMenuItemFont *back = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(removeSyncLayer)];
    
    CCMenu *myMenu = [CCMenu menuWithItems:lazy, medium, marathoner, fitBitSync, back, nil];
    [myMenu alignItemsVertically];
    [self addChild:myMenu z:100 tag:40];
    }
};


-(void)doLazySync{
    double steps =           10;
    double caloriesOut =     10;
    double activityScore =   10;
    
    //posible problem here as the gamedata function should not be called. Improper MVC model
    GameData *gameData = [[GameData alloc]init];
    [gameData receiveDataWithDate:[NSDate date] caloriesOut:caloriesOut steps:steps activeScore:activityScore];
    double exp = [gameData sendExperiencePoints];
    double act = [gameData sendActivityPoints];
    [self updateExperiencePoints:exp AndActivityPoints:act];
    NSLog(@"syncScene||doMarathonerSync. experiencePoints: %f, activityPoints: %f", exp, act);
    
    [self updateSlider];
    [self updateAvatar];
    [self removeSyncLayer];
    
}

-(void)doMediumSync{
    double steps =           500;
    double caloriesOut =     250;
    double activityScore =   100;
    
    //posible problem here as the gamedata function should not be called. Improper MVC model
    GameData *gameData = [[GameData alloc]init];
    [gameData receiveDataWithDate:[NSDate date] caloriesOut:caloriesOut steps:steps activeScore:activityScore];
    double exp = [gameData sendExperiencePoints];
    double act = [gameData sendActivityPoints];
    
    [self updateExperiencePoints:exp AndActivityPoints:act];
    NSLog(@"syncScene||doMarathonerSync. experiencePoints: %f, activityPoints: %f", exp, act);
    
    [self updateSlider];
    [self updateAvatar];
    [self removeSyncLayer];
    
    
}

-(void)doMarathonerSync{
    double steps =           1500;
    double caloriesOut =     750;
    double activityScore =   500;
    
    //posible problem here as the gamedata function should not be called. Improper MVC model
    GameData *gameData = [[GameData alloc]init];
    [gameData receiveDataWithDate:[NSDate date] caloriesOut:caloriesOut steps:steps activeScore:activityScore];
    
    //[gameData release];
    double exp = [gameData sendExperiencePoints];
    double act = [gameData sendActivityPoints];
    [self updateExperiencePoints:exp AndActivityPoints:act];
   
    
    NSLog(@"syncScene||doMarathonerSync. experiencePoints: %f, activityPoints: %f", exp, act);
    [self updateSlider];
    [self updateAvatar];
    [self removeSyncLayer];
    
    
}

-(void)doFitBitSync:(NSNotification *)note{
    Reachability * reach = [note object];
    
    if ([reach isReachable])
    {
    GameData *gameData = [[GameData alloc]init];
    [gameData syncGameData];
   
    double exp = [gameData sendExperiencePoints];
    double act = [gameData sendActivityPoints];
    [self updateExperiencePoints:exp AndActivityPoints:act];
    NSLog(@"syncScene||doMarathonerSync. experiencePoints: %f, activityPoints: %f", exp, act);
    [self updateSlider];
    [self updateAvatar];
    [self removeSyncLayer];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Sorry!!"
                              message: @"We could not sync your Fitbit data because there is no Internet connection available."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



-(void)removeSyncLayer{
    [self removeChildByTag:40];
    self.syncMenuDisplayed = FALSE;
}

#pragma mark Setup Data Connection Check

//Could possibly make this reuseable but there is only one function in this class that requires data.
//Possibly will need to convert these to blocks and run a spinning wheel in the UI.
-(void)syncAvailability{
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doFitBitSync:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
}



@end
