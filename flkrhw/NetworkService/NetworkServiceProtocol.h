//
//  ProtocolsTest.h
//  ProtocolsTest
//
//  Created by Alexey Levanov on 30.11.17.
//  Copyright © 2017 Alexey Levanov. All rights reserved.
//

@protocol NetworkServiceOutputProtocol <NSObject>
@optional

- (void)loadingContinuesWithProgress:(double)progress;
- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved;

@end

@protocol NetworkServiceIntputProtocol <NSObject>
@optional

- (void)configureUrlSessionWithParams:(NSDictionary *)params;
- (void)startImageLoading:(NSString *) imageURL;

// Next Step
- (BOOL)resumeNetworkLoading;
- (void)suspendNetworkLoading;

- (void)findFlickrPhotoWithSearchString:(NSString *)searcSrting;

@end

