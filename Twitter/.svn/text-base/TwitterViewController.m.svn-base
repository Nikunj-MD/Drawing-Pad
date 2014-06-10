//
//  TwitterViewController.m
//  PlainOAuth
//
//  Created by Nikunj Modi on 18/10/12.
//
//

#import "TwitterViewController.h"
#import "OAuthTwitter.h"
#import "OAuthConsumerCredentials.h"
#import "OAuth.h"
#import "CustomLoginPopup.h"
#import "TwitterLoginPopup.h"
#import "SBJson.h"
#import "NSString+URLEncoding.h"

@interface TwitterViewController ()

@end

@implementation TwitterViewController

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
    oAuthTwitter = [[OAuthTwitter alloc] initWithConsumerKey:OAUTH_TWITTER_CONSUMER_KEY andConsumerSecret:OAUTH_TWITTER_CONSUMER_SECRET];
    [oAuthTwitter load];
    oAuth = oAuthTwitter;
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
	return YES;
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
    //[self didPressPostImage];
}

- (void) authorizationRequestDidFail:(TwitterLoginPopup *)twitterLogin {
    NSLog(@"authorization token request did fail");
    [loginPopup.activityIndicator stopAnimating];
}
- (IBAction)Twitte:(id)sender
{
    [self presentLoginWithFlowType];
}
#pragma mark -
#pragma mark Present login flows

- (void) presentLoginWithFlowType{
    
    if (!loginPopup) {
        
        
        loginPopup = [[CustomLoginPopup alloc] initWithNibName:@"TwitterLoginCallbackFlow" bundle:nil];
        loginPopup.flowType = TwitterLoginCallbackFlow;
        loginPopup.oAuthCallbackUrl = @"readtext://handleOAuthLogin";
        loginPopup.oAuth = oAuthTwitter;
        loginPopup.delegate = self;
        loginPopup.uiDelegate = self;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginPopup];
    [self presentModalViewController:nav animated:YES];
    [nav release];
}
-(void)didPressPostImage
{
    
    NSString *url = @"http://api.twitpic.com/2/upload.json";
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setValue:@"https://api.twitter.com/1/account/verify_credentials.json" forHTTPHeaderField:@"X-Auth-Service-Provider"];
    NSLog(@"%@",[oAuth oAuthHeaderForMethod:@"GET"
                                     andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                  andParams:nil]);
    [req setValue:[oAuth oAuthHeaderForMethod:@"GET"
                                       andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                    andParams:nil] forHTTPHeaderField:@"X-Verify-Credentials-Authorization"];
    UIImage *Img = [UIImage imageNamed:@"signinBullet1.png"];
    NSData *imageData = UIImageJPEGRepresentation(Img, 0.8);
    
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
    [postBody appendData:[@"oh hai!!!" dataUsingEncoding:NSUTF8StringEncoding]];
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
    NSLog(@"Got HTTP status code from TwitPic: %d", [response statusCode]);
    NSLog(@"Response string: %@", responseString);
    NSDictionary *twitpicResponse = [responseString JSONValue];
    
}
- (void)handleOAuthVerifier:(NSString *)oauth_verifier {
    [loginPopup authorizeOAuthVerifier:oauth_verifier];
}
@end
