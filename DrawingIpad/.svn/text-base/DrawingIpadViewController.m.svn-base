/**
 
 ClassName:: DrawingIpadViewController
 
 Superclass:: UIViewController
 
 Class Description:: This class is for drawing canvas so user can draw as per color,brush,erase,share etc...
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 18/09/12.
 
 Modified Date:: 16/10/12.
 */ 

#import "DrawingIpadViewController.h"
#import "AFPhotoEditorController.h" 
#import "DrawingViewer.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#import "OAuthTwitter.h"
#import "OAuthConsumerCredentials.h"
#import "OAuth.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "SBJson.h"
#import "NSString+URLEncoding.h"

@interface DrawingIpadViewController ()

@end
@implementation DrawingIpadViewController
@synthesize ColorPickerPopup,BrushPicker,ErashPicker,Sele_Color;
@synthesize delegate,ImagePath;
@synthesize pickedImage;
@synthesize popoverController;
int tempcount = 1;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"15" forKey:@"ErashRadius"];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Solid" forKey:@"BrushOption"];
    [self SetColorArrayhsv];
   
    slv = [[[SmoothLineView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+15, self.view.bounds.origin.y+15, self.view.bounds.size.width-30, self.view.bounds.size.height - 86)] autorelease];
    slv.delegate = self;
    slv.layer.masksToBounds = YES;
    slv.layer.cornerRadius = 8.0;
    
    [self.view addSubview:slv];
    
    [BrushView setFrame:CGRectMake(21,1007,726,206)];
    [self.view addSubview:BrushView];
    [BrushView release];
    
    [SharingOptionView setFrame:CGRectMake(21,1007,726,206)];
    [self.view addSubview:SharingOptionView];
    [SharingOptionView release];
    
    [ToolBarView setFrame:CGRectMake(11,940,768,67)];
    [self.view addSubview:ToolBarView];
    [ToolBarView release];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Overlayout"])
    {
        UIView *Overlayout = [[UIView alloc] initWithFrame:CGRectMake(0,0,768,1024)];
        Overlayout.tag = 1000;
        UIImageView *OverlayImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Overlay.png"]];
        [Overlayout addSubview:OverlayImg];
        [OverlayImg release];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [Overlayout addGestureRecognizer:singleTap];
        [singleTap release];
        
        [self.view addSubview:Overlayout];
        [Overlayout release];
        [self performSelectorOnMainThread:@selector(setBrushButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(setBackButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(setColorButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(setAviaryButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(setInfoButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
        
    }
    if (![[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"] isEqualToString:@""])
    {
        UIImage *Img = [UIImage imageWithContentsOfFile:[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"]];
        Erash.enabled = TRUE;
        [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                               withObject:[NSNumber numberWithBool:YES]
                            waitUntilDone:NO];
        [slv loadFromAlbumButtonClicked:Img];
    }
    BrushSizeSlider.value = 5.0;
    [super viewDidLoad];
    
    oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
    [oAuthTwitter load];
    oAuth = oAuthTwitter;
	// Do any additional setup after loading the view, typically from a nib.
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
    return NO;
}
/*!
 @method      showColorPicker
 @abstract    It is an IBAction Method for Color Picker View.
 @discussion  On clicking the Color Plate Button,Open color picker view.
 @result      On clicking the Color Plate Button,Open color picker view.
 */
-(IBAction)showColorPicker:(id)sender{
    
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"])
    {
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        Erash.selected = FALSE;
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        [slv eraserButtonClicked];
    }
    if (self.ColorPickerPopup == nil) {
        
        colorPicker = 
        [[ColorPickerController alloc] initWithColor:[UIColor redColor] andTitle:@"Color Picker"];
        colorPicker.delegate = self;
        UINavigationController *navigationController = 
        [[UINavigationController alloc] initWithRootViewController:colorPicker];
        UIPopoverController *popover = 
        [[UIPopoverController alloc] initWithContentViewController:navigationController]; 
        [popover setPopoverContentSize:CGSizeMake(320,480) animated:YES];
        popover.delegate = self;
        
        self.ColorPickerPopup = popover;
        [popover release];
    }
    if (self.BrushPicker  != nil) {
        [self.BrushPicker  dismissPopoverAnimated:YES];
    }
    
    CGRect selectedRect = CGRectMake(94,950,320,480);
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Solid" forKey:@"BrushOption"];
    [self.ColorPickerPopup presentPopoverFromRect:selectedRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
/*!
 @method      BrushPicker
 @abstract    It is an IBAction Method for Brush Picker Drawer.
 @discussion  On clicking the Brush Button,Open Brush Picker Drawer.
 @result      On clicking the Brush Button,Open Brush Picker Drawer.
 */
-(IBAction)BrushPicker:(id)sender
{
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    [self Slideupview];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI*-0.5);
    BrushSizeSlider.transform = trans;
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"True" forKey:@"DrawerOpen"];
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"]) 
    {
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        Erash.selected = FALSE;
        [slv eraserButtonClicked];
    }
    if (self.ColorPickerPopup  != nil) {
        [self.ColorPickerPopup  dismissPopoverAnimated:YES];
    }
    [self performSelectorOnMainThread:@selector(setBrushButtonEnable:)
                           withObject:[NSNumber numberWithBool:NO]
                        waitUntilDone:NO];
}
/*!
 @method      colorPickerSaved
 @abstract    It is a Method for close color picker.
 @discussion  On clicking the Color Plate Button,Open Brush Picker Drawer.
 @result      On clicking the Color Plate Button,Open Brush Picker Drawer.
 */
- (void)colorPickerSaved:(ColorPickerController *)controller;
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Solid" forKey:@"BrushOption"];
    [self.ColorPickerPopup dismissPopoverAnimated:YES];
}
/*!
 @method      ErashClick
 @abstract    It is an IBAction Method for open erash picker.
 @discussion  On clicking the erash Button Open erash Picker user can set erash radius.
 @result      On clicking the erash Button Open erash Picker user can set erash radius.
 */
-(IBAction)ErashClick:(id)sender
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    Erash.selected = !Erash.selected;
    if (Erash.selected) 
    {
        //NSLog(@"YEs");
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"True" forKey:@"ErashOption"];
        UIViewController *View = [[UIViewController alloc] init];
        View.view.frame = CGRectMake(0,0,200,150.0);
        View.view.backgroundColor = [UIColor whiteColor];
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0,20, 200,10)];
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        slider.minimumValue = 0.0;
        slider.maximumValue = 50.0;
        slider.continuous = YES;
        slider.value = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashRadius"] floatValue];
        
        [View.view addSubview:slider];	
        
        minLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,80,100,20)];
        minLabel.text = [[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashRadius"];
        minLabel.backgroundColor = [UIColor clearColor];
        minLabel.textColor = [UIColor blueColor];
        [View.view addSubview:minLabel];
        
        UIPopoverController *popover = 
        [[UIPopoverController alloc] initWithContentViewController:View]; 
        [popover setPopoverContentSize:CGSizeMake(200,200) animated:YES];
        popover.delegate = self;
        
        self.ErashPicker = popover;
        [popover release];
        CGRect selectedRect = CGRectMake(208,950,300,200);
        [self.ErashPicker presentPopoverFromRect:selectedRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [slv eraserButtonClicked];
        [Erash setImage:[UIImage imageNamed:@"Erash_h.png"] forState:UIControlStateNormal];
    }
    else
    {
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        [slv eraserButtonClicked];
    }
}
/*!
 @method      sliderAction
 @abstract    It is a Method for for get slider change value.
 @discussion  This method is call every time if user can change erash slider.
 @result      This method is call every time if user can change erash slider.
 */
-(void)sliderAction:(UISlider *)sender
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:[NSString stringWithFormat:@"%.0f",[sender value]] forKey:@"ErashRadius"];
    minLabel.text = [NSString stringWithFormat:@"%.0f",[sender value]];
}
/*!
 @method      sliderActionForBrush
 @abstract    It is a Method for for get brush slider change value.
 @discussion  This method is call every time if user can change brush slider.
 @result      This method is call every time if user can change brush slider.
*/
-(IBAction)sliderActionForBrush:(UISlider *)sender
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:[NSString stringWithFormat:@"%.0f",[sender value]] forKey:@"BrushWidth"];
}
/*!
 @method      SaveClick
 @abstract    It is an IBAction Method for save image.
 @discussion  On clicking the save Button,it's save in two place one is album and second one is application floder.
 @result      On clicking the save Button,it's save in two place one is album and second one is application floder.
 */
-(IBAction)SaveClick:(id)sender
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    [slv save2AlbumButtonClicked];
    if (![[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"] isEqualToString:@""]) {
        [slv EditFileButtonClicked];
    }
    else
    {
        [slv save2FileButtonClicked];
    }
    [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
    [self performSelectorOnMainThread:@selector(setSave2AlbumButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
    
}
/*!
 @method      ClearClick
 @abstract    It is an IBAction Method for clear canvas.
 @discussion  On clicking the clear Button,user can remove whole drawing from canvas.
 @result      On clicking the clear Button,user can remove whole drawing from canvas.
 */
-(IBAction)ClearClick:(id)sender
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"]) 
    {
        Erash.selected = !Erash.selected;
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        [slv eraserButtonClicked];
    }
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Clear" forKey:@"ButtonFlag"];
    [self MessageShow];
}
/*!
 @method      UndoClick
 @abstract    It is an IBAction Method for undo canvas.
 @discussion  On clicking the undo Button,user can goto backward after drawing (n stage).
 @result      On clicking the undo Button,user can goto backward after drawing (n stage).
 */
-(IBAction)UndoClick:(id)sender
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"])
    {
        Erash.selected = !Erash.selected;
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        [slv eraserButtonClicked];
    }
    [slv undoButtonClicked];
}
/*!
 @method      RedoClick
 @abstract    It is an IBAction Method for redo canvas.
 @discussion  On clicking the redo Button,user can goto foreward after drawing (n stage).
 @result      On clicking the redo Button,user can goto foreward after drawing (n stage).
 */
-(IBAction)RedoClick:(id)sender
{    
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"])
    {
        Erash.selected = !Erash.selected;
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        [slv eraserButtonClicked];
    }
    [slv redoButtonClicked];
}
/*!
 @method      BackClick
 @abstract    It is an IBAction Method for back go Drawing viwer class.
 @discussion  On clicking the back Button,user can navigate previous screen.
 @result      On clicking the back Button,user can navigate previous screen.
 */
-(IBAction)BackClick:(id)sender
{
    [self ClearFloder];
    DrawingViewer *obj = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    [obj ReloadView];
    [self.navigationController popToViewController:obj animated:YES];
}
/*!
 @method      AviaryClick
 @abstract    It is an IBAction Method for call aviary class.
 @discussion  On clicking the aviary Button,user can navigate aviary screen.
 @result      On clicking the aviary Button,user can navigate aviary screen.
 */
-(IBAction)AviaryClick:(id)sender
{
    [slv ResetStack];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"" forKey:@"ImageName"];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Avirary" forKey:@"ImageFlag"];
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"])
    {
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        Erash.selected = FALSE;
        [slv eraserButtonClicked];
    }
    UIImagePickerController *pickerController = [[UIImagePickerController new] autorelease];
    pickerController.delegate = self;
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [pickerController setDelegate:self];
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPhone:
            [self presentModalViewController:pickerController animated:YES];
            break;
        case UIUserInterfaceIdiomPad:
            [self setPopoverController:[[[UIPopoverController alloc] initWithContentViewController:pickerController] autorelease]];
            [[self popoverController] setDelegate:self];
            CGRect selectedRect = CGRectMake(300,950,320,480);
            [[self popoverController] presentPopoverFromRect:selectedRect inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        default:
            NSAssert(NO, @"Unsupported user interface idiom");
            break;
    }
}

/*!
 @method      ShareClick
 @abstract    It is an IBAction Method for call share class.
 @discussion  On clicking the share Button,user can navigate share screen.
 @result      On clicking the share Button,user can navigate share screen.
 */
-(IBAction)ShareClick:(id)sender
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    [self SlideupShareview];
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"])
    {
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ErashOption"];
        [Erash setImage:[UIImage imageNamed:@"Erase.png"] forState:UIControlStateNormal];
        Erash.selected = FALSE;
        [slv eraserButtonClicked];
    }
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:NO]
                        waitUntilDone:NO];
}
/*!
 @method      NewClick
 @abstract    It is an IBAction Method for create new canvas.
 @discussion  On clicking the new Button,user can draw new image.
 @result      On clicking the new Button,user can draw new image.
 */
