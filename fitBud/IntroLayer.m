//
//  IntroLayer.m
//  fitBud
//
//  Created by Mohammod Arafat on 1/6/13.
//  Copyright CUNY City College 2013. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"


@interface IntroLayer()

@property (strong,nonatomic) UIWebView *googleView;

@end

#pragma mark - IntroLayer
// HelloWorldLayer implementation
@implementation IntroLayer
@synthesize googleView;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//


-(id) init
{
	if( (self=[super init])) {
        
        // add the launch screen

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
		} else {
			background = [CCSprite spriteWithFile:@"Default.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
    GameData* userData = [[GameData alloc] init];
    
    // if userData exists, load it
    //[userData loadUserData];
    // else Load login screen
    [self loadFitBitLoginScreen];
    

    
}



-(void) loadFitBitLoginScreen{
    
    //Add the tableview when the transition is done

    FitbitViewController *FBView = [[FitbitViewController alloc] init];
    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    [app.navController pushViewController:FBView animated:YES];
    [CCDirector sharedDirector].pause;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MainScene scene] withColor:ccc3(0, 0, 0)]];
    
    NSLog(@"I'M BACK IN THE INTROLAYER");

}


/*
-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *URLString = [[request URL] absoluteString];
    //detects if Oauth_verifier appears in the url
    if ([URLString rangeOfString:@"verifier"].location!= NSNotFound) {
        //possible replace here with a segue or use NSWorkspace
        NSString *goog = @"http://www.google.com";
        NSURL *googurl = [NSURL URLWithString:goog];
        NSURLRequest *googrequest = [NSURLRequest requestWithURL:googurl];
        [googleView loadRequest:googrequest];
        NSLog(URLString);
        [self.oauth requestAcessToken:URLString];
        NSLog(@"too");}
        
        
    return YES;
}*/

@end
