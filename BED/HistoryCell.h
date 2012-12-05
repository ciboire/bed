//
//  HistoryCell.h
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (assign) IBOutlet UILabel* BEDRatioLabel;
@property (assign) IBOutlet UILabel* BEDCalculationLabel;
@property (assign) IBOutlet UILabel* cGy1Label;
@property (assign) IBOutlet UILabel* fx1Label;
@property (assign) IBOutlet UILabel* cGy2Label;
@property (assign) IBOutlet UILabel* fx2Label;

@property (assign) int index;
@property (assign) UITableView* tableView;

-(void)loadDatafromArray:(NSArray*)data;


@end