-(IBAction)NewClick:(id)sender
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [self Slidedownview];
    }
    if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
    }
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"New" forKey:@"ButtonFlag"];
    [self MessageShow];
}
/*!
 @method      BrushTypeClick
 @abstract    It is an IBAction Method for chosse brush option.
 @discussion  On clicking the brush Button,user can choose different type of brush.
 @result      On clicking the brush Button,user can choose different type of brush.
 */
-(IBAction)BrushTypeClick:(id)sender
{
    int Tag = [sender tag];
    switch (Tag)
    {
        UIButton *BtnPen,*BtnCry,*BtnSolid;
        case 100:
            [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Pencial" forKey:@"BrushOption"];
            BtnPen = (UIButton *)[BrushView viewWithTag:100];
            [BtnPen setImage:[UIImage imageNamed:@"_0044_Shape-18.png"] forState:UIControlStateNormal];
            BtnCry = (UIButton *)[BrushView viewWithTag:200];
            [BtnCry setImage:[UIImage imageNamed:@"_0043_Shape-18-copy.png"] forState:UIControlStateNormal];
            BtnSolid = (UIButton *)[BrushView viewWithTag:300];
            [BtnSolid setImage:[UIImage imageNamed:@"_0043_Shape-18-copy.png"] forState:UIControlStateNormal];
            [self SetPencialBrush];
            break;
        case 200:
            [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Crayon" forKey:@"BrushOption"];
            BtnPen = (UIButton *)[BrushView viewWithTag:100];
            [BtnPen setImage:[UIImage imageNamed:@"_0043_Shape-18-copy.png"] forState:UIControlStateNormal];
            BtnCry = (UIButton *)[BrushView viewWithTag:200];
            [BtnCry setImage:[UIImage imageNamed:@"_0044_Shape-18.png"] forState:UIControlStateNormal];
            BtnSolid = (UIButton *)[BrushView viewWithTag:300];
            [BtnSolid setImage:[UIImage imageNamed:@"_0043_Shape-18-copy.png"] forState:UIControlStateNormal];
            [self SetCrayonBrush];
            break;
        case 300:
            [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"Solid" forKey:@"BrushOption"];
            BtnPen = (UIButton *)[BrushView viewWithTag:100];
            [BtnPen setImage:[UIImage imageNamed:@"_0043_Shape-18-copy.png"] forState:UIControlStateNormal];
            BtnCry = (UIButton *)[BrushView viewWithTag:200];
            [BtnCry setImage:[UIImage imageNamed:@"_0043_Shape-18-copy.png"] forState:UIControlStateNormal];
            BtnSolid = (UIButton *)[BrushView viewWithTag:300];
            [BtnSolid setImage:[UIImage imageNamed:@"_0044_Shape-18.png"] forState:UIControlStateNormal];
            [self SetSolidBrush];
            break;
        default:
            break;
    }
}
/*!
 @method      ColorBrushClick
 @abstract    It is an IBAction Method for chosse color from drawer.
 @discussion  On clicking the color Button,user can choose different color from color drawer.
 @result      On clicking the color Button,user can choose different color from drawer.
 */
-(IBAction)ColorBrushClick:(id)sender
{
    UIButton *BtnCurrentbrush = (UIButton *)[BrushView viewWithTag:[sender tag]];
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushOption"] isEqualToString:@"Pencial"])
    {
        [self SetPencialBrush];
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:[NSString stringWithFormat:@"P%i_2.png",[BtnCurrentbrush tag]] forKey:@"PatternImage"];
    }
    else if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushOption"] isEqualToString:@"Crayon"])
    {
        [self SetCrayonBrush];
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:[NSString stringWithFormat:@"C%i_2.png",[BtnCurrentbrush tag]] forKey:@"PatternImage"];
    }
    else if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushOption"] isEqualToString:@"Solid"])
    {
        [self SetSolidBrush];
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:[[SolidColor objectAtIndex:[BtnCurrentbrush tag]-1] valueForKey:@"hue"] forKey:@"hue"];
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:[[SolidColor objectAtIndex:[BtnCurrentbrush tag]-1] valueForKey:@"saturation"] forKey:@"saturation"];
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:[[SolidColor objectAtIndex:[BtnCurrentbrush tag]-1] valueForKey:@"brightness"] forKey:@"brightness"];
        [[DrawingIpadAppDelegate getGlobalInfo] setValue:[[SolidColor objectAtIndex:[BtnCurrentbrush tag]-1] valueForKey:@"Haxcode"] forKey:@"Haxcode"];
        [colorPicker SetColor];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [BtnCurrentbrush setFrame:CGRectMake(BtnCurrentbrush.frame.origin.x,BtnCurrentbrush.frame.origin.y-25,BtnCurrentbrush.frame.size.width,BtnCurrentbrush.frame.size.height)];
    [UIView commitAnimations];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"tab"
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    [audioPlayer play];
//    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(Slidedownview) userInfo:nil repeats:NO];
}
/*!
 @method      facebookAction
 @abstract    It is an IBAction Method call Facebook.
 @discussion  On clicking the facebook Button,user can share drawing on facebook.
 @result      On clicking the facebook Button,user can share drawing on facebook.
 */
