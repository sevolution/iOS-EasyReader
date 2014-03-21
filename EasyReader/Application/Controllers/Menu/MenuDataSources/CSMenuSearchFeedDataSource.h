//
//  CSMenuSearchFeedDataSource.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMenuSearchFeedDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, retain) NSMutableSet *feeds;

- (void)updateWithFeeds:(NSMutableSet *)feeds;

@end