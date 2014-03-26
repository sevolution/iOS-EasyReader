//
//  FeedItem.m
//
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import "FeedItem.h"
#import "NSDate+TimeAgo.h"
#import "Feed.h"
#import "User.h"
#import "AFHTTPRequestOperation.h"

@implementation FeedItem

@dynamic title;
@dynamic summary;
@dynamic updatedAt;
@dynamic publishedAt;
@dynamic createdAt;
@dynamic image_iphone_retina;
@dynamic image_ipad;
@dynamic image_ipad_retina;
@dynamic url;
@dynamic feed;
@dynamic id;

/**
 * Get the name of the associated Feed
 */
- (NSString *)feedName
{
    Feed *feed = self.feed;
    return feed.name;
}

- (NSString *)headline
{
    NSString *timeAgo = [self.updatedAt timeAgo];
    
    return[NSString stringWithFormat:@"%@ \u00b7 %@", self.feed.name, timeAgo];
}

+ (void) requestFeedItemsFromFeeds:(NSSet  *)feeds
                             since:(NSDate *)startAt
                           success:(APISuccessBlock)success
                           failure:(APIFailureBlock)failure
{
    if ([feeds count] == 0)
    {
        if (success) success(nil, 0);
        return;
    }
    
    
    NSMutableArray *feedIds = [[NSMutableArray alloc] init];
    for( Feed *feed in feeds ){
        [feedIds addObject:feed.id];
    }
    
    NSDictionary *params = @{
                             @"since": startAt,
                             @"feed_ids": feedIds
                             };
    
    [[self client] requestRoute:@"feedItems"
                     parameters:params success:^(id responseObject, NSInteger httpStatus) {
                         [self saveParsedResponseData:responseObject];
                         if(success) success(responseObject, httpStatus);
                      }
                        failure:failure];
}

+ (void) saveParsedResponseData:(id)responseData
{
    for(NSDictionary *data in responseData[@"feed_items"]) {
        for( Feed *currentFeed in [[User current] feeds] ){
            if( data[@"feed_id"] == currentFeed.id ){
                [currentFeed addFeedItemsObject:[FeedItem createOrUpdateFirstFromAPIData:data]];
            }
        }
    }
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}
@end
