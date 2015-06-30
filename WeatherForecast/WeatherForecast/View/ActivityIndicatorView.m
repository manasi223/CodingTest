//
//  ActivityIndicatorView.m
//  WeatherForecast
//
//  Created by 599239 on 29/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "ActivityIndicatorView.h"

@interface ActivityIndicatorView ()
@property (nonatomic, strong) UIView *blockingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation ActivityIndicatorView

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.blockingView];
        [self.blockingView addSubview:self.activityView];
        self.blockingView.center = self.center;
        self.activityView.center = self.blockingView.center;
    }
    return self;
}

- (UIActivityIndicatorView *)activityView
{
    if (_activityView) return _activityView;
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.hidesWhenStopped = YES;
    return _activityView;
}

- (UIView *)blockingView
{
    if (_blockingView) return _blockingView;
    
    _blockingView = [[UIView alloc] initWithFrame:self.bounds];
    _blockingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    return _blockingView;
}

- (void) startAnimating
{
    [self.activityView startAnimating];
}

- (void) stopAnimating
{
    [self.activityView stopAnimating];
}

@end
