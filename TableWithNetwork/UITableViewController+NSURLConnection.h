//
//  UITableViewController+NSURLConnection.h
//  TableWithNetwork
//
//  Created by Myungjin Choi on 11. 12. 20..
//  Copyright (c) 2011년 KTH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImInProtocol <NSObject>
@required
- (void) apiDidLoad:(id)data;
- (void) apiFailed:(NSError*) error;
@end


@interface UITableViewController (NSURLConnection) <ImInProtocol>
- (void) requestWithURL:(NSURL*) url;
@end
