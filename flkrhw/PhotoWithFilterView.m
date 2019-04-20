//
//  PhotoWithFilterView.m
//  flkrhw
//
//  Created by Maksim Ivanov on 20/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "PhotoWithFilterView.h"

@implementation PhotoWithFilterView

- (instancetype)initWithImage:(UIImage *) image
{
    CGRect frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    if (self = [super initWithFrame:frame])
    {
        UIImageView *selectedImageView = [[UIImageView alloc] initWithFrame:frame];
        
        [selectedImageView setImage:image];
        [self addSubview:selectedImageView];
    }
    
    return self;
}

@end
