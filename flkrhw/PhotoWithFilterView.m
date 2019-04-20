//
//  PhotoWithFilterView.m
//  flkrhw
//
//  Created by Maksim Ivanov on 20/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "PhotoWithFilterView.h"


@interface PhotoWithFilterView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *filterButton;

@end


@implementation PhotoWithFilterView

- (instancetype)initWithImage:(UIImage *) image
{
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    if (self = [super initWithFrame:frame])
    {
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        
        [self.imageView setImage:image];
        [self addSubview:self.imageView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.backButton.frame = CGRectMake(20.0, screenHeight - 40.0, 80.0, 30.0);
        self.backButton.backgroundColor = [UIColor cyanColor];
        [self.backButton setTitle:@"Назад" forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(hideThisView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.backButton];
        
        self.filterButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.filterButton.frame = CGRectMake(110.0, screenHeight - 40.0, 80.0, 30.0);
        self.filterButton.backgroundColor = [UIColor cyanColor];
        [self.filterButton setTitle:@"Фильтр" forState:UIControlStateNormal];
        [self.filterButton addTarget:self action:@selector(doFilter) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.filterButton];
    }
    
    return self;
}

- (void)hideThisView
{
    [self removeFromSuperview];
}

- (void)doFilter
{
    NSLog(@"do filter");
}

@end
