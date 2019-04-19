//
//  ViewController.m
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "PhotoCollectionViewCell.h"


@interface ViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *photoCollectionView;

@property (nonatomic, strong) NSArray *someUrls;

@property (nonatomic, strong) NetworkService *networkService;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.someUrls = @[@"http://maksimn.github.io/musicofussr/images/1945.jpg", @"http://maksimn.github.io/musicofussr/images/20.jpg", @"http://maksimn.github.io/musicofussr/images/volga.jpg"];
    
    self.view.backgroundColor = UIColor.yellowColor;
    
    /// Search bar:
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 40, screenWidth, 44)];
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.someUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *photoUrl = self.someUrls[indexPath.row];
    PhotoCollectionViewCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
    
    self.networkService = [NetworkService new];
    self.networkService.output = cell;
    [self.networkService configureUrlSessionWithParams:nil];
    [self.networkService startImageLoading:photoUrl];

    return cell;
}

@end

