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

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
		//	background.rotation = 90;
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

    
    // Find the Directory with PList
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString * plistName = @"UserData";
    NSString * finalPath = [basePath stringByAppendingPathComponent:
                            [NSString stringWithFormat: @"%@.plist", plistName]];
    NSFileManager * fileManager = [NSFileManager defaultManager];
   
    
    
    /*
    if(![fileManager fileExistsAtPath:finalPath])
    {
       // NSError *error;
       // NSString * sourcePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
       // [fileManager copyItemAtPath:sourcePath toPath:finalPath error:&error];
    
        // open to the login and setup layer
     */
        [self loadMyViewController];
    /*
    } else{
     */
     //   [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
  //  }

    
}



-(void) loadMyViewController{
    
    //Add the tableview when the transition is done

    FitbitViewController *myView = [[FitbitViewController alloc] init];
    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    [app.navController pushViewController:myView animated:YES];
    [CCDirector sharedDirector].pause;
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
