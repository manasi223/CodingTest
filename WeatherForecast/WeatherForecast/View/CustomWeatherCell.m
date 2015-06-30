//
//  CustomWeatherCell.m
//  WeatherForecast
//
//  Created by 599239 on 26/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "CustomWeatherCell.h"
#import "DataUtils.h"

@interface CustomWeatherCell ()

@property (strong, nonatomic) IBOutlet UILabel *labelTemperature;
@property (strong, nonatomic) IBOutlet UILabel *labelSummary;
@property (strong, nonatomic) IBOutlet UILabel *labelHumidity;
@property (strong, nonatomic) IBOutlet UILabel *labelWind;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;

@end


@implementation CustomWeatherCell

- (DailyWeatherReport *)dailyReport
{
    if (!_dailyReport)
    {
        _dailyReport = [[DailyWeatherReport alloc]init];
    }
    return _dailyReport;
}

- (WeatherParameters *)hourlyReport
{
    if (!_hourlyReport)
    {
        _hourlyReport = [[WeatherParameters alloc] init];
    }
    return _hourlyReport;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDailyReportObjectWithDictionary:(NSDictionary *)dictionary
{
    @try
    {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [self.dailyReport setValue:obj forKey:(NSString *)key];
        }];
    }
    @catch (NSException *exception)
    {
        [self showExceptionAlert:exception];
        return;
    }
    [self updateUIForDailyReport];
}

- (void)updateUIForDailyReport
{
    NSString *temperature = [DataUtils convertToDegreeCelsius:self.dailyReport.temperatureMax];
    self.labelTemperature.text = [NSString stringWithFormat:@"%@ %@C",temperature,degreeSymbol];
    self.labelSummary.text = [self.dailyReport.summary description];
    self.labelHumidity.text = [NSString stringWithFormat:@"Humidity: %@%@",self.dailyReport.humidity,@"%"];
    self.labelWind.text = [NSString stringWithFormat:@"Wind: %0.2f mph W",self.dailyReport.windSpeed];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *stringFromDate = [formatter stringFromDate:self.dailyReport.timeInDateFormat];
    self.labelTime.text = stringFromDate;
    
    UIImage *icon = [UIImage imageNamed:self.dailyReport.icon];
    if (icon)
    {
        [self.weatherIcon setImage:icon];
    }
}

- (void)setHourlyReportObjectWithDictionary:(NSDictionary *)dictionary
{
    @try
    {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            
            [self.hourlyReport setValue:obj forKey:(NSString *)key];
        }];
    }
    @catch (NSException *exception)
    {
        [self showExceptionAlert:exception];
        return;
    }
    [self updateUIForHourlyReport];
}

- (void)updateUIForHourlyReport
{
    NSString *temperature = [DataUtils convertToDegreeCelsius:self.hourlyReport.temperature];
    self.labelTemperature.text = [NSString stringWithFormat:@"%@ %@C",temperature,degreeSymbol];
    self.labelSummary.text = [self.hourlyReport.summary description];
    self.labelHumidity.text = [NSString stringWithFormat:@"Humidity: %@%@",self.hourlyReport.humidity,@"%"];
    self.labelWind.text = [NSString stringWithFormat:@"Wind: %.2f mph W",self.hourlyReport.windSpeed];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *stringFromDate = [formatter stringFromDate:self.hourlyReport.timeInDateFormat];
    self.labelTime.text = stringFromDate;
    
    UIImage *icon = [UIImage imageNamed:self.hourlyReport.icon];
    if (icon)
    {
        [self.weatherIcon setImage:icon];
    }
}

- (void)showExceptionAlert:(NSException *)exception
{
    NSLog( @"NSException caught" );
    NSLog( @"Name: %@", exception.name);
    NSLog( @"Reason: %@", exception.reason);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Could not parse data"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