-(IBAction)facebookAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFacebookStatus) name:@"FacebookLoginFail" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFacebookStatus) name:@"FacebookDidLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successfullyUploadImage) name:@"FacebookCompleteUploading" object:nil];
    
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"FB" forKey:@"Share"];
    DrawingIpadAppDelegate *delegat = (DrawingIpadAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegat facebook] isSessionValid])
    {
        [delegat fbDidLogin];
        delegat.statusFbInfo = fblogin;
    }
    else
    {
        [self uploadPhotoOnFacebook];
    }
}
/*!
 @method      uploadPhotoOnFacebook
 @abstract    It will be call facebook upload photo method.
 @discussion  It will be call facebook upload photo method.
 @result      It will be call facebook upload photo method.
 */
- (void)uploadPhotoOnFacebook {
    
    DrawingIpadAppDelegate *delegat = (DrawingIpadAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegat.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:delegat.HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    [delegat.HUD show:YES];
    delegat.statusFbInfo = postImageONfb;
    
    UIImage *img = [slv CaptureImageOnly];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",
                                   nil];
    [[delegat facebook] requestWithGraphPath:@"me/photos"
                                   andParams:params
                               andHttpMethod:@"POST"
                                 andDelegate:delegat];
}
/*!
 @method      setFacebookStatus
 @abstract    It will be set facebook status.
 @discussion  It will be set facebook status.
 @result      It will be set facebook status.
 */
