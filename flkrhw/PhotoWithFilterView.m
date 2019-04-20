//
//  PhotoWithFilterView.m
//  flkrhw
//
//  Created by Maksim Ivanov on 20/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "PhotoWithFilterView.h"


@interface PhotoWithFilterView ()

@property (nonatomic, strong) UIButton *backButton;

@end


@implementation PhotoWithFilterView

- (instancetype)initWithImage:(UIImage *) image
{
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    if (self = [super initWithFrame:frame])
    {
        UIImageView *selectedImageView = [[UIImageView alloc] initWithFrame:frame];
        
        [selectedImageView setImage:image];
        [self addSubview:selectedImageView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.backButton.frame = CGRectMake(20.0, screenHeight - 40.0, 80.0, 30.0);
        self.backButton.backgroundColor = [UIColor cyanColor];
        [self.backButton setTitle:@"Назад" forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(hideThisView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: self.backButton];
    }
    
    return self;
}

- (void)hideThisView
{
    [self removeFromSuperview];
}

@end
