
/**
 
 ClassName:: DrawingViewer
 
 Superclass:: UIViewController
 
 Class Description:: This class is drawing canvas so user can draw here anything.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 27/09/12.
 
 Modified Date:: 15/10/12.
 */

#import "DrawingViewer.h"
#import <QuartzCore/QuartzCore.h>
#import "DrawingIpadViewController.h"

#import "OAuthTwitter.h"
#import "OAuthConsumerCredentials.h"
#import "OAuth.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "SBJson.h"
#import "NSString+URLEncoding.h"

@interface DrawingViewer ()
@property (nonatomic, assign) BOOL wrap;
@end

@implementation DrawingViewer
@synthesize carousel;
@synthesize items,Delete;
@synthesize wrap;
- (void)setUp
{
    //set up data
    wrap = YES;
    self.items = [NSMutableArray array];
    NSString  *pngPath = NSTemporaryDirectory();
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray* dirContents=[fileMgr contentsOfDirectoryAtPath:pngPath error:nil];
    for (NSString *tString in dirContents) {
        if ([tString hasSuffix:@".png"])
        {
            [items addObject:[NSString stringWithFormat:@"%@%@",pngPath,tString]];
        }
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       [self setUp];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [SharingOptionView setFrame:CGRectMake(21,1007,726,206)];
    [self.view addSubview:SharingOptionView];
    [SharingOptionView release];
    
    [ToolBarView setFrame:CGRectMake(0,940,768,64)];
    [self.view addSubview:ToolBarView];
    [ToolBarView release];
    carousel.type = iCarouselTypeCoverFlow2;
    oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
    [oAuthTwitter load];
    oAuth = oAuthTwitter;
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%d",carousel.numberOfItems);
    if (carousel.numberOfItems == 0)
    {
        [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(setClearButtonEnable:)
                               withObject:[NSNumber numberWithBool:NO]
                            waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                               withObject:[NSNumber numberWithBool:YES]
                            waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(setClearButtonEnable:)
                               withObject:[NSNumber numberWithBool:YES]
                            waitUntilDone:NO];

    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}
- (void)ReloadView
{
    [self setUp];
    [carousel reloadData];
}
#pragma mark -
#pragma mark IBAction methods
/*!
 @method      removeItem
 @abstract    It is an IBAction Method for delete Button.
 @discussion  On clicking the delete Button, remove that image from carousel.
 @result      On clicking the delete Button, remove that image from carousel.
 */
- (IBAction)removeItem
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:@"Are you sure you want to delete this drawing?"
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
    if (buttonIndex == 0)
        {
            if (carousel.numberOfItems > 0)
            {
                NSInteger index = carousel.currentItemIndex;
                NSFileManager *fileMgr = [[[NSFileManager alloc] init] autorelease];
                NSError *error = nil;
                if (error == nil)
                {
                    BOOL removeSuccess = [fileMgr removeItemAtPath:[items objectAtIndex:index] error:&error];
                    if (!removeSuccess) {
                        // Error handling
                        //NSLog(@"HI");
                    }
                } else {
                    // Error handling
                   // NSLog(@"HELLO");
                }
                [carousel removeItemAtIndex:index animated:YES];
                [items removeObjectAtIndex:index];
            }
        }
}
/*!
 @method      CreateNewDrawing
 @abstract    It is an IBAction Method for New Button.
 @discussion  On clicking the New Button, Create new image means navigate Drawing canvas screen.
 @result      On clicking the New Button, Create new image means navigate Drawing canvas screen.
 */
-(IBAction)CreateNewDrawing:(id)sender
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"" forKey:@"ImageName"];
    DrawingIpadViewController *Obj =[[DrawingIpadViewController alloc] initWithNibName:@"DrawingIpadViewController" bundle:nil];
    [self.navigationController pushViewController:Obj animated:YES];
    [Obj release];
}
/*!
 @method      ShareClick
 @abstract    It is an IBAction Method for call share class.
 @discussion  On clicking the share Button,user can navigate share screen.
 @result      On clicking the share Button,user can navigate share screen.
 */
