//
//  DailyWeatherReport.h
//  WeatherForecast
//
//  Created by 599239 on 26/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyWeatherReport : NSObject

@property (strong, nonatomic) NSString *apparentTemperatureMax;
@property (strong, nonatomic) NSString *apparentTemperatureMaxTime;
@property (strong, nonatomic) NSString *apparentTemperatureMin;
@property (strong, nonatomic) NSString *apparentTemperatureMinTime;
@property (strong, nonatomic) NSString *cloudCover;
@property (strong, nonatomic) NSString *dewPoint;
@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *moonPhase;
@property (strong, nonatomic) NSString *ozone;
@property (strong, nonatomic) NSString *precipIntensity;
@property (strong, nonatomic) NSString *precipIntensityMax;
@property (strong, nonatomic) NSString *precipIntensityMaxTime;
@property (strong, nonatomic) NSString *precipProbability;
@property (strong, nonatomic) NSString *precipType;
@property (strong, nonatomic) NSString *pressure;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *sunriseTime;
@property (strong, nonatomic) NSString *sunsetTime;
@property (strong, nonatomic) NSNumber *temperatureMax;
@property (strong, nonatomic) NSString *temperatureMaxTime;
@property (strong, nonatomic) NSString *temperatureMin;
@property (strong, nonatomic) NSString *temperatureMinTime;
@property NSTimeInterval time;
@property (strong, nonatomic) NSString *windBearing;
@property float windSpeed;
@property (strong,nonatomic) NSString *visibility;
- (NSDate *)timeInDateFormat;

@end
