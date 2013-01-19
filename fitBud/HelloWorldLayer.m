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
@end


// HelloWorldLayer implementation
@implementation HelloWorldLayer


// Experience points need to be fetched from somewhere
@synthesize experiencePoints = _experiencePoints;
@synthesize windowSize  = _windowSize;


-(void)setWindowSize:(CGSize)winSize{
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
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
		
        // we need to call the experience points from a local storage database
        // for now
        self.experiencePoints = 0;

        
        // add the slider
        [self loadSlider];
        
        // add the egg
        [self loadAvatar];
        
        // add the buttons
        [self loadButtons];

        // add backgroud
        [self loadBackground];
	}
	return self;
}

/**************************************************/
// Load Initial Sprites
/**************************************************/

-(void) loadAvatar{
    CCSprite *avatar = [CCSprite spriteWithFile:@"egg.png"];
    avatar.position = ccp(self.windowSize.width/2, self.windowSize.height);
    [avatar setScaleX:.5];
    [avatar setScaleY:.5];
    [self addChild:avatar z:0];
};


-(void) loadSlider{
    CCSprite *slider = [CCSprite spriteWithFile:@"slider.png"];
    CGPoint startPoint = ccp(31, 391);
    slider.position = ccp(self.experiencePoints + startPoint.x, startPoint.y);
    [slider setScaleX:.5];
    [slider setScaleY:.5];
    [self addChild:slider z:0];
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
