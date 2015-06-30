//
//  DataUtils.h
//  WeatherForecast
//
//  Created by Palak Majithiya on 27/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define degreeSymbol  @"\u00B0"

extern NSString *const kCurrentWeatherKey;
extern NSString *const kHourlyWeatherKey;
extern NSString *const kDailyWeatherKey;
extern NSString *const kDataWeatherKeyKey;

@interface DataUtils : NSObject
+ (NSString *)convertToDegreeCelsius:(NSNumber *)dataInFahrenheit;
@end
