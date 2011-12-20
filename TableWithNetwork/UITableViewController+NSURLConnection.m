//
//  UITableViewController+NSURLConnection.m
//  TableWithNetwork
//
//  Created by Myungjin Choi on 11. 12. 20..
//  Copyright (c) 2011년 Insol. All rights reserved.
//

#import "UITableViewController+NSURLConnection.h"

@implementation UITableViewController (NSURLConnection)

NSMutableData* _data;

- (void) requestWithURL:(NSURL*) url
{
    NSURLRequest *r = [NSURLRequest requestWithURL:url 
                                       cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                   timeoutInterval:60.0];

    NSURLConnection* conn = [[NSURLConnection  alloc] initWithRequest:r delegate:self];
    if (conn == nil) {
        NSLog(@"error occur!");
    }
}

- (void) apiFailed:(NSError *)error
{
    NSLog(@"api failed = %@", error);
}

- (void) apiDidLoad:(id)data
{
    NSLog(@"api loaded = %@", data);
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");

    _data = [[NSMutableData alloc] initWithCapacity:1024];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
#if (!__has_feature(objc_arc))    
    [connection release];
#endif
    if (@selector(apiFailed:)) {
        [self performSelector:@selector(apiFailed:) withObject:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"didFinishLoading");
    
    NSError *myError = nil;

    NSLog(@"data string = %@", [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding]);
    id result = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments error:&myError];
    if (@selector(apiDidLoad:)) {
        [self performSelector:@selector(apiDidLoad:) withObject:result];
    }
        
#if (!__has_feature(objc_arc))    
    [connection release];
#endif
    
}

@end
