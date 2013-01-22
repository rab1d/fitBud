//
//  HelloWorldLayer.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/6/13.
//  Copyright CUNY City College 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer


@interface HelloWorldLayer ()
@property (nonatomic) CGSize windowSize;
@property (nonatomic) Egg *EggLayer;
@property (nonatomic) Slider *SliderLayer;
@end


// HelloWorldLayer implementation
@implementation HelloWorldLayer


// Experience points need to be fetched from somewhere
//@synthesize experiencePoints = _experiencePoints;
@synthesize windowSize  = _windowSize;
@synthesize EggLayer = _EggLayer;
@synthesize SliderLayer = _SliderLayer;


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

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        self.isTouchEnabled = YES;
        
        [self loadSliderLayer];
        [self loadAvatar];
        [self loadButtons];
        [self loadBackground];
        
    
        
        
	}
	return self;
}




/**************************************************/
// Load Initial Sprites
/**************************************************/

-(void) loadAvatar{

    //Egg * eggLayer = [Egg node];
    [self addChild: self.EggLayer z:0];
    [self.EggLayer loadEgg];
    
};


-(void) loadSliderLayer{
    //Slider * sliderLayer = [Slider node];
    [self addChild: self.SliderLayer z:0];
    [self.SliderLayer updateSlider];

};

-(void) loadBackground{
    // add the background
    CCSprite *background = [CCSprite spriteWithFile:@"main-background.png"];
    background.anchorPoint = ccp(0,0);
    
    background.position = ccp(0,0);
    //background.position = ccp(self.windowSize.width/2, self.windowSize.height/2);
    [self addChild:background z:-1];};


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

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    
    //get touch coordinated
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
    CCLOG(@"touch happened at x: %0.2f, y: %0.2f", location.x, location.y);
    
    CCSprite *eggSprite = (CCSprite *)[self.EggLayer getChildByTag:1];
    if (CGRectContainsPoint([eggSprite boundingBox], location)){
        CCLOG(@"touched the egg");
    }
    
    
}


/**************************************************/
// Buttons
/**************************************************/

- (void) syncBudWithFitBit: (CCMenuItem  *) menuItem
{
	NSLog(@"The sync menu was called");
 
}
- (void) getLoggedData: (CCMenuItem  *) menuItem
{
	NSLog(@"The log menu was called");
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [super dealloc];
}

@end



