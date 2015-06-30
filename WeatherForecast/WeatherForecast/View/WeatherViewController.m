//
//  WeatherViewController.m
//  WeatherForecast
//
//  Created by 599239 on 25/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "WeatherViewController.h"
#import "WebServiceHandler.h"
#import "CustomWeatherCell.h"
#import "WeatherParameters.h"
#import "DropDownTableViewController.h"
#import "DataUtils.h"
#import "FPPopoverController.h"
#import "ActivityIndicatorView.h"
#import <CoreLocation/CoreLocation.h>

NSString *const weatherUrl = @"https://api.forecast.io/forecast/97ebbee92acb009051d5d34dd56b5533/";
typedef NS_ENUM(NSInteger, ViewMode)
{
    ViewModeCurrentWeather = 0,
    ViewModeHourlyWeather,
    ViewModeDailyWeather
};

@interface WeatherViewController () <CLLocationManagerDelegate,WebServiceDelegate,UITableViewDataSource,SelectionDelegate>
{
    NSString *currentlatitude;
    NSString *currentLongitude;
    NSString *urlString;
    ViewMode weatherViewMode;
    ActivityIndicatorView *activityView;
}

@property (weak, nonatomic) IBOutlet UIView *currentWeatherView;
@property (weak, nonatomic) IBOutlet UITableView *tableviewStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTemperature;
@property (weak, nonatomic) IBOutlet UILabel *labelApparentTemperature;
@property (weak, nonatomic) IBOutlet UILabel *labelSummary;
@property (weak, nonatomic) IBOutlet UILabel *labelPressure;
@property (weak, nonatomic) IBOutlet UILabel *labelDewPoint;
@property (weak, nonatomic) IBOutlet UILabel *labelhumidity;
@property (weak, nonatomic) IBOutlet UILabel *labelWind;
@property (weak, nonatomic) IBOutlet UIImageView *imageWeather;
@property (strong, nonatomic) NSArray *dailyWeather;
@property (strong, nonatomic) NSArray *modeSelectionArray;
@property (strong, nonatomic) NSDictionary *weatherData;
@property (strong, nonatomic) DropDownTableViewController *modeSelectionContentController;
@property (strong, nonatomic) FPPopoverController *modelSelectionPopoverController;
@property (strong, nonatomic) WeatherParameters *currentWeatherReport;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation WeatherViewController

-(NSArray *)dailyWeather
{
    if (!_dailyWeather)
    {
        _dailyWeather = [NSArray array];
    }
    return _dailyWeather;
}

- (NSArray *)modeSelectionArray
{
    if (!_modeSelectionArray)
    {
        _modeSelectionArray = @[@"Current Weather", @"Hourly", @"Daily"];
    }
    return _modeSelectionArray;
}

- (NSDictionary *)weatherData
{
    if (!_weatherData)
    {
        _weatherData = [NSDictionary dictionary];
    }
    return _weatherData;
}

- (WeatherParameters *)currentWeatherReport
{
    if (!_currentWeatherReport)
    {
        _currentWeatherReport = [[WeatherParameters alloc] init];
    }
    return _currentWeatherReport;
}

- (DropDownTableViewController *)modeSelectionContentController
{
    if (!_modeSelectionContentController)
    {
        _modeSelectionContentController = [[DropDownTableViewController alloc] init];
        _modeSelectionContentController.selectionIndex = weatherViewMode;
        _modeSelectionContentController.selectionDelegate = self;
        _modeSelectionContentController.options = self.modeSelectionArray;
    }
    return _modeSelectionContentController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addActivityIndicator];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    weatherViewMode = ViewModeCurrentWeather;
    self.tableviewStatus.backgroundColor = [UIColor clearColor];
    self.currentWeatherView.hidden = NO;
    self.tableviewStatus.hidden = YES;
}

#pragma mark WebServiceDelegate
- (void) webServiceHandler:(WebServiceHandler *)handler didReceiveInfo:(NSDictionary *)infoDictionary
{
    NSLog(@"Info = %@",infoDictionary);
    self.weatherData = infoDictionary;
    @try
    {
        [self.weatherData[kCurrentWeatherKey] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
            [self.currentWeatherReport setValue:obj forKey:(NSString *)key];
        }];
        
    }
    @catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason);
        [self removeActivityIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Could not parse data"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self updateUIWithData];
    [self removeActivityIndicator];
}
- (void) webServiceHandler:(WebServiceHandler *)handler didReceiveError:(NSError *)error
{
    NSLog(@"Error : %@",error);
    [self removeActivityIndicator];
}

