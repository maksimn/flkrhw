//
//  NotificationContent.h
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@import UserNotifications;

NS_ASSUME_NONNULL_BEGIN

@interface NotificationContent : NSObject

+ (UNMutableNotificationContent *)createContentToSearchCats;
+ (UNMutableNotificationContent *)createContentToSearchDogs;

@end

NS_ASSUME_NONNULL_END