- (void)setFacebookStatus
{	
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"FacebookLoginFail" object:nil];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"FacebookDidLogin" object:nil];
        DrawingIpadAppDelegate *delegat = (DrawingIpadAppDelegate *)[[UIApplication sharedApplication] delegate];
        delegat.statusFbInfo = postImageONfb;
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(uploadPhotoOnFacebook) userInfo:nil repeats:NO];
}
/*!
 @method      successfullyUploadImage
 @abstract    It will be call after get success message.
 @discussion  It will be call after get success message.
 @result      It will be call after get success message.

 */
- (void)successfullyUploadImage {
    
     DrawingIpadAppDelegate *delegat = (DrawingIpadAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegat.HUD hide:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FacebookCompleteUploading" object:nil];
    [self SlidedownShareview];
    //NSLog(@"Successfully Uploading image on facebook");
}
/*!
 @method      twitterAction
 @abstract    It is an IBAction Method call twitter.
 @discussion  On clicking the twitter Button,user can share drawing on twitter.
 @result      On clicking the twitter Button,user can share drawing on twitter.
 */
-(IBAction)twitterAction:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.8];
    [SharingOptionView setFrame:CGRectMake(21, 1007, 416, 206)]; // Move footer on screen
    [slv setFrame:CGRectMake(self.view.bounds.origin.x+15, self.view.bounds.origin.y+15, self.view.bounds.size.width-30, self.view.bounds.size.height - 86)];
    [UIView commitAnimations];
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    UIImage *Img = [slv CaptureImageOnly];
    TempImg.image = Img;
    [self presentLoginWithFlowType];
    
}

/*!
 @method      mailAction
 @abstract    It is an IBAction Method open mail composer.
 @discussion  On clicking the mail Button,user can share drawing on mail.
 @result      On clicking the mail Button,user can share drawing on mail.
 */
