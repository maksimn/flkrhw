//
//  AppDelegate.m
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NotificationContent.h"


@import UserNotifications;


typedef NS_ENUM(NSInteger, LCTTriggerType) {
    LCTTriggerTypeInterval = 0,
    LCTTriggerTypeDate = 1,
    LCTTriggerTypeLocation = 2
};


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted)
        {
            NSLog(@"Доступ не дали");
        }
    }];
    
    self.window = [UIWindow new];
    ViewController *viewController = [ViewController new];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /// Push
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self scheduleLocalNotification];
    [self scheduleLocalNotificationDateTrigger];
}

/// Push

- (void)scheduleLocalNotification
{
    UNMutableNotificationContent *content = [NotificationContent createContentToSearchCats];
    NSString *identifier = @"NotificationId";
    UNNotificationTrigger *anyTrigger = [self triggerWithType:LCTTriggerTypeInterval];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:anyTrigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Что-то пошло не так...");
        }
    }];
}

- (void)scheduleLocalNotificationDateTrigger
{
    UNMutableNotificationContent *content = [NotificationContent createContentToSearchDogs];
    NSString *identifier = @"DogsNotificationId";
    UNNotificationTrigger *anyTrigger = [self triggerWithType:LCTTriggerTypeDate];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:anyTrigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Что-то пошло не так (2)...");
        }
    }];
}


- (UNTimeIntervalNotificationTrigger *)intervalTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
}

- (UNCalendarNotificationTrigger *)dateTrigger
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:20];
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear + NSCalendarUnitMonth + NSCalendarUnitDay + NSCalendarUnitHour + NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:date];
    return [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
}

- (UNLocationNotificationTrigger *)locationTrigger
{
    return nil;
}

- (UNNotificationTrigger *)triggerWithType:(LCTTriggerType)triggerType
{
    switch (triggerType) {
        case LCTTriggerTypeInterval:
            return [self intervalTrigger];
            
        case LCTTriggerTypeLocation:
            return [self locationTrigger];
            
        case LCTTriggerTypeDate:
            return [self dateTrigger];
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    if ([AppDelegate runningInBackground] && completionHandler)
    {
        completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge);
    }
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    UNNotificationContent *content = response.notification.request.content;
    
    if (content.userInfo[@"searchString"])
    {
        NSString *searchString = content.userInfo[@"searchString"];
        ViewController *vc = (ViewController *) self.window.rootViewController;
        [vc runSearchForString:searchString];
    }
    
    if (completionHandler)
    {
        completionHandler();
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification
{
}

+ (BOOL)runningInBackground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    return state == UIApplicationStateBackground;
}

@end

