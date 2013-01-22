//
//  OauthMachine2.h
//  fitBud
//
//  Created by Khrisendat Persaud on 1/9/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"
#import "GameData.h"

@interface OauthMachine2 : NSObject


-(NSString *)requestTempToken;
-(void)requestAcessToken:(NSString *)URLString;

@end
