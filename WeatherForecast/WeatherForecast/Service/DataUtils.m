//
//  DataUtils.m
//  WeatherForecast
//
//  Created by Palak Majithiya on 27/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "DataUtils.h"

NSString *const kCurrentWeatherKey = @"currently";
NSString *const kHourlyWeatherKey = @"hourly";
NSString *const kDailyWeatherKey = @"daily";
NSString *const kDataWeatherKeyKey = @"data";

@implementation DataUtils

+ (NSString *)convertToDegreeCelsius:(NSNumber *)dataInFahrenheit
{
    int dataInCelsius = ([dataInFahrenheit doubleValue] - 32) * 5 / 9;
    return [NSString stringWithFormat:@"%d",dataInCelsius];
}


@end
