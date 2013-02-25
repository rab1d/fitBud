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
@property (nonatomic) Egg *EggLayer;
@property (nonatomic) AvatarLayer *myAvatar;

@end

@implementation MainScene

// Experience points need to be fetched from somewhere
//@synthesize experiencePoints = _experiencePoints;
@synthesize windowSize  = _windowSize;
@synthesize EggLayer = _EggLayer;
@synthesize SliderLayer = _SliderLayer;
@synthesize myAvatar = _myAvatar;


#pragma mark Initial Stuff

-(void)setWindowSize:(CGSize)winSize{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
}

-(Egg *)EggLayer{
    if(!_EggLayer) _EggLayer = [Egg node];
    return _EggLayer;
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
 //self.isTouchEnabled = YES;
 //[self.EggLayer eggRock];
 
 }
 */

-(void)onEnterTransitionDidFinish{
    
    
    [self.SliderLayer updateSlider];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        self.isTouchEnabled = YES;
        
        
        // Load assets
        [self loadSliderLayer];
        [self loadAvatar];
        [self loadButtons];
        [self loadBackground];
        
        // give some life to the avatar
        
        [self.EggLayer eggRock];
        // [self schedule:@selector(loadSliderLayer:)];
        
        //[self.myAvatar avatarBounce];
        
	}
	return self;
}





/**************************************************/
// Load Initial Sprites
/**************************************************/
#pragma mark Load Initial Sprites 

-(void) loadAvatar{
    
    //load egg
    [self addChild:self.EggLayer z:1];
    [self.EggLayer loadEgg];
    /*
     // load dog
     [self addChild: self.myAvatar z:0];
     [self.myAvatar updateAvatar];
     */
    
};


-(void) loadSliderLayer{
    //Slider * sliderLayer = [Slider node];
    NSLog(@"Slider loaded");
    [self addChild: self.SliderLayer z:0];
    [self.SliderLayer updateSlider];
    
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
    CCLOG(@"touch happened at x: %0.2f, y: %0.2f", location.x, location.y);
    
    //if avatar is touch, calls an animate
    if (CGRectContainsPoint([self.EggLayer.eggSprite boundingBox], location)){
        
        [self avatarTouched];
    } else {
        [self bgTouched:location];
    }
    
}

-(void)avatarTouched{
    [self.EggLayer eggBounce];
}

-(void)bgTouched:(CGPoint)location{
    //move egg to the touched object
    
    id moveAction = [CCMoveTo actionWithDuration:5 position:location];
    id bounceAction = [CCMoveBy actionWithDuration:.2 position:ccp(0,20)];
    
    
    id action2 = [CCRepeat actionWithAction:
                  [CCSequence actions: [bounceAction copy], [bounceAction reverse], nil]
                                      times: 6
                  ];
    
    // id totalAction = [CCSpawn actions:moveAction, action2, nil];
    
    [self.EggLayer.eggSprite runAction:moveAction];
    /*
     [self.myAvatar.body runAction:moveAction];
     [self.myAvatar.head runAction:moveAction];
     */
    
}

/**************************************************/
// Buttons
/**************************************************/
#pragma mark Buttons

- (void) syncBudWithFitBit: (CCMenuItem  *) menuItem
{
	NSLog(@"The sync menu was called");
    //Add the tableview when the transition is done
    /*
    FitbitViewController *FBView = [[FitbitViewController alloc] init];
    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    [app.navController pushViewController:FBView animated:YES];
    //[CCDirector sharedDirector].pause;
    */
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[syncScene scene] withColor:ccc3(0, 0, 0)]];
    
    
    [self.SliderLayer updateSlider];
    
}


- (void) getLoggedData: (CCMenuItem  *) menuItem
{
	NSLog(@"The log menu was called");
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    
}


/**************************************************/
// Actions
/**************************************************/
#pragma mark Avatar Actions/Animations

/*
 -(void)Bounce{
 // Bounce at the beginning and at the end
 
 id action = [CCMoveBy actionWithDuration:.2 position:ccp(0,20)];
 id action2 = [CCRepeat actionWithAction:
 [CCSequence actions: [[action copy] autorelease], [action reverse], nil]
 times: 6
 ];
 CCSprite *sprite = self.EggLayer.eggSprite;
 [sprite runAction:action2];
 
 
 
 }
 */

-(void)Rock{
    id a1 = [CCRotateBy actionWithDuration:1    angle:5];
    id a2 = [CCRotateBy actionWithDuration:1    angle:-5];
    id action2 = [CCRepeatForever actionWithAction:
                  [CCSequence actions: [a1 copy] , [a1 reverse], [a2 copy] , [a2 reverse], nil]
                  ];
    CCSprite *sprite = (CCSprite *)[self.EggLayer getChildByTag:1];
    [sprite runAction:action2];
}

/*
 id a1 = [CCMoveBy actionWithDuration:1 position:ccp(150,0)];
 id action2 = [CCRepeatForever actionWithAction:
 [CCSequence actions: [[a1 copy] autorelease], [a1 reverse], nil]
 ];
 [sprite runAction:action2];
 */


@end