-(IBAction)mailAction:(id)sender
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ShareDrawerOpen"];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.8];
    [SharingOptionView setFrame:CGRectMake(21, 1007, 416, 206)]; // Move footer on screen
    [slv setFrame:CGRectMake(self.view.bounds.origin.x+15, self.view.bounds.origin.y+15, self.view.bounds.size.width-30, self.view.bounds.size.height - 86)];
    [UIView commitAnimations];
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
	[mailController setSubject:@"Drawing app image"];
	[mailController setMessageBody:@"This is generated form DrawingIpad Application...." isHTML:NO];
    UIImage *img = [slv CaptureImageOnly];
    
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0,0,img.size.width,img.size.height)];
    UITextView *myText = [[UITextView alloc] init];
    myText.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
    myText.textColor = [UIColor lightGrayColor];
    myText.text = NSLocalizedString(@"© Drawing Pad Pro application", @"");
    myText.backgroundColor = [UIColor clearColor];
    
    CGSize maximumLabelSize = CGSizeMake(img.size.width,img.size.height);
    CGSize expectedLabelSize = [myText.text sizeWithFont:myText.font constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    myText.frame = CGRectMake((img.size.width - 100) - (expectedLabelSize.width / 2),
                             (img.size.height - 8) - (expectedLabelSize.height / 2),
                              img.size.width,
                              img.size.height);
    
    [[UIColor lightGrayColor] set];
    [myText.text drawInRect:myText.frame withFont:myText.font];
    UIImage *myNewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *myData = UIImagePNGRepresentation(myNewImage);
    [mailController addAttachmentData:myData mimeType:@"image/png" fileName:@"Drawing"];
	[self presentModalViewController:mailController animated:YES];
	[mailController release];
}
/*!
 @method      InfoClick
 @abstract    It is an IBAction Method for show company info.
 @discussion  On clicking the info view so user can see about us.
 @result      On clicking the info view so user can see about us.
 */
-(IBAction)InfoClick:(id)sender
{
    [self.view addSubview:AboutView];
    [UIView beginAnimations:@"glow" context:nil];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    for(int i=0; i<5; i++) {
        [AboutView setAlpha:(0.25*i)];
    }
    
    [UIView commitAnimations];
}
/*!
 @method      CloseAboutInfo
 @abstract    It is an IBAction Method for close about us.
 @discussion  On clicking close about us view.
 @result      On clicking close about us view.
 */
