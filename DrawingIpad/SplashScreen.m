/**
 
 ClassName:: SplashScreen
 
 Superclass:: UIViewController
 
 Class Description:: This class is Spalsh screen so user can see loading screen.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 26/09/12.
 
 Modified Date:: 26/09/12.

 */


#import "SplashScreen.h"

@interface SplashScreen ()

@end

@implementation SplashScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

@end
