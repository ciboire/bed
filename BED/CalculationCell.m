//
//  CalcluationCell.m
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import "CalculationCell.h"

@implementation CalculationCell

@synthesize BEDButton = _BEDButton;
@synthesize BEDCalculationLabel = _BEDCalculationLabel;
@synthesize cGy1TextField = _cGy1TextField;
@synthesize fx1TextField = _fx1TextField;
@synthesize cGy2Label = _cGy2Label;
@synthesize fx2TextField = _fx2TextField;



- (void)setAlphabeta:(float)ab
{
    _alphabeta = ab;
    long ab_int = ab;
    bool is_integer = ab_int == ab;
    NSString* temp = nil;
    
    if (is_integer)
    {
        temp = [NSString stringWithFormat:@"%ld", ab_int];
    }
    else
    {
        temp = [NSString stringWithFormat:@"%0.1f", ab];
    }
    
    [self.BEDButton setTitle:[NSString stringWithFormat:@"BED_%@", temp] forState:UIControlStateNormal];
    [self updateCalculation];
    
}

- (float)alphabeta
{
    return _alphabeta;
}

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


-(void)updateCalculation
{
    NSLog(@"UPDATE CALCULATION with A/B=%f", self.alphabeta);
    
    // Check for valid integer inputs.  Blank out any invalid inputs we find.
    // Note that FX2 is allowed to be blank.
    int val = [CalculationCell parseInt:self.cGy1TextField.text];
    NSLog(@"Read int value: %d", val);
    bool validInt = val > 0;
    if (!validInt) self.cGy1TextField.text = @"";
    else self.cGy1TextField.text = [NSString stringWithFormat:@"%d", val];
    bool validInput = validInt && val > 0;
    
    val = [CalculationCell parseInt:self.fx1TextField.text];
    validInt = val > 0;
    if (!validInt) self.fx1TextField.text = @"";
    else self.fx1TextField.text = [NSString stringWithFormat:@"%d", val];
    validInput &= validInt && val > 0;

    val = [CalculationCell parseInt:self.fx2TextField.text];
    validInt = val > 0;
    if (!validInt) self.fx2TextField.text = @"";
    else self.fx2TextField.text = [NSString stringWithFormat:@"%d", val];
    
    
    // Now do the calculation, but only if the entire input was valid.
    if (validInput)
    {
        int cgy1 = [self.cGy1TextField.text intValue];
        int fx1 = [self.fx1TextField.text intValue];
        int fx2 = [self.fx2TextField.text intValue];
        
        float bedCalculation = (cgy1/100.0)*(1.0+(((cgy1/100.0)/fx1)/self.alphabeta));
        self.BEDCalculationLabel.text = [NSString stringWithFormat:@"%.0f", bedCalculation];
        [self.BEDCalculationLabel setTextColor:[UIColor colorWithRed:0.0 green:0.431 blue:0.478 alpha:1.0]];
        
        // If the user put in a target fractionation, calculate the corresponding dosage.
        if (fx2 > 0)
        {
            float cgy2Calculation = ((-fx2+sqrt((fx2*fx2)+(((4.0*fx2)/self.alphabeta)*bedCalculation)))/((2.0*fx2)/self.alphabeta))*100.0*fx2;
            self.cGy2Label.text = [NSString stringWithFormat:@"%.0f", cgy2Calculation];
            
            [self.cGy2Label setTextColor:[UIColor colorWithRed:0.0 green:0.431 blue:0.478 alpha:1.0]];
        }
        else
        {
            self.cGy2Label.text = @"cGy";
        }
    }
    else
    {
        self.BEDCalculationLabel.text = @"";
    }
}

-(BOOL) isEmpty
{
    return [self.BEDCalculationLabel.text compare:@""] == NSOrderedSame;
}

-(void) drawForPDFAtYCoordinate:(int) y
{
    int l1 = 30;            // BED_x
    int l2 = l1 + 100;      // =
    int l3 = l2 + 20;       // BED Calc
    int l4 = l3 + 75;      // cGy1
    int l5 = l4 + 50;      // "/"
    int l6 = l5 + 10;       // fx1
    int l7 = l6 + 25;       // =
    int l8 = l7 + 20;       // cGy2
    int l9 = l8 + 50;      // =
    int l10 = l9 + 10;      // fx2
    
    [self.BEDButton.titleLabel.text         drawAtPoint:CGPointMake(l1, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [@"="                                   drawAtPoint:CGPointMake(l2, y) withFont:[UIFont boldSystemFontOfSize:20]];
    
    [[UIColor colorWithRed:0.0 green:0.431 blue:0.478 alpha:1.0] set];
    [self.BEDCalculationLabel.text          drawAtPoint:CGPointMake(l3, y) withFont:[UIFont boldSystemFontOfSize:20]];

    [[UIColor blackColor] set];
    [self.cGy1TextField.text                drawAtPoint:CGPointMake(l4, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [@"/"                                   drawAtPoint:CGPointMake(l5, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [self.fx1TextField.text                 drawAtPoint:CGPointMake(l6, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [@"="                                   drawAtPoint:CGPointMake(l7, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [[UIColor colorWithRed:0.0 green:0.431 blue:0.478 alpha:1.0] set];
    [self.cGy2Label.text                    drawAtPoint:CGPointMake(l8, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [[UIColor blackColor] set];
    [@"/"                                   drawAtPoint:CGPointMake(l9, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [self.fx2TextField.text                 drawAtPoint:CGPointMake(l10, y) withFont:[UIFont boldSystemFontOfSize:20]];
}

+(int) parseInt:(NSString *)str
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setAllowsFloats:YES];
    [nf setMaximum:[NSNumber numberWithInt:INT_MAX]];
    [nf setMinimum:[NSNumber numberWithInt:INT_MIN]];
    [nf setRoundingMode:NSNumberFormatterRoundHalfUp];
    [nf setPositiveFormat:@"0.0d"];
    
    @try {
        NSNumber *num = [nf numberFromString:str];
        NSLog(@"Raw number: %@", num);
        if (!num) return 0;
        else return (int)([num floatValue] + 0.5);
    }
    @catch (NSException * e) {
        NSLog(@"Bad number format.");
        return 0;
    }
}


@end
