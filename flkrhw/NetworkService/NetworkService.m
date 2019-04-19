//
//  SomeService.m
//  ProtocolsTest
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkHelper.h"


@interface NetworkService ()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation NetworkService

- (void)configureUrlSessionWithParams:(NSDictionary *)params
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Настравиваем Session Configuration
    [sessionConfiguration setAllowsCellularAccess:YES];
    if (params)
    {
        [sessionConfiguration setHTTPAdditionalHeaders:params];//@{ @"Accept" : @"application/json" }];
    }
    else
    {
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    }
    
    // Создаем сессию
    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
}

- (void)startImageLoading:(NSString *) imageURL
{
    if (!self.urlSession)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:imageURL]];
    [self.downloadTask resume];
}

- (BOOL)resumeNetworkLoading
{
    if (!self.resumeData)
        return NO;
    
    // Восстанавливаем загрузку с учетом уже загруженных данных
    self.downloadTask = [self.urlSession downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    self.resumeData = nil;
    
    return YES;
}

- (void)suspendNetworkLoading
{
    if (!self.downloadTask)
        return;
    
    self.resumeData = nil;
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (!resumeData)
        {
            return;
        }
        self.resumeData = resumeData;
        [self setDownloadTask:nil];
    }];
}

- (void)findFlickrPhotoWithSearchString:(NSString *)searchSrting
{
    NSString *urlString = [NetworkHelper URLForSearchString:searchSrting];
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"temp");
        // Для получение деталей по фото
        // example https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        
        NSArray *photos = temp[@"photos"][@"photo"];
        NSMutableArray<NSString *> *resultPhotoURLs = [[NSMutableArray alloc] initWithCapacity:photos.count];
        
        for (NSDictionary *photoData in photos)
        {
            NSString *farmId = [NSString stringWithFormat:@"%@", photoData[@"farm"]];
            NSString *serverId = photoData[@"server"];
            NSString *idr = photoData[@"id"];
            NSString *secret = photoData[@"secret"];
            
            NSString *photoURL = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmId, serverId, idr, secret];
            
            [resultPhotoURLs addObject:photoURL];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            // Отсюда отправим сообщение на обновление UI с главного потока
            [self.output flckrPhotoURLsReceived:resultPhotoURLs];
        });
    }];
    [sessionDataTask resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output loadingIsDoneWithDataRecieved:data];
    });
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output loadingContinuesWithProgress:progress];
    });
}

@end

