//
//  HistoryCell.m
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import "HistoryCell.h"
#import "AppDelegate.h"

@implementation HistoryCell

@synthesize BEDRatioLabel = _BEDRatioLabel;
@synthesize BEDCalculationLabel = _BEDCalculationLabel;
@synthesize cGy1Label = _cGy1Label;
@synthesize fx1Label = _fx1Label;
@synthesize cGy2Label = _cGy2Label;
@synthesize fx2Label = _fx2Label;

@synthesize index = _index;
@synthesize tableView = _savedTableView;

@synthesize equals = _equals;
@synthesize slash = _slash;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDatafromArray :(NSArray *)data
{
    NSLog(@"Loading history data: %@", data);
    
    self.BEDRatioLabel.text = [data objectAtIndex:0];
    [self.BEDRatioLabel sizeToFit];
    self.BEDCalculationLabel.text = [data objectAtIndex:1];
    self.cGy1Label.text = [data objectAtIndex:2];
    self.fx1Label.text = [data objectAtIndex:3];
    self.cGy2Label.text = [data objectAtIndex:4];
    self.fx2Label.text = [data objectAtIndex:5];
    
    // Hide the =cgy2/fx2 part if it's empty.
    if ([self.fx2Label.text compare:@""] == NSOrderedSame)
    {
        NSLog(@"Hiding equals, cGy2 and slash.");
        self.equals.hidden = true;
        self.slash.hidden = true;
        self.cGy2Label.hidden = true;
    }
    else
    {
        self.equals.hidden = false;
        self.slash.hidden = false;
        self.cGy2Label.hidden = false;
    }
}


@end
