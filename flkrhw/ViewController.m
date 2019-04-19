//
//  ViewController.m
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "NetworkServiceProtocol.h"
#import "PhotoCollectionViewCell.h"
#import "NotificationContent.h"


@import UserNotifications;


typedef NS_ENUM(NSInteger, LCTTriggerType) {
    LCTTriggerTypeInterval = 0,
    LCTTriggerTypeDate = 1,
    LCTTriggerTypeLocation = 2
};


@interface ViewController () <UICollectionViewDataSource, UISearchBarDelegate, NetworkServiceOutputProtocol>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *photoCollectionView;

@property (nonatomic, strong) NSArray<NSString *> *photoURLsDataSource;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.yellowColor;
    
    /// Search bar:
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 40, screenWidth, 44)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    /// Photo collection view:
    UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
    collectionViewLayout.itemSize = CGSizeMake(screenWidth / 2, screenWidth / 2);
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    collectionView.backgroundColor = UIColor.lightGrayColor;
    collectionView.dataSource = self;
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
    self.photoCollectionView = collectionView;
    [self.view addSubview:self.photoCollectionView];
    
    /// Push
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self scheduleLocalNotification];
    [self scheduleLocalNotificationDateTrigger];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.photoCollectionView.frame = CGRectMake(0, 84, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 84);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoURLsDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    NetworkService *networkService = [NetworkService new];
    networkService.output = cell;
    [networkService configureUrlSessionWithParams:nil];
    [networkService startImageLoading:self.photoURLsDataSource[indexPath.row]];

    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = searchBar.text;
    NetworkService *networkService = [NetworkService new];
    networkService.output = self;
    [networkService configureUrlSessionWithParams:nil];
    [networkService findFlickrPhotoWithSearchString:searchString];
}

#pragma mark - NetworkServiceOutputProtocol

- (void)flckrPhotoURLsReceived:(NSArray<NSString *> *)photoURLs
{
    self.photoURLsDataSource = photoURLs;
    [self.photoCollectionView reloadData];
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

- (void)runSearchForString:(NSString *) searchString
{
    self.searchBar.text = searchString;
    [self searchBarSearchButtonClicked:self.searchBar];
}

@end