#pragma mark ActivityIndicator
- (void) addActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(!activityView)
        {
            activityView = [[ActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            activityView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        }
        [self.view setUserInteractionEnabled:NO];
        [self.view addSubview:activityView];
        [activityView startAnimating];
        
    });
}

- (void) removeActivityIndicator
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([activityView superview])
        {
            [activityView removeFromSuperview];
        }
        [self.view setUserInteractionEnabled:YES];
    });
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    currentlatitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    currentLongitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    urlString = [weatherUrl stringByAppendingFormat:@"%@,%@/",currentlatitude,currentLongitude];
    WebServiceHandler *serviceHandler = [[WebServiceHandler alloc]init];
    serviceHandler.delegate = self;
    [serviceHandler sendRequestWithURLString:urlString delegate:self];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self removeActivityIndicator];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"User needs to allow location service from settings to get the weather details"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dailyWeather.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomWeatherCell class])];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    NSDictionary *oneDayWeatherReport = self.dailyWeather[indexPath.row];
    switch (weatherViewMode)
    {
        case ViewModeHourlyWeather:
            [cell setHourlyReportObjectWithDictionary:oneDayWeatherReport];
            break;
        case ViewModeDailyWeather:
            [cell setDailyReportObjectWithDictionary:oneDayWeatherReport];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark SelectionDelegate
- (void)selectionController:(DropDownTableViewController *)selectionController didSelectOptionAtIndex:(NSInteger)index
{
    self.labelTitle.text = self.modeSelectionArray[index];
    if (index != weatherViewMode)
    {
        weatherViewMode = index;
        switch (weatherViewMode)
        {
            case ViewModeCurrentWeather:
                self.currentWeatherView.hidden = NO;
                self.tableviewStatus.hidden = YES;
                break;
                
            case ViewModeHourlyWeather:
                self.currentWeatherView.hidden = YES;
                self.dailyWeather = self.weatherData[kHourlyWeatherKey][kDataWeatherKeyKey];
                [self.tableviewStatus reloadData];
                self.tableviewStatus.hidden = NO;
                break;
                
            case ViewModeDailyWeather:
                self.currentWeatherView.hidden = YES;
                self.dailyWeather = self.weatherData[kDailyWeatherKey][kDataWeatherKeyKey];
                [self.tableviewStatus reloadData];
                self.tableviewStatus.hidden = NO;
                break;
                
            default:
                break;
        }
    }
    [self.modelSelectionPopoverController dismissPopoverAnimated:YES];
}

#pragma mark update UI
- (void)updateUIWithData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *temperature = [DataUtils convertToDegreeCelsius:self.currentWeatherReport.temperature];
        self.labelTemperature.text = [NSString stringWithFormat:@"%@ %@C",temperature,degreeSymbol];
        
        NSString *apparentTemperature = [DataUtils convertToDegreeCelsius:self.currentWeatherReport.apparentTemperature];
        self.labelApparentTemperature.text = [NSString stringWithFormat:@"Feels lke: %@ %@C",apparentTemperature,degreeSymbol];
        
        self.labelPressure.text = [NSString stringWithFormat:@"Pressure: %@ hPa",[self.currentWeatherReport.pressure description]];
        self.labelSummary.text = [self.currentWeatherReport.summary description];
        self.labelhumidity.text = [NSString stringWithFormat:@"Humidity: %@ %@",[self.currentWeatherReport.humidity description],@"%"];
        self.labelWind.text = [NSString stringWithFormat:@"Wind: %.2f mph",self.currentWeatherReport.windSpeed];
        
        NSString *dewPoint = [DataUtils convertToDegreeCelsius:self.currentWeatherReport.dewPoint];
        self.labelDewPoint.text = [NSString stringWithFormat:@"Dew Point: %@ %@C",dewPoint,degreeSymbol];
        
        UIImage *weatherIcon = [UIImage imageNamed:self.currentWeatherReport.icon];
        if (weatherIcon)
        {
            [self.imageWeather setImage:weatherIcon];
        }
    });
}


#pragma mark Button action
- (IBAction)onClickButtonModeSelection:(UIButton *)sender
{
    if (!self.modelSelectionPopoverController)
    {
        self.modelSelectionPopoverController = [[FPPopoverController alloc] initWithViewController:self.modeSelectionContentController];
        self.modelSelectionPopoverController.contentSize = CGSizeMake(200, 150);
    }
    [self.modelSelectionPopoverController presentPopoverFromView:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