-(IBAction)CloseAboutInfo:(id)sender
{
    [UIView beginAnimations:@"glow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.1f];
    for(int i=0;i<5;i++) {
        [AboutView setAlpha:0.0f];
    }
    [UIView commitAnimations];
}
/*!
 @method      OpenBrowser
 @abstract    It is an IBAction Method for open browser with url.
 @discussion  On clicking open browser with url.
 @result      On clicking open browser with url.
 */
-(IBAction)OpenBrowser:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.clariontechnologies.co.in"]];
}
-(IBAction)Feedbackclick:(id)sender
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
	[mailController setSubject:@"Feedback for Drawing Pad Pro"];
	[mailController setMessageBody:@"" isHTML:NO];
    [mailController setToRecipients:[NSArray arrayWithObject:@"info@clariontechnologies.co.in"]];
    [self presentModalViewController:mailController animated:YES];
}
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog (@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog (@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog (@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog (@"Result: failed");
            break;
        default:
            NSLog (@"Result: not sent");
            break;
    }

	[self dismissModalViewControllerAnimated:YES];
}
/*!
 @method      SetPencialBrush
 @abstract    It is a Method for set pencial brush potions.
 @discussion  Reload pencial image in drawer view.
 @result      Reload pencial image in drawer view.
 */
-(void)SetPencialBrush
{
    int x = 5;
    for (int i = 1;i<=16;i++)
    {
        UIButton *BtnTemp = (UIButton *)[BrushView viewWithTag:i];
        if (!BtnTemp.enabled)
        {
            BtnTemp.enabled = YES;
        }
        [BtnTemp setFrame:CGRectMake(x,47,33,158)];
        [BtnTemp setImage:[UIImage imageNamed:[NSString stringWithFormat:@"P%i.png",i]] forState:UIControlStateNormal];
        x = x + 33;
    }
}
/*!
 @method      SetCrayonBrush
 @abstract    It is a Method for set Crayon brush potions.
 @discussion  Reload Crayon image in drawer view.
 @result      Reload Crayon image in drawer view.
 */
-(void)SetCrayonBrush
{
    int x = 5;
    for (int i = 1;i<=16;i++)
    {
        UIButton *BtnTemp = (UIButton *)[BrushView viewWithTag:i];
        if (!BtnTemp.enabled)
        {
            BtnTemp.enabled = YES;
        }
        [BtnTemp setFrame:CGRectMake(x,47,33,158)];
        [BtnTemp setImage:[UIImage imageNamed:[NSString stringWithFormat:@"C%i.png",i]] forState:UIControlStateNormal];
        x = x + 33;
    }
}
/*!
 @method      SetSolidBrush
 @abstract    It is a Method for set Solid brush potions.
 @discussion  Reload Solid image in drawer view.
 @result      Reload Solid image in drawer view.
 */
-(void)SetSolidBrush
{
    int x = 8;
    for (int i = 1;i<=16;i++)
    {
        UIButton *BtnTemp = (UIButton *)[BrushView viewWithTag:i];
        if (!BtnTemp.enabled)
        {
            BtnTemp.enabled = YES;
        }
        [BtnTemp setFrame:CGRectMake(x,47,57,144)];
        [BtnTemp setImage:[UIImage imageNamed:[NSString stringWithFormat:@"S%i.png",i]] forState:UIControlStateNormal];
        x = x + 60;
    }
}
/*!
 @method      MessageShow
 @abstract    It is a Method for show message.
 @discussion  Show common message veiw.
 @result      Show common message veiw.
 */
-(void) MessageShow
{
    NSString *Msg;
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ButtonFlag"] isEqualToString:@"Clear"])
    {
        Msg = @"Do you want to delete this drawing?";
    }
    else
    {
        Msg = @"Do you want to save this drawing??";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drawing Pad Pro"
                                                    message:Msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Yes", @"")
                                          otherButtonTitles:NSLocalizedString(@"No", @""),nil];
    alert.tag = 1;
    alert.delegate = self;
    [alert show];
    [alert release];
}

#pragma mark UIAlertViewDelegate Handle
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            if (![[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ButtonFlag"] isEqualToString:@"Clear"])
            {
                if (![[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"] isEqualToString:@""]) {
                    [slv EditFileButtonClicked];
                }
                else
                {
                    [slv save2FileButtonClicked];
                }
            }
            [slv clearButtonClicked];
        }
    }

    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ButtonFlag"] isEqualToString:@"New"])
    {
        [self ClearFloder];
        [slv clearButtonClicked];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:2.0];
        [self.view setAlpha:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
        [UIView commitAnimations];
    }
    
}
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [slv loadFromAlbumButtonClicked:image];
//    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//    [library saveImage:image toAlbum:@"Draw Album" withCompletionBlock:^(NSError *error) {
//        NSString *message;
//        NSString *title;
//        if (!error) {
//            title = NSLocalizedString(@"Message", @"");
//            message = NSLocalizedString(@"Drawing save successfully", @"");
//        }
//        else {
//            
//            title = NSLocalizedString(@"Error", @"");
//            message = NSLocalizedString(@"Drawing is not save", @"");
//        }
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//        
//    }];
//    
//    BOOL error;
//    NSString *message;
//    NSString *title;
//    
//    NSDate *today = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
//    NSString *dateString = [dateFormat stringFromDate:today];
//    
//    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Screenshot %@.png",dateString]];
//    UIGraphicsEndImageContext();
//    error = [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
//    
//    if (!error) {
//        title = NSLocalizedString(@"SaveSuccessTitle", @"");
//        message = NSLocalizedString(@"SaveSuccessMessage", @"");
//    } else {
//        title = NSLocalizedString(@"SaveFailedTitle", @"");
//        message = NSLocalizedString(@"SaveFailMessage", @"");  ;
//    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)displayPhotoEditorWithImage:(UIImage *)image
{
    if (image) {
        AFPhotoEditorController *featherController = [[[AFPhotoEditorController alloc] initWithImage:image] autorelease];
        [featherController setDelegate:self];
        [self presentModalViewController:featherController animated:YES];
    } else {
        NSAssert(NO, @"AFPhotoEditorController was passed a nil image");
    }
}
/*!
 @method      Slideupview
 @abstract    It is a Method for slide up view and play sound
 @discussion  slide up drawer view method and also play drawer open sound.
 @result      slide up drawer view method and also play drawer open sound.
 */
-(void) Slideupview
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"True" forKey:@"DrawerOpen"];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.8];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"Open"
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    [audioPlayer play];
    [BrushView setFrame:CGRectMake(21, 750, 728, 206)]; // Move footer on screen
    //[slv setFrame:CGRectMake(self.view.bounds.origin.x+15, self.view.bounds.origin.y+15, self.view.bounds.size.width-30, self.view.bounds.size.height - 270)];
    [UIView commitAnimations];
}
/*!
 @method      Slidedownview
 @abstract    It is a Method for slide down view and play sound
 @discussion  slide down drawer view method and also play drawer close sound.
 @result      slide down drawer view method and also play drawer close sound.
 */
-(void) Slidedownview
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"DrawerOpen"];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.8];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"Close"
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    [audioPlayer play];
    [BrushView setFrame:CGRectMake(21, 1007, 728, 206)]; // Move footer on screen
    //[slv setFrame:CGRectMake(self.view.bounds.origin.x+15, self.view.bounds.origin.y+15, self.view.bounds.size.width-30, self.view.bounds.size.height - 86)];
    [UIView commitAnimations];
    [self performSelectorOnMainThread:@selector(setBrushButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
}
/*!
 @method      SlideupShareview
 @abstract    It is a Method for slide up view and play sound
 @discussion  slide up Share drawer view method and also play drawer open sound.
 @result      slide up Share drawer view method and also play drawer open sound.
 */
-(void) SlideupShareview
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"True" forKey:@"ShareDrawerOpen"];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.8];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"Open"
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    [audioPlayer play];
    [SharingOptionView setFrame:CGRectMake(21, 750, 726, 206)]; // Move footer on screen
    //[slv setFrame:CGRectMake(self.view.bounds.origin.x+15, self.view.bounds.origin.y+15, self.view.bounds.size.width-30, self.view.bounds.size.height - 270)];
    [UIView commitAnimations];
}
/*!
 @method      Slidedownview
 @abstract    It is a Method for slide down view and play sound
 @discussion  slide down drawer view method and also play drawer close sound.
 @result      slide down drawer view method and also play drawer close sound.
 */
