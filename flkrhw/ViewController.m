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


@interface ViewController () <UICollectionViewDataSource, UISearchBarDelegate, NetworkServiceOutputProtocol>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *photoCollectionView;

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
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.photoCollectionView.frame = CGRectMake(0, 84, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 84);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    NetworkService *networkService = [NetworkService new];
    networkService.output = cell;
    [networkService configureUrlSessionWithParams:nil];
    [networkService startImageLoading:@""];

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

- (void)loadingContinuesWithProgress:(double)progress
{
}

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
}

- (void)flckrPhotoURLsReceived:(NSArray<NSString *> *)photoURLs
{
    NSInteger n = photoURLs.count;
    n++;
}

@end

