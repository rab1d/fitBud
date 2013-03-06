//
//  FitbitViewController.h
//  Fitbitappv3
//
//  Created by Khrisendat Persaud on 12/30/12.
//  Copyright (c) 2012 Khrisendat Persaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "OauthMachine2.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "HelloWorldLayer.h"


@interface FitbitViewController : UIViewController <UIWebViewDelegate>{
    //IBOutlet UIWebView *myUIWebViewz;
}

@property NSDictionary *dataDictionary;
-(NSDictionary*)returnDataDictionary;


@end
