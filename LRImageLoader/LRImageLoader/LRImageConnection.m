//
//  LRImageConnection.m
//  LRImageLoader
//
//  Created by Ruan Lingqi on 14/11/17.
//  Copyright © 2017年 tomrlq. All rights reserved.
//

#import "LRImageConnection.h"

#pragma mark - shared variables

static NSMutableDictionary *connectionCache = nil;  // dictionary contained all connections
static NSURLSession *session = nil;                 // internal session
static STYImageSessionDelegate *sessionDelegate;    // internal session delegate




#pragma mark - LRImageConnection

@interface LRImageConnection () <NSURLSessionDataDelegate>
{
    NSURLRequest *request;
    NSMutableData *dataContainer;
    NSURLSessionDataTask *internalTask;
    
    BOOL isStarted;
    NSProgress *progress;
    NSMutableArray *progressBlocks;     // all progress callbacks
    NSMutableArray *completionBlocks;   // all completion callbacks
}
@end

@implementation LRImageConnection

#pragma mark - NSObject Overrides

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionCache = [NSMutableDictionary dictionary];
        sessionDelegate = [[STYImageSessionDelegate alloc] init];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.HTTPCookieStorage = nil;
        session = [NSURLSession sessionWithConfiguration:config
                                                delegate:sessionDelegate
                                           delegateQueue:nil];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        isStarted = NO;
        progress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
        progress.totalUnitCount = NSURLSessionTransferSizeUnknown;
        progressBlocks = [NSMutableArray array];
        completionBlocks = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods

+ (instancetype)connectionWithRequest:(NSURLRequest *)request {
    LRImageConnection *connection = connectionCache[request.URL];
    if (!connection) {
        connection = [[self alloc] init];
        connection->request = request;
    }
    return connection;
}

- (void)startWithProgress:(LRImageProgressBlock)progressBlock completion:(LRImageCompletionBlock)completionBlock {
    progressBlock ? [progressBlocks addObject:[progressBlock copy]] : nil;
    completionBlock ? [completionBlocks addObject:[completionBlock copy]] : nil;
    if (isStarted) {
        return;
    }
    isStarted = YES;
    dataContainer = [NSMutableData data];
    internalTask = [session dataTaskWithRequest:request];
    [internalTask resume];
    [connectionCache setObject:self forKey:request.URL];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [dataContainer appendData:data];
    progress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
    progress.completedUnitCount = dataTask.countOfBytesReceived;
    
    if (progressBlocks.count > 0) {
        UIImage *partialImage = [UIImage imageWithData:dataContainer];
        for (LRImageProgressBlock progressBlock in progressBlocks) {
            progressBlock(progress, partialImage);
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self callCompletionBlocksWithImage:nil errorString:error.localizedDescription];
    } else {
        UIImage *image = [UIImage imageWithData:dataContainer];
        if (image && !CGSizeEqualToSize(image.size, CGSizeZero)) {
            [self callCompletionBlocksWithImage:image errorString:nil];
        } else {
            NSString *errorString = @"Image is nil";
            [self callCompletionBlocksWithImage:nil errorString:errorString];
        }
    }
    progressBlocks = nil;
    completionBlocks = nil;
    [connectionCache removeObjectForKey:request.URL];
}

#pragma mark - Private Methods

- (void)callCompletionBlocksWithImage:(UIImage *)image errorString:(NSString *)errorString {
    for (LRImageCompletionBlock completionBlock in completionBlocks) {
        completionBlock(image, errorString);
    }
}

@end




#pragma mark - Internal STYImageSessionDelegate

@implementation STYImageSessionDelegate

- (LRImageConnection *)connectionForTask:(NSURLSessionTask *)task {
    NSURL *urlKey = task.originalRequest.URL;
    return connectionCache[urlKey];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    LRImageConnection *connection = [self connectionForTask:dataTask];
    [connection URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    LRImageConnection *connection = [self connectionForTask:task];
    [connection URLSession:session task:task didCompleteWithError:error];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler {
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential *cred = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
    }
}

@end
