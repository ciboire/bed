//
//  MainTableViewController.h
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MainTableViewController : UITableViewController 
    <UITextFieldDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    UIGestureRecognizerDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource,
    MFMailComposeViewControllerDelegate>


-(IBAction)BEDClicked:(id)sender;
-(IBAction)trashClicked:(id)sender;
-(IBAction)shareClicked:(id)sender;
-(IBAction)save:(id)sender;

@property (assign) IBOutlet UIBarButtonItem* addButton;

-(void) drawForPDF:(NSArray*)historyItem atYCoordinate:(int) y;

@end
