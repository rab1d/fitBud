//
//  FitbitViewController.m
//  Fitbitappv3
//
//  Created by Khrisendat Persaud on 12/30/12.
//  Copyright (c) 2012 Khrisendat Persaud. All rights reserved.
//

#import "FitbitViewController.h"
#import "OAuthConsumer.h"
#import "HelloWorldLayer.h"

@interface FitbitViewController ()
@property (strong, nonatomic) OauthMachine2 *oauth;
@property (strong, nonatomic) UIWebView *myUIWebViewz;
@end

@implementation FitbitViewController
@synthesize myUIWebViewz;
@synthesize oauth=_oauth;
@synthesize dataDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    app.navController.navigationBarHidden = NO;
    
    //test for internet connection here!
    NSString *tempToken = [self.oauth requestTempToken];
    [self fitbitUserLogin:tempToken];
    
    //this method from what I have read
    myUIWebViewz.delegate = self;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
    app.navController.navigationBarHidden = YES;
}

- (OauthMachine2 *)oauth
{
    if (!_oauth) _oauth = [[OauthMachine2 alloc] init];
    return _oauth;
}


- (void)fitbitUserLogin:(NSString *)tempToken
{
    // Initialize UIWebView
    myUIWebViewz = [[UIWebView alloc] init];
    //myToolbar = [[UIToolbar alloc]init];
    
    
    
    // Create tempToken URL as String
    NSString *authorizUrl = [NSString stringWithFormat:@"http://www.fitbit.com/oauth/authorize?oauth_token=%@&display=touch&requestCredentials=true",tempToken];
    
    // Convert String to URL
    NSURL *redirectURL = [NSURL URLWithString:authorizUrl];
    
    // Retreive redirect URL
    NSURLRequest *redirectRequest = [NSURLRequest requestWithURL:redirectURL];
    
    // Load that URL on a UIWebView
    [myUIWebViewz loadRequest:redirectRequest];
    self.view=myUIWebViewz;
/*
    
    UIToolbar *tb = [[UIToolbar alloc] init];
    tb.frame = CGRectMake(0, 0, 200, 200);
    [self.view addSubview:tb];*/
    
}


///delegate method
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    // convert URL to String
    NSString *URLString = [[request URL] absoluteString];
    
    //if verifier found, segue back to Cocos2D scene
    
    //detects if Oauth_verifier appears in the url
    if ([URLString rangeOfString:@"verifier"].location!= NSNotFound) {

        [self.oauth requestAcessToken:URLString];
         self.dataDictionary = [self.oauth returnData];
        
        AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
        [app.navController popViewControllerAnimated:YES];
        
        
        
        //[CCDirector sharedDirector].resume;
        
        
       // [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene] withColor:ccc3(0, 0, 0)]];
    }
    return YES;
}

-(NSDictionary*)returnDataDictionary{
    return self.dataDictionary;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
 
}



@end
