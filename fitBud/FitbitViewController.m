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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //test for internet connection here!
    NSString *tempToken = [self.oauth requestTempToken];
    [self fitbitUserLogin:tempToken];
    //this method from what I have read
    myUIWebViewz.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}
/***********************************************************************************************************************************************/

- (OauthMachine2 *)oauth
{
    if (!_oauth) _oauth = [[OauthMachine2 alloc] init];
    return _oauth;
}
/***********************************************************************************************************************************************/
- (void)fitbitUserLogin:(NSString *)tempToken
{
    myUIWebViewz = [[UIWebView alloc] init];
    NSString *authorizUrl = [NSString stringWithFormat:@"http://www.fitbit.com/oauth/authorize?oauth_token=%@&display=touch&requestCredentials=true",tempToken];
    NSURL *redirectURL = [NSURL URLWithString:authorizUrl];
    NSURLRequest *redirectRequest = [NSURLRequest requestWithURL:redirectURL];
    [myUIWebViewz loadRequest:redirectRequest];
    self.view=myUIWebViewz;
}
/***********************************************************************************************************************************************/
///delegate method
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = [[request URL] absoluteString];
    //detects if Oauth_verifier appears in the url
    if ([URLString rangeOfString:@"verifier"].location!= NSNotFound) {
        //possible replace here with a segue or use NSWorkspace
        AppController *app = (AppController *)[[UIApplication sharedApplication] delegate];
        [app.navController popViewControllerAnimated:YES];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene] withColor:ccc3(0, 0, 0)]];
        [self.oauth requestAcessToken:URLString];
    }
    return YES;
}

/***********************************************************************************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [myUIWebViewz release];
    [super dealloc];
}

@end