//
//  DropDownTableViewController.m
//  WeatherForecast
//
//  Created by Palak Majithiya on 27/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "DropDownTableViewController.h"

#define SELECTION_CELL_HEIGHT    30

@interface DropDownTableViewController ()

@property (strong, nonatomic) UIColor *colorForCellText;
@property (strong, nonatomic) UIFont *fontForCellText;
@property (nonatomic, strong) UILabel *lableForWidthCalculation;
@property (strong, nonatomic) NSIndexPath *indexPathToScroll;
@property (strong, nonatomic) NSIndexPath *firstIndexPath;
@property (nonatomic) UITableViewScrollPosition scrollPosition;

@end

@implementation DropDownTableViewController

#pragma mark - Accesors

- (NSIndexPath *)firstIndexPath
{
    if (!_firstIndexPath)
    {
        _firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _firstIndexPath;
}

- (void)setOptions:(NSArray *)options
{
    _options = options;
}

- (void)setSelectionIndex:(NSInteger)selectionIndex
{
    _selectionIndex = selectionIndex;
    if (self.selectionIndex < 0 && self.selectionIndex >= [self.options count])
    {
        self.indexPathToScroll = self.firstIndexPath;
        self.scrollPosition = UITableViewScrollPositionTop;
    }
    else
    {
        self.indexPathToScroll = [NSIndexPath indexPathForRow:selectionIndex inSection:0];
        self.scrollPosition = UITableViewScrollPositionNone;
    }
}

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.colorForCellText = [UIColor blackColor];
    self.fontForCellText = [UIFont systemFontOfSize:13.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataSelection];
}

- (void) refreshDataSelection
{
    [self.tableView reloadData];
    if (self.indexPathToScroll)
    {
        [self.tableView scrollToRowAtIndexPath:self.indexPathToScroll
                              atScrollPosition:NSNotFound
                                      animated:NO];
    }
    [self.tableView flashScrollIndicators];
}

#pragma mark - Settings popover table
#pragma mark -- Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SELECTION_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *settingsCellIdentifier = @"SettingsOptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingsCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingsCellIdentifier];
        cell.textLabel.font = self.fontForCellText;
        cell.textLabel.textColor = self.colorForCellText;
        //cell.backgroundColor = [UIColor whiteColor];
    }
    //added localise logic 28oct nayan
    NSString *textToUse = self.options[indexPath.row];
    if (self.shouldDisplayOptionInUpperCase)
    {
        cell.textLabel.text = [textToUse uppercaseString];
    }
    else
    {
        cell.textLabel.text = textToUse;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.exclusiveTouch = YES;
    if (indexPath.row == self.selectionIndex &&
        !self.hideSelectionMark)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}

#pragma mark -- Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectionIndex = indexPath.row;
    
    if (self.selectionDelegate && [self.selectionDelegate respondsToSelector:@selector(selectionController:didSelectOptionAtIndex:)])
    {
        [self.selectionDelegate selectionController:self
                             didSelectOptionAtIndex:indexPath.row];
    }
}

@end
