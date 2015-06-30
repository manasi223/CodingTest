//
//  WebServiceHandler.m
//  WeatherForecast
//
//  Created by 599239 on 26/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "WebServiceHandler.h"

@interface WebServiceHandler ()
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation WebServiceHandler

- (void) sendRequestWithURLString:(NSString *)urlString
                         delegate:(id<WebServiceDelegate>)delegate
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url
                                                                   cachePolicy:0
                                                               timeoutInterval:30];
    [urlRequest setHTTPMethod:@"GET"];
    self.responseData = [NSMutableData data];
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                         delegate:self
                                                 startImmediately:YES];
}


#pragma mark - Connection Data delgate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data)
        [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Original Request URL : %@",self.urlConnection.originalRequest.URL.absoluteString);
        [self informDelegateAboutSucessWithData:self.responseData];
    });
}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

#pragma mark - Connection delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%s : Error occured -> %@",__PRETTY_FUNCTION__,error);
        [self informDelegateAboutError:error];
    });
}

#pragma mark - Inform Delegate
- (void) informDelegateAboutError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webServiceHandler:didReceiveError:)])
    {
        [self.delegate webServiceHandler:self didReceiveError:error];
    }
}

- (void) informDelegateAboutSucessWithData:(id)responseData
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (error)
    {
        NSLog(@"%s : Error occured -> %@",__PRETTY_FUNCTION__,error);
        [self informDelegateAboutError:error];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(webServiceHandler:didReceiveInfo:)])
        {
            [self.delegate webServiceHandler:self didReceiveInfo:jsonObject];
        }
    }
}

@end
