//
//  NotificationContent.m
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "NotificationContent.h"


@implementation NotificationContent

+ (UNMutableNotificationContent *)createContentToSearchCats
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    content.title = @"Оповещение";
    content.body = @"Вы давно не искали кошечек";
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @([NotificationContent giveNewBadgeNumber] + 1);
    
    UNNotificationAttachment *attachment = [NotificationContent imageAttachment:@"cat"];
    
    if (attachment)
    {
        content.attachments = @[attachment];
    }
    
    NSDictionary *dict = @{
                           @"searchString": @"Cats"
                           };
    
    content.userInfo = dict;
    return content;
}

+ (UNMutableNotificationContent *)createContentToSearchDogs
{
    return nil;
}

+ (UNNotificationAttachment *)imageAttachment:(NSString *) fileName
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"png"];
    NSError *error;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"pushImages" URL:fileURL options:nil error:&error];
    
    return attachment;
}

+ (NSInteger)giveNewBadgeNumber
{
    return [[UIApplication sharedApplication] applicationIconBadgeNumber];
}

@end
