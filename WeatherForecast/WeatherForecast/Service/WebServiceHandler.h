//
//  WebServiceHandler.h
//  WeatherForecast
//
//  Created by 599239 on 26/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate;

@interface WebServiceHandler : NSObject

@property (nonatomic, weak) id<WebServiceDelegate> delegate;
- (void) sendRequestWithURLString:(NSString *)urlString
                         delegate:(id<WebServiceDelegate>)delegate;

@end

@protocol WebServiceDelegate <NSObject>

- (void) webServiceHandler:(WebServiceHandler *)handler didReceiveInfo:(NSDictionary *)infoDictionary;
- (void) webServiceHandler:(WebServiceHandler *)handler didReceiveError:(NSError *)error;

@end