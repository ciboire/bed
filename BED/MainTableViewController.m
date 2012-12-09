//
//  MainTableViewController.m
//  BED
//
//  Created by Rob Thorndyke on 12-11-30.
//  Copyright (c) 2012 GameHouse. All rights reserved.
//

#import "MainTableViewController.h"
#import "CalculationCell.h"
#import "HistoryCell.h"
#import "AppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>

@implementation MainTableViewController

@synthesize addButton = _addButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Add a left swipe gesture recognizer
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                           action:@selector(handleSwipeRight:)];
    recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:recognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1 + [[AppDelegate getHistory] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Drawing table index %d", indexPath.row);
    
    NSString *CellIdentifier;
    UITableViewCell* cell;

    if (indexPath.row == 0)
    {
        CellIdentifier = @"CalculationCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CalculationCell* c = (CalculationCell*) cell;
        if (cell == nil) {
            cell = [[CalculationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            c = (CalculationCell*) cell;
            [c setAlphabeta:10.0];
        }
        if (c.alphabeta <= 0.0) [c setAlphabeta:10.0];
        [c updateCalculation];
        self.addButton.enabled = ![c isEmpty];

    }
    else
    {
        CellIdentifier = @"HistoryCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        HistoryCell* c = (HistoryCell*) cell;
        c.index = indexPath.row - 1;
        c.tableView = self.tableView;
        [c loadDatafromArray:[[AppDelegate getHistory] objectAtIndex:c.index]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)BEDClicked:(id)sender
{
    NSLog(@"BED CLICKED.");
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Select your alpha/beta value:" 
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"OK",nil];    
    // Add the picker
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    [menu addSubview:pickerView];
    [menu showInView:self.view];        
    
    CGRect menuRect = menu.frame;
    CGFloat orgHeight = menuRect.size.height;
    menuRect.origin.y -= 214; //height of picker
    menuRect.size.height = orgHeight+214;
    menu.frame = menuRect;
    
    
    CGRect pickerRect = pickerView.frame;
    pickerRect.origin.y = orgHeight;
    pickerView.frame = pickerRect;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CalculationCell* c = (CalculationCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [c updateCalculation];
    self.addButton.enabled = ![c isEmpty];
    return YES;
}

-(void)trashClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
                                                    message:@"Delete the entire history?" 
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
}


-(void)shareClicked:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSLog(@"Creating email ...");
        // Create PDF
        NSMutableData *pdfData = [[NSMutableData alloc] init];
        CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((__bridge_retained CFMutableDataRef)pdfData);
        
        // Create PDF context
        CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, NULL);
        
        // How many lines per page are we going to need?  Remember that page 1 *may* have
        // an extra line for the current calculation.
        CalculationCell* c = (CalculationCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        BOOL includesCalculationLine = ([c alphabeta] > 0.0) && ![c isEmpty];

        NSMutableArray* history = [AppDelegate getHistory];
        BOOL same = NO;
        if (history.count > 0)
        {
            same = YES;
            NSArray* firstItem = (NSArray*) [history objectAtIndex:0];
            same &= [(NSString*)[firstItem objectAtIndex:0] compare:c.BEDButton.titleLabel.text] == NSOrderedSame;
            same &= [(NSString*)[firstItem objectAtIndex:1] compare:c.BEDCalculationLabel.text] == NSOrderedSame;
            same &= [(NSString*)[firstItem objectAtIndex:2] compare:c.cGy1TextField.text] == NSOrderedSame;
            same &= [(NSString*)[firstItem objectAtIndex:3] compare:c.fx1TextField.text] == NSOrderedSame;
            same &= [(NSString*)[firstItem objectAtIndex:4] compare:c.cGy2Label.text] == NSOrderedSame;
            same &= [(NSString*)[firstItem objectAtIndex:5] compare:c.fx2TextField.text] == NSOrderedSame;
        }
        
        includesCalculationLine &= !same;
        
        NSLog(@"Includes Calculation Line: %d", includesCalculationLine);
   
        static int LINES_PER_PAGE = 15;
        static int LINE_SIZE = 40;
        static int PAGE_TOP_MARGIN = 40;
        
        int pages = (([AppDelegate getHistory].count + (includesCalculationLine ? 1 : 0)) / LINES_PER_PAGE) + 1;
        NSLog(@"pages: %d", pages);
        int index = 0;
        for (int p = 0; p < pages; p++) {
            
            NSLog(@"Printing page %d", p);

            int y = PAGE_TOP_MARGIN;
            
            CGPDFContextBeginPage(pdfContext, NULL);
            UIGraphicsPushContext(pdfContext);
            
            // Flip coordinate system
            CGRect bounds = CGContextGetClipBoundingBox(pdfContext);
            CGContextScaleCTM(pdfContext, 1.0, -1.0);
            CGContextTranslateCTM(pdfContext, 0.0, -bounds.size.height);
            
            // Drawing the first line, if appropriate.
            if (p == 0 && index == 0 && includesCalculationLine)
            {
                [c drawForPDFAtYCoordinate:y];
                y += LINE_SIZE;
            }
            
            // Draw the history lines.
            int linesThisPage = MIN(LINES_PER_PAGE, history.count - index);
            NSLog(@"Lines This page (preliminary): %d", linesThisPage);
            if (linesThisPage == LINES_PER_PAGE && p == 0 && index == 0 && includesCalculationLine) linesThisPage--;
            NSLog(@"Lines This page (post): %d", linesThisPage);
            
            for (int i=0; i < linesThisPage; i++) {
                NSLog(@"Writing line for data index %d.", index);
                NSArray* item = (NSArray*) [history objectAtIndex:index];
                [self drawForPDF:item atYCoordinate:y];
                y += LINE_SIZE;
                index++;
            }
            
            // Clean up
            UIGraphicsPopContext();
            CGPDFContextEndPage(pdfContext);
        }
        
        // Close the context, we're done with the PDF now.
        CGPDFContextClose(pdfContext);

        // Now fire up the mail, with the PDF as a built-in attachment.
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Recent BED Calculation History"];
        [controller setMessageBody:@"" isHTML:NO]; 
        [controller addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"BED_Calculation_History.pdf"];
        if (controller) [self presentModalViewController:controller animated:YES];
        
        /*
        NSString* applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* dataFilename = [applicationDocumentsDir stringByAppendingPathComponent:@"email.pdf"];
        [[NSKeyedArchiver archivedDataWithRootObject:pdfData] writeToFile:dataFilename atomically:YES];
         */

    }
    else
    {
        NSLog(@"Can't create email");
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked button at index %d.", buttonIndex);
    if (buttonIndex == 1)
    {
        // Delete all data.
        NSMutableArray* empty = [NSMutableArray array];
        [AppDelegate setHistory:empty];
        [AppDelegate saveHistory];
        [self.tableView reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked button at index %d.", buttonIndex);
    
}

- (void)save:(id)sender
{
    NSLog(@"SAVE");
    NSMutableArray* history = [AppDelegate getHistory];
    CalculationCell* c = (CalculationCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSArray* item = [NSArray arrayWithObjects:
                     c.BEDButton.titleLabel.text,
                     c.BEDCalculationLabel.text, 
                     c.cGy1TextField.text,
                     c.fx1TextField.text,
                     c.cGy2Label.text,
                     c.fx2TextField.text, nil];
    if (history == nil)
    {
        // First save.
        history = [NSMutableArray arrayWithObject:item];
        [AppDelegate setHistory:history];
    }
    else
    {
        [history insertObject:item atIndex:0];
    }
    [AppDelegate saveHistory];
    
    // clear calculation row
    c.BEDCalculationLabel.text = @"";
    c.cGy1TextField.text = @"";
    c.fx1TextField.text = @"";
    c.cGy2Label.text = @"";
    c.fx2TextField.text = @"";
    self.addButton.enabled = FALSE;
    
    
    NSLog(@"DONE SAVE");
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{

    //Get location of the swipe
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    //Check if index path is valid
    if(indexPath.row > 0)
    {
        //Get the cell out of the table view
        [[AppDelegate getHistory] removeObjectAtIndex:indexPath.row - 1];
        [AppDelegate saveHistory];
        
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int n = 1;
    switch(component)
    {
        case 0: n = 50; break;
        case 1: n = 1; break;
        case 2: n = 10; break;
    }
    return n;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* title = @"";
    switch(component)
    {
        case 0:
        case 2: title = [NSString stringWithFormat:@"%d", row]; break;
        case 1: title = @"."; break;
    }
    return title;
} 

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    float value = [pickerView selectedRowInComponent:0] + ([pickerView selectedRowInComponent:2] / 10.0);
    NSLog(@"PICKER VALUE: %f", value);
    CalculationCell* c = (CalculationCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [c setAlphabeta:value];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) return 50;
    else return 25;
}

-(void) drawForPDF:(NSArray*)historyItem atYCoordinate:(int) y
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

    [[historyItem objectAtIndex:0]          drawAtPoint:CGPointMake(l1, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [@"="                                   drawAtPoint:CGPointMake(l2, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [[UIColor redColor] set];
    [[historyItem objectAtIndex:1]          drawAtPoint:CGPointMake(l3, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [[UIColor blackColor] set];
    [[historyItem objectAtIndex:2]          drawAtPoint:CGPointMake(l4, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [@"/"                                   drawAtPoint:CGPointMake(l5, y) withFont:[UIFont boldSystemFontOfSize:20]];
    [[historyItem objectAtIndex:3]          drawAtPoint:CGPointMake(l6, y) withFont:[UIFont boldSystemFontOfSize:20]];
    
    // Only put the equivalence data if it's non-empty.
    if ([ (NSString*)[historyItem objectAtIndex:4] compare:@""] != NSOrderedSame)
    {
        [@"="                                   drawAtPoint:CGPointMake(l7, y) withFont:[UIFont boldSystemFontOfSize:20]];
        [[UIColor redColor] set];
        [[historyItem objectAtIndex:4]          drawAtPoint:CGPointMake(l8, y) withFont:[UIFont boldSystemFontOfSize:20]];
        [[UIColor blackColor] set];
        [@"/"                                   drawAtPoint:CGPointMake(l9, y) withFont:[UIFont boldSystemFontOfSize:20]];
        [[historyItem objectAtIndex:5]          drawAtPoint:CGPointMake(l10, y) withFont:[UIFont boldSystemFontOfSize:20]];
    }
}


@end