-(IBAction)ShareClick:(id)sender
{
    [self SlideupShareview];
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:NO]
                        waitUntilDone:NO];
}
/*!
 @method      facebookAction
 @abstract    It is an IBAction Method call Facebook.
 @discussion  On clicking the facebook Button,user can share drawing on facebook.
 @result      On clicking the facebook Button,user can share drawing on facebook.
 */
-(IBAction)facebookAction:(id)sender
{
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"False" forKey:@"ShareDrawerOpen"];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.8];
    [SharingOptionView setFrame:CGRectMake(21, 1007, 726, 206)];
    [UIView commitAnimations];
    
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
    
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
    
    // Download a sample photo
    
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[items objectAtIndex:carousel.currentItemIndex]]];
    
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
    [UIView commitAnimations];
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
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
    [SharingOptionView setFrame:CGRectMake(21, 1007, 726, 206)];
    [UIView commitAnimations];
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];

    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
	[mailController setSubject:@"Drawing app image"];
	[mailController setMessageBody:@"This is generated form DrawingIpad Application...." isHTML:NO];
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[items objectAtIndex:carousel.currentItemIndex]]];
    
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0,0,img.size.width,img.size.height)];
    UITextView *myText = [[UITextView alloc] init];
    myText.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
    myText.textColor = [UIColor lightGrayColor];
    myText.text = NSLocalizedString(@"© DrawingIPad application", @"");
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
    [UIView commitAnimations];
    [self performSelectorOnMainThread:@selector(setShareButtonEnable:)
                           withObject:[NSNumber numberWithBool:YES]
                        waitUntilDone:NO];
}
#pragma mark Gesture handle
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"] && carousel.numberOfItems < 0)
    {
        [self SlidedownShareview];
        return;
    }
}
#pragma mark toolbarDelegate
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
 @method setClearButtonEnable
 @param1.. It will set Enable value.
 @discussion It is used to set button enable value.
 @result User will button enable and disable.
 */
-(void) setClearButtonEnable:(NSNumber*)isEnable
{
    [Clear setEnabled:[isEnable boolValue]];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 300.0f)] autorelease];
        //((UIImageView *)view).image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[items objectAtIndex:index]]];
        view.contentMode = UIViewContentModeCenter;
        UIImageView *Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Frame-Big.png"]];
        Img.frame = CGRectMake(-60,-130,438,571);
        [view addSubview:Img];
        [Img release];
        
        UIImageView *Img1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[items objectAtIndex:index]]]];
        Img1.frame = CGRectMake(-20,-87,356,480);
        Img1.layer.masksToBounds = YES;
        Img1.layer.cornerRadius = 10.0;
        [view addSubview:Img1];
        [Img1 release];
    }
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
       view = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 300.0f)] autorelease];
        view.contentMode = UIViewContentModeCenter;
        
        UIImageView *Img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Frame-Big.png"]];
        Img.frame = CGRectMake(-60,-130,438,571);
        [view addSubview:Img];
        
        if ([items count]>0)
        {
            if ([items count] == 1)
            {
                UIImageView *Img1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[items objectAtIndex:0]]]];
                Img1.frame = CGRectMake(-50,-87,356,480);
                Img1.layer.masksToBounds = YES;
                Img1.layer.cornerRadius = 10.0;
                [view addSubview:Img1];
                [Img release];
            }
            else
            {
                UIImageView *Img1 = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[items objectAtIndex:index]]]];
                Img1.frame = CGRectMake(-50,-87,356,480);
                Img1.layer.masksToBounds = YES;
                Img1.layer.cornerRadius = 10.0;
                [view addSubview:Img1];
                [Img1 release];
            }
        }
    }
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 3.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [self SlidedownShareview];
        return;
    }
    DrawingIpadViewController *Obj = [[DrawingIpadViewController alloc] initWithNibName:@"DrawingIpadViewController" bundle:nil];
    
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:[items objectAtIndex:index] forKey:@"ImageName"];
    [self.navigationController pushViewController:Obj animated:YES];
    [Obj release];
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
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",[items objectAtIndex:carousel.currentItemIndex]]];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.8);
    
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
- (void)dealloc
{
    [super dealloc];
}
@end
