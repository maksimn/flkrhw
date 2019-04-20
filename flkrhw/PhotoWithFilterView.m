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
@property (nonatomic, strong) UIImageView *resultImageView;

@end


@implementation PhotoWithFilterView

- (instancetype)initWithImage:(UIImage *) image
{
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
    CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    if (self = [super initWithFrame:frame])
    {
        [self prepareUI:image frame:frame];
    }
    
    return self;
}

- (void)prepareUI:(UIImage *)img frame:(CGRect) frame
{
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    
    [self.imageView setImage:img];
    [self addSubview:self.imageView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backButton.frame = CGRectMake(20.0, UIScreen.mainScreen.bounds.size.height - 40.0, 80.0, 30.0);
    self.backButton.backgroundColor = [UIColor cyanColor];
    [self.backButton setTitle:@"Назад" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(hideThisView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.backButton];
    
    self.filterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.filterButton.frame = CGRectMake(110.0, UIScreen.mainScreen.bounds.size.height - 40.0, 80.0, 30.0);
    self.filterButton.backgroundColor = [UIColor cyanColor];
    [self.filterButton setTitle:@"Сепия" forState:UIControlStateNormal];
    [self.filterButton addTarget:self action:@selector(doFilter) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.filterButton];
}

- (void)hideThisView
{
    [self removeFromSuperview];
}

- (void)doFilter
{
    UIImage *image = [self.imageView image];
    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, ciImage, @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    
    // Создаем Bitmap
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    // Создаем изображение
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    
    // Релизим ImageRef, потому как там старое C API, нужно ручками
    CGImageRelease(cgimg);
    
    [self.imageView removeFromSuperview];
    [self.backButton removeFromSuperview];
    [self.filterButton removeFromSuperview];
    [self prepareUI:newImage frame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
}

@end
