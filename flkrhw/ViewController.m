//
//  ViewController.m
//  flkrhw
//
//  Created by Maksim Ivanov on 19/04/2019.
//  Copyright © 2019 Maksim Ivanov. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.yellowColor;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), 44)];
    [self.view addSubview:self.searchBar];
}

@end

