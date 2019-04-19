//
//  PhotoCollectionViewCell.h
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService/NetworkServiceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoCollectionViewCell : UICollectionViewCell <NetworkServiceOutputProtocol>

@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
