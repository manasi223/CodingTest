//
//  WeatherParameters.h
//  WeatherForecast
//
//  Created by 599239 on 26/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherParameters : NSObject

@property NSTimeInterval time;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *precipIntensity;
@property (strong, nonatomic) NSString *precipProbability;
@property (strong, nonatomic) NSString *precipType;
@property (strong, nonatomic) NSNumber *temperature;
@property (strong, nonatomic) NSNumber *apparentTemperature;
@property (strong, nonatomic) NSNumber *dewPoint;
@property (strong, nonatomic) NSString *humidity;
@property float windSpeed;
@property (strong, nonatomic) NSString *windBearing;
@property (strong, nonatomic) NSString *cloudCover;
@property (strong, nonatomic) NSString *pressure;
@property (strong, nonatomic) NSString *ozone;
@property (strong, nonatomic) NSString *visibility;
- (NSDate *)timeInDateFormat;

@end
