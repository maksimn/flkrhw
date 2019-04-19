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
    return [NotificationContent createContentToSearch:@"Вы давно не искали кошечек" img:@"cat" searchStr:@"Cats"];
}

+ (UNMutableNotificationContent *)createContentToSearchDogs
{
    return [NotificationContent createContentToSearch:@"Вы давно не искали собачек" img:@"dog" searchStr:@"Dogs"];
}

+ (UNMutableNotificationContent *)createContentToSearch:(NSString *)body img:(NSString *)img searchStr:(NSString *) searchStr
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    content.title = @"Оповещение";
    content.body = body;
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @([NotificationContent giveNewBadgeNumber] + 1);
    
    UNNotificationAttachment *attachment = [NotificationContent imageAttachment:img];
    
    if (attachment)
    {
        content.attachments = @[attachment];
    }
    
    NSDictionary *dict = @{
                           @"searchString": searchStr
                           };
    
    content.userInfo = dict;
    return content;
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
