//
//  AppDelegate.m
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@import UserNotifications;


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

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    if (completionHandler)
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

@end