-(void) SlidedownShareview
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ShareDrawerOpen"];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.8];
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"Close"
                                         ofType:@"mp3"]];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:url
                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
    }
    [audioPlayer play];
    [SharingOptionView setFrame:CGRectMake(21, 1007, 726, 206)]; // Move footer on screen
    //[slv setFrame:CGRectMake(self.view.bounds.origin.x+15, self.view.bounds.origin.y+15, self.view.bounds.size.width-30, self.view.bounds.size.height - 86)];
    [UIView commitAnimations];
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
}
#pragma mark UIImagePickerControllerDelegate Handle
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageFlag"] isEqualToString:@"Avirary"])
    {
        NSParameterAssert(image);
        
        switch (UI_USER_INTERFACE_IDIOM()) {
            case UIUserInterfaceIdiomPhone:
                [self setPickedImage:image];
                [self dismissModalViewControllerAnimated:YES];
                break;
            case UIUserInterfaceIdiomPad:
                [[self popoverController] dismissPopoverAnimated:YES];
                [self setPopoverController:nil];
                [self displayPhotoEditorWithImage:image];
                break;
            default:
                break;
        }
        [self dismissModalViewControllerAnimated:YES];

    }
    else
    {
        [Imagepopover dismissPopoverAnimated:YES];
        [slv loadFromAlbumButtonClicked:image];
        [Imagepopover release];
    }
}
/*!
 @method      SingleTap
 @param1      It will be pass view gesture.
 @abstract    It is a Method for handle overlayout view remove process.
 @discussion  SingleTap method remove overlayout form canvas and enable buttons.
 @result      SingleTap method remove overlayout form canvas and enable buttons.
 */
