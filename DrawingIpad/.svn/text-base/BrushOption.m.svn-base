/**
 
 ClassName:: BrushOption
 
 Superclass:: UIViewController
 
 Class Description:: This class is given different brush options for drawing.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 18/09/12.
 
 Modified Date:: 20/09/12.
 */

#import "BrushOption.h"
#import "DrawingIpadViewController.h"
@implementation BrushOption
@synthesize delegate = _delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    // Do any additional setup after loading the view from its nib.
    BrushArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *Data = [[NSMutableDictionary alloc] init];
    [Data setValue:@"15" forKey:@"TypeValue"];
    [Data setValue:@"Brush 3" forKey:@"Type"];
    [BrushArray addObject:Data];
    [Data release];
    
    Data = [[NSMutableDictionary alloc] init];
    [Data setValue:@"10" forKey:@"TypeValue"];
    [Data setValue:@"Brush 2" forKey:@"Type"];
    [BrushArray addObject:Data];
    [Data release];
    
    Data = [[NSMutableDictionary alloc] init];
    [Data setValue:@"5" forKey:@"TypeValue"];
    [Data setValue:@"Brush 1" forKey:@"Type"];
    [BrushArray addObject:Data];
    [Data release];

    Data = [[NSMutableDictionary alloc] init];
    [Data setValue:@"Pattern" forKey:@"TypeValue"];
    [Data setValue:@"Pattern" forKey:@"Type"];
    [BrushArray addObject:Data];
    [Data release];

    UIBarButtonItem *saveButton = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(DoneButtonPressed)];
    //self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    self.navigationItem.title = @"Brush Options";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [BrushArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [[BrushArray objectAtIndex:indexPath.row] valueForKey:@"Type"];
    // Configure the cell...
    
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
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:[[BrushArray objectAtIndex:indexPath.row] valueForKey:@"TypeValue"] forKey:@"BrushType"];
}
-(void)DoneButtonPressed
{
    if (_delegate) {
        [_delegate ClosePopover];
        
    }
}
@end
