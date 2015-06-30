//
//  WeatherParameters.m
//  WeatherForecast
//
//  Created by 599239 on 26/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "WeatherParameters.h"

@implementation WeatherParameters

- (NSString *)humidity
{
    int humidityInPercentage = [_humidity doubleValue] * 100;
    return [NSString stringWithFormat:@"%d",humidityInPercentage];
}

- (NSDate *)timeInDateFormat
{
    NSDate *dateToDisplay = [NSDate dateWithTimeIntervalSince1970:self.time];
    return dateToDisplay;
}
@end
