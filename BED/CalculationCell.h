//
//  CalcluationCell.h
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculationCell : UITableViewCell
{
    @private
        float _alphabeta;
}

@property (assign) IBOutlet UIButton* BEDButton;
@property (assign) IBOutlet UILabel* BEDCalculationLabel;
@property (assign) IBOutlet UITextField* cGy1TextField;
@property (assign) IBOutlet UITextField* fx1TextField;
@property (assign) IBOutlet UILabel* cGy2Label;
@property (assign) IBOutlet UITextField* fx2TextField;

-(void) setAlphabeta:(float)ab;
-(float) alphabeta;

-(void) updateCalculation;

-(void) drawForPDFAtYCoordinate:(int) y;

-(BOOL) isEmpty;

@end
