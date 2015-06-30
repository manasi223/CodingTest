//
//  DropDownTableViewController.h
//  WeatherForecast
//
//  Created by Palak Majithiya on 27/06/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionDelegate;

@interface DropDownTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *options;
@property (weak, nonatomic) id<SelectionDelegate> selectionDelegate;
@property (nonatomic) NSInteger selectionIndex;
@property (nonatomic) BOOL hideSelectionMark;
@property (nonatomic) BOOL shouldDisplayOptionInUpperCase;

- (void) refreshDataSelection;
@end

@protocol SelectionDelegate <NSObject>

@optional

- (void) selectionController:(DropDownTableViewController *)selectionController didSelectOptionAtIndex:(NSInteger) index;

@end