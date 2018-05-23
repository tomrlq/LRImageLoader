//
//  LRPhotoStore.m
//  LRImageDemo
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRPhotoStore.h"
#import "LRPhoto.h"

NSString * const EndPoint = @"https://api.flickr.com/services/rest";
NSString * const APIKey = @"a6d819499131071f158fd740860a5a88";
NSString * const FetchRecentsMethod = @"flickr.photos.getRecent";

@interface LRPhotoStore () <NSURLSessionDataDelegate>
{
    NSURLSession *session;
    NSMutableArray *recentPhotos;
}
@end

@implementation LRPhotoStore

#pragma mark - Initialization

+ (LRPhotoStore *)sharedStore {
    static LRPhotoStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[super allocWithZone:NULL] init];
    });
    return sharedStore;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        recentPhotos = [NSMutableArray array];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

#pragma mark - Networking

- (void)fetchRecentPhotosWithCompletion:(void (^)(NSArray *, NSError *))completion {
    if (recentPhotos.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(recentPhotos, nil) : nil;
        });
        return;
    }
    NSURL *url = [self recentPhotoURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self parsePhotos:recentPhotos fromJSON:data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(recentPhotos, error) : nil;
        });
    }];
    [task resume];
}

#pragma mark - URL Serialization

- (NSURL *)recentPhotoURL {
    return [self flickrURLWithMethod:FetchRecentsMethod params:nil];
}

- (NSURL *)flickrURLWithMethod:(NSString *)method params:(NSDictionary *)params {
    NSURLComponents *components = [NSURLComponents componentsWithString:EndPoint];
    NSMutableArray *queryItems = [NSMutableArray array];
    NSDictionary *baseParams = @{@"api_key" : APIKey,
                                 @"format" : @"json",
                                 @"nojsoncallback": @"1",
                                 @"extras" : @"url_s",
                                 @"method" : method};
    [baseParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:obj];
        [queryItems addObject:item];
    }];
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:obj];
            [queryItems addObject:item];
        }];
    }
    components.queryItems = queryItems;
    return components.URL;
}

#pragma mark - Parse JSON Results

- (void)parsePhotos:(NSMutableArray *)photos fromJSON:(NSData *)jsonData {
    [photos removeAllObjects];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:0
                                                                 error:nil];
    NSArray *jsonArray = jsonObject[@"photos"][@"photo"];
    for (NSDictionary *jsonDict in jsonArray) {
        LRPhoto *photo = [[LRPhoto alloc] initWithJSON:jsonDict];
        [photos addObject:photo];
    }
}

@end
