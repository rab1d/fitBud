//
//  OauthMachine2.m
//  fitBud
//
//  Created by Khrisendat Persaud on 1/9/13.
//  Copyright (c) 2013 CUNY City College. All rights reserved.
//

#import "OauthMachine2.h"

@interface OauthMachine2()

@property (strong, nonatomic) OAToken *tempToken;
@property (strong, nonatomic) OAToken *verifierToken;
@property (strong, nonatomic) OAToken *accessToken;

@end

@implementation OauthMachine2
@synthesize tempToken;
@synthesize verifierToken;
@synthesize accessToken;

@synthesize jsonData;



/*****************************/
// Grabs FITBIT API Data
/*****************************/
#pragma mark OAuth Stuff

-(NSString *)requestTempToken{
    
    // What does this do?
    //***This should be encased in it's own method.
    NSString *oauthConsumerKey = @"a34d9f6d5ec04f308b126f41e6c40bea";
    NSString *oauthConsumerSecret = @"95d8ba531633418ab78dcff622c83355";
    NSString *oauthURLString = @"http://api.fitbit.com/oauth/request_token";
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:oauthConsumerKey
                                                    secret:oauthConsumerSecret];
    NSURL *url = [NSURL URLWithString:oauthURLString];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    [request setHTTPMethod:@"POST"];
    
    ////this is asynchronus method but the methods inside the selectors execute last in the queue it seems.
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
    ///this is the synchronus method and it requires error handling to be implemented.
    //I think that a synchronus method is best here as this is for startup.
    
    NSData *returnedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:NULL];
    NSString *responseBody = [[NSString alloc]initWithData:returnedData encoding:NSUTF8StringEncoding];
   // NSLog([NSString stringWithFormat:@"This is the begining %@", responseBody]);
    self.tempToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    
    
    return self.tempToken.key;
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
       //NSLog(responseBody);
        ///It seems that it already parses the response here....
        self.tempToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        ///****this should be a separate method here.
    }
}


-(void)requestAcessToken:(NSString *)URLString{
    NSString *verifierTokenStr = nil;
    NSRange start = [URLString rangeOfString:@"verifier="];
    ///This has to be implemented here instead of using a string because verification is not handled in the OAUTHCONSUMER API. Possible future addition.
    if (start.location != NSNotFound)
    {
        //if you don't give the end index it will just move straight to the end.
        //this is the verifier string.
        verifierTokenStr = [URLString substringFromIndex:start.location + start.length];
    }
    //NSLog(verifierTokenStr);
    NSString *tempTokenStr = nil;
    NSRange start2 = [URLString rangeOfString:@"token="];
    if (start2.location != NSNotFound)
    {
        //if you don't give the end index it will just move straight to the end.
        //this is the verifier string.
        tempTokenStr = [URLString substringFromIndex:start2.location + start2.length];
        NSRange end = [tempTokenStr rangeOfString:@"&"];
        tempTokenStr = [tempTokenStr substringToIndex:end.location];
    }
   // NSLog(tempTokenStr);
    /*********************************************/
    NSString *oauthConsumerKey = @"a34d9f6d5ec04f308b126f41e6c40bea";
    NSString *oauthConsumerSecret = @"95d8ba531633418ab78dcff622c83355";
    NSString *oauthURLString = @"http://api.fitbit.com/oauth/access_token";
    self.verifierToken = [[OAToken alloc] init];
    self.verifierToken.key= tempTokenStr;
    self.verifierToken.verifier=verifierTokenStr;
    //NSLog(self.verifierToken.verifier);
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:oauthConsumerKey
                                                    secret:oauthConsumerSecret];
    NSURL *url = [NSURL URLWithString:oauthURLString];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:self.verifierToken
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    [request setHTTPMethod:@"POST"];
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
    
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        ///The access token needs to be saved for the next time.
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
       // NSLog(responseBody);
       // NSLog(self.accessToken.key);
        [self requestJsonData];
    }
}


/*****************************/
// Grabs FITBIT API Data
/*****************************/
#pragma mark JSON Grabbing


- (void)apiRequest:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"My FitBit API Data is %@", responseBody);
        //could use this to implement errors
        
        // Get the Data
        NSError* error = [[NSError alloc]init];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data //1
                                                             options:kNilOptions
                                                               error:&error];
        // Send the Data
        //[self parseAndSetData:json];
        self.jsonData = json;
    }
}


-(void)requestJsonData{
    NSString *oauthConsumerKey = @"a34d9f6d5ec04f308b126f41e6c40bea";
    NSString *oauthConsumerSecret = @"95d8ba531633418ab78dcff622c83355";
    ///this has to be fixed here. A function should be created in the Game Data class that allows one to check if the date is the same. If the date is the same then you must subtract the new values from the old days values. Else you add stats on.
    ///Also there should be a function that syncs at midnight or whenever is the first time that the phone is on.
    //This could probably better be done by a remote server.
    
    //this could possibly be its own method here.
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    //NSLog(@"%@",dateString);
    
    NSString *oauthURLString =[@"http://api.fitbit.com/1/user/-/activities/date/" stringByAppendingFormat:@"%@.json",dateString];
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:oauthConsumerKey
                                                    secret:oauthConsumerSecret];
    NSURL *url = [NSURL URLWithString:oauthURLString];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:self.accessToken   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:[[OAPlaintextSignatureProvider alloc] init]]; // use the default method, HMAC-SHA1
    [request setHTTPMethod:@"GET"];
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiRequest:didFinishWithData:)
                  didFailSelector:@selector(apiRequest:didFailWithError:)];
    
}



-(NSDictionary*)returnData{
    return self.jsonData;
}




@end