- (void)SingleTap:(UIGestureRecognizer *)gesture
{
    UIView *TempView = [self.view viewWithTag:1000];
    [TempView removeFromSuperview];
    [self performSelectorOnMainThread:@selector(setBrushButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(setBackButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(setColorButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(setAviaryButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(setInfoButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Overlayout"];
}
/*!
 @method      SetColorArrayhsv
 @abstract    It is a Method store solid color hsv color value.
 @discussion  SetColorArrayhsv method add solid color hsv color in one array.
 @result      SetColorArrayhsv method add solid color hsv color in one array.
 */
-(void) SetColorArrayhsv
{
    SolidColor = [[[NSMutableArray alloc] init] retain];
    NSMutableDictionary *TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.5" forKey:@"hue"];
    [TempColor setValue:@"1.0" forKey:@"saturation"];
    [TempColor setValue:@"0.48" forKey:@"brightness"];
    [TempColor setValue:@"007a79" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];
    
    TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.90" forKey:@"hue"];
    [TempColor setValue:@"1.0" forKey:@"saturation"];
    [TempColor setValue:@"0.94" forKey:@"brightness"];
    [TempColor setValue:@"dc088c" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];

    TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.56" forKey:@"hue"];
    [TempColor setValue:@"0.99" forKey:@"saturation"];
    [TempColor setValue:@"0.69" forKey:@"brightness"];
    [TempColor setValue:@"0068b4" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];

    TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.12" forKey:@"hue"];
    [TempColor setValue:@"0.76" forKey:@"saturation"];
    [TempColor setValue:@"1.0" forKey:@"brightness"];
    [TempColor setValue:@"ffce05" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];

    TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.29" forKey:@"hue"];
    [TempColor setValue:@"0.56" forKey:@"saturation"];
    [TempColor setValue:@"0.76" forKey:@"brightness"];
    [TempColor setValue:@"7fc344" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];

    TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.5" forKey:@"hue"];
    [TempColor setValue:@"0.98" forKey:@"saturation"];
    [TempColor setValue:@"0.67" forKey:@"brightness"];
    [TempColor setValue:@"1ba9aa" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];

    TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.86" forKey:@"hue"];
    [TempColor setValue:@"0.81" forKey:@"saturation"];
    [TempColor setValue:@"0.57" forKey:@"brightness"];
    [TempColor setValue:@"871e7d" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];

    TempColor = [[NSMutableDictionary alloc] init];
    [TempColor setValue:@"0.97" forKey:@"hue"];
    [TempColor setValue:@"1.0" forKey:@"saturation"];
    [TempColor setValue:@"1.0" forKey:@"brightness"];
    [TempColor setValue:@"ee1f25" forKey:@"Haxcode"];
    [SolidColor addObject:TempColor];
    [TempColor release];
}
#pragma mark toolbarDelegate 
/*!
 @method setUndoButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setUndoButtonEnable:(NSNumber*)isEnable
{
    [Undo setEnabled:[isEnable boolValue]];
}
/*!
 @method setRedoButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setRedoButtonEnable:(NSNumber*)isEnable
{
    [Redo setEnabled:[isEnable boolValue]];
}
/*!
 @method setClearButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setClearButtonEnable:(NSNumber*)isEnable
{
    [Clear setEnabled:[isEnable boolValue]];
}
/*!
 @method setEraserButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setEraserButtonEnable:(NSNumber*)isEnable
{
    [Erash setEnabled:[isEnable boolValue]];
}
/*!
 @method setSave2AlbumButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable
{
    [Savetofile setEnabled:[isEnable boolValue]];
}
/*!
 @method setShareButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setShareButtonEnable:(NSNumber*)isEnable
{
    [Share setEnabled:[isEnable boolValue]];
}
/*!
 @method setNewButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setNewButtonEnable:(NSNumber*)isEnable
{
    [New setEnabled:[isEnable boolValue]];
}
/*!
 @method setBrushButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setBrushButtonEnable:(NSNumber*)isEnable
{
    [Brush setEnabled:[isEnable boolValue]];
}
/*!
 @method setUndoButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setBackButtonEnable:(NSNumber*)isEnable
{
    [Back setEnabled:[isEnable boolValue]];
}
/*!
 @method setAviaryButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setAviaryButtonEnable:(NSNumber*)isEnable
{
    [aviry setEnabled:[isEnable boolValue]];
}
/*!
 @method setColorButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setColorButtonEnable:(NSNumber*)isEnable
{
    [Color setEnabled:[isEnable boolValue]];
}
/*!
 @method setInfoButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setInfoButtonEnable:(NSNumber*)isEnable
{
    [Savetophoto setEnabled:[isEnable boolValue]];
}

#pragma mark -
#pragma mark oAuthLoginPopupDelegate

- (void)oAuthLoginPopupDidCancel:(UIViewController *)popup {
    [self dismissModalViewControllerAnimated:YES];
    [loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
}

- (void)oAuthLoginPopupDidAuthorize:(UIViewController *)popup {
    [self dismissModalViewControllerAnimated:YES];
    [loginPopup release]; loginPopup = nil; // was retained as ivar in "login"
    [oAuthTwitter save];
}

#pragma mark -
#pragma mark TwitterLoginUiFeedback

- (void) tokenRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did start");
    [loginPopup.activityIndicator startAnimating];
}

- (void) tokenRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did succeed");
    [loginPopup.activityIndicator stopAnimating];
}

- (void) tokenRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"token request did fail");
    [loginPopup.activityIndicator stopAnimating];
}

- (void) authorizationRequestDidStart:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization request did start");
    [loginPopup.activityIndicator startAnimating];
}

- (void) authorizationRequestDidSucceed:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization request did succeed");
    [loginPopup.activityIndicator stopAnimating];
    [self didPressPostImage];
}

- (void) authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization token request did fail");
    [loginPopup.activityIndicator stopAnimating];
}

#pragma mark -
#pragma mark Present login flows

- (void) presentLoginWithFlowType{
    
    if (!loginPopup) {
        loginPopup = [[CustomLoginPopup alloc] initWithNibName:@"TwitterLoginCallbackFlow" bundle:nil];
        loginPopup.flowType = TwitterLoginCallbackFlow;
        loginPopup.oAuthCallbackUrl = @"fb343229545773738://handleOAuthLogin";
        loginPopup.oAuth = oAuthTwitter;
        loginPopup.delegate = self;
        loginPopup.uiDelegate = self;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
    [self presentModalViewController:nav animated:YES];
}
-(void)didPressPostImage
{
    NSString *url = @"http://api.twitpic.com/2/upload.json";
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setValue:@"https://api.twitter.com/1/account/verify_credentials.json" forHTTPHeaderField:@"X-Auth-Service-Provider"];
    [req setValue:[oAuth oAuthHeaderForMethod:@"GET"
                                       andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                    andParams:nil] forHTTPHeaderField:@"X-Verify-Credentials-Authorization"];
    
    NSData *imageData = UIImageJPEGRepresentation(TempImg.image, 0.8);
    
    [req setHTTPMethod:@"POST"];
    // Image uploading and form construction technique with NSURLRequest: http://www.cocoanetics.com/2010/02/uploading-uiimages-to-twitpic/
    
    // Just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    // Header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // Set header
    [req addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    // Twitpic API key
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"key\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Define this TWITPIC_API_KEY somewhere or replace with your own key inline right here.
    [postBody appendData:[@"2dfce541ea576bbd2faecdd13c51e9b3" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // TwitPic API doc says that message is mandatory, but looks like
    // it's actually optional in practice as of July 2010. You may or may not send it, both work.
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"message\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Drawing Pad Pro Twitpic!!!" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // media part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"dummy.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add it to body
    [postBody appendData:imageData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postBody];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error] encoding:NSUTF8StringEncoding] autorelease];
    
    if (error) {
        NSLog(@"Error from NSURLConnection: %@", error);
    }
    //NSLog(@"Got HTTP status code from TwitPic: %d", [response statusCode]);
    //NSLog(@"Response string: %@", responseString);
    SBJSON *Obj = [[SBJSON alloc] init];
    NSDictionary *twitpicResponse = [Obj objectWithString:responseString];
    //NSLog(@"%@",[twitpicResponse description]);
    NSString *Url = [twitpicResponse valueForKey:@"url"];
    if (Url != (id)[NSNull null] || Url.length != 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drawing Pad Pro" message:@"Drawing upload successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
- (void)handleOAuthVerifier:(NSString *)oauth_verifier {
    [loginPopup authorizeOAuthVerifier:oauth_verifier];
}

-(void)ClearFloder
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/WB"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:pngPath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", pngPath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}
- (void)dealloc
{
    ColorPickerPopup = nil;BrushPicker = nil;ErashPicker=nil;colorPicker = nil;
    Imagepopover = nil;
    audioPlayer = nil;
    SolidColor = nil;
    [audioPlayer release];
    [SolidColor release];
    [Imagepopover release];
    [BrushPicker release];
    [ErashPicker release];
    [colorPicker release];
    [super dealloc];
}
@end
