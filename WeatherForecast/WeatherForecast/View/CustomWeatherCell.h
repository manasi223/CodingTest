//
//  CustomWeatherCell.h
//  WeatherForecast
//
//  Created by 599239 on 26/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyWeatherReport.h"
#import "WeatherParameters.h"

@interface CustomWeatherCell : UITableViewCell
@property (strong, nonatomic) DailyWeatherReport *dailyReport;
@property (strong, nonatomic) WeatherParameters *hourlyReport;
- (void)setDailyReportObjectWithDictionary:(NSDictionary *)dictionary;
- (void)setHourlyReportObjectWithDictionary:(NSDictionary *)dictionary;
@end
