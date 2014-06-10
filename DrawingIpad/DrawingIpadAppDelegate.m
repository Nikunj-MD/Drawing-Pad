/**
 
 ClassName:: DrawingIpadAppDelegate
 
 Superclass:: UIResponder
 
 Class Description:: This class is the delegate class it's call splashscreen class.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date::  17/09/12.
 
 Modified Date:: 12/10/12.
 
 */

#import "DrawingIpadAppDelegate.h"
#import "DrawingIpadViewController.h"
#import "SplashScreen.h"
#import "DrawingViewer.h"
@implementation DrawingIpadAppDelegate

static NSString* kAppId = @"343229545773738";
@synthesize facebook;
@synthesize userPermissions,statusFbInfo;
@synthesize permissions,dictFacebookInformation;

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize nav,HUD;
NSMutableDictionary *globalInfo;
- (void)dealloc
{
    globalInfo = nil;
    [globalInfo release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    globalInfo=[[NSMutableDictionary alloc]init];
    SplashScreen *obj = [[SplashScreen alloc] initWithNibName:@"SplashScreen" bundle:nil];
    //self.viewController = obj;
    self.nav = [[UINavigationController alloc] initWithRootViewController:obj];
    self.nav.navigationBarHidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(GotoDrawingCanvas) userInfo:nil repeats:NO];
    self.window.rootViewController = self.nav;
    
    //FaceBook Method
    [self initialSettingForFacebook];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Overlayout"])
    {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Overlayout"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Overlayout"];
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Overlayout"];
    }
    [self.window makeKeyAndVisible];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/WB"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:pngPath error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", pngPath, file] error:&error];
        if (!success || error) {
            // it failed.
        }
    }
    return YES;
}
/*!
 @method GotoDrawingCanvas
 @abstract It will be call drawing viewer class.
 @discussion It will be call drawing viewer class.
 @result User can draw anything in this class.
 */
-(void)GotoDrawingCanvas
{    
    DrawingViewer *Obj = [[DrawingViewer alloc] initWithNibName:@"DrawingViewer" bundle:nil];
    [self.nav pushViewController:Obj animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
/*!
 @method getGlobalInfo
 @abstract It will be store globle data for this application
 @discussion It will be store and easily access to any where in project.
 @result User can access this dictionary any where in project.
 */
+(NSMutableDictionary *)getGlobalInfo{
	return globalInfo;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        NSString* urlString=[url absoluteString];
        NSString *loginCmd=@"fb343229545773738://handleOAuthLogin";
        //Expects to receive myapp://login?user_name&password
        if ([urlString hasPrefix:loginCmd]){
            NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"?"];
            NSArray *requestParameterChunks = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
            for (NSString *chunk in requestParameterChunks) {
                NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
                
                if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
                    DrawingIpadViewController *obj = [self.nav.viewControllers objectAtIndex:[self.nav.viewControllers count]-1];
                    [obj handleOAuthVerifier:[keyVal objectAtIndex:1]];
                }
                
            }
            return YES;
        }
            
    else
    return [self.facebook handleOpenURL:url];
}
#pragma mark -
#pragma mark Facebook + User Method

- (void)initialSettingForFacebook {
    
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
	permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil];
    
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
        [alertView release];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
            [alertView release];
        }
    }
}

- (void)showLoggedIn {
    
	if (![facebook isSessionValid])
        [facebook authorize:permissions];
	else
        [self apiFQLIMe];
}

- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
                                   nil];
    [facebook requestWithMethodName:@"fql.query"
                          andParams:params
                      andHttpMethod:@"POST"
                        andDelegate:self];//@"SELECT uid, name, pic FROM user WHERE uid=me()", @"query",
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)apiGraphUserPermissions {
    
    [facebook requestWithGraphPath:@"me/permissions" andDelegate:self];
}

#pragma mark - User Method + Posting Message On Wall

- (void)uploadFeed {
    
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started",@"name",[dictFacebookInformation objectForKey:@"URL"],@"link", nil], nil];
    
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [dictFacebookInformation objectForKey:@"Title"], @"name",
                                   @"DrawindIpad", @"caption",
                                   [dictFacebookInformation objectForKey:@"Title"], @"description",
                                   [dictFacebookInformation objectForKey:@"URL"], @"link",
                                   [dictFacebookInformation objectForKey:@"ImagePath"], @"picture",
                                   actionLinksStr, @"actions",
                                   nil];
    
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
}

/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary *)parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    [self showLoggedIn];
	
    [self storeAuthData:[facebook accessToken] expiresAt:[facebook expirationDate]];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Not Logged to facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"URL %@", [response URL]);
    NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
    //NSLog(@"%d", newResp.statusCode);
    int responseStatusCode = [newResp statusCode];
    if(statusFbInfo == postImageONfb) {
        if (responseStatusCode != 400)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Drawing Pad Pro" message:@"Drawing upload successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    if(statusFbInfo == fblogin) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookDidLogin" object:nil];
    }
    
    else if(statusFbInfo == postImageONfb) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookCompleteUploading" object:nil];;
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:[NSString stringWithFormat:@"Err message: %@",[[error userInfo] objectForKey:@"error_msg"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
    
     //NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
     //NSLog(@"Err code: %d", [error code]);
}

#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        NSLog(@"User canceled dialog or there was an error");
        return;
    }
    
    //    NSDictionary *params = [self parseURLParams:[url query]];
    NSDictionary *params = [self parseURLParams:[url query]];
    // Successful posts return a post_id
    if ([params valueForKey:@"post_id"]) {
        //                [self showMessage:@"Published feed successfully."];
        //        NSLog(@"Feed post ID: %@", [params valueForKey:@"post_id"]);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"PixCast" message:@"Successfully posting the feed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    //    [self showMessage:@"Oops, something went haywire."];
    
    //In Case Failed TO open the controller
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"PixCast" message:@"Problem while posting the feed on Facebook\n Do you want to try again ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == 1)//Clicked on Yes
        [self uploadFeed];
}
@end
