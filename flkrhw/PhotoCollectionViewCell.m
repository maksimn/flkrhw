//
//  PhotoCollectionViewCell.m
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.frame;
}

#pragma mark - NetworkServiceOutput

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
    [self.imageView setImage:[UIImage imageWithData:dataRecieved]];
}

- (void)loadingContinuesWithProgress:(double)progress
{
    
}

@end
