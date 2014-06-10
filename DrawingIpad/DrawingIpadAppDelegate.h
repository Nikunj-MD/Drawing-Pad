/**
 
 ClassName:: DrawingIpadAppDelegate
 
 Superclass:: UIResponder
 
 Class Description:: This class is the delegate class it's call splashscreen class.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date::  17/09/12.
 
 Modified Date:: 20/09/12.
 
 */
#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "SplashScreen.h"
#import "MBProgressHUD.h"
typedef enum
{
    fblogin = 0,
    postImageONfb,
}
facebookStatus;

//@class DrawingIpadViewController;
@interface DrawingIpadAppDelegate : UIResponder <UIApplicationDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,MBProgressHUDDelegate>
{
    //Facebook
    Facebook *facebook;
    NSMutableDictionary *userPermissions;
	NSArray *permissions;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) SplashScreen *viewController;
@property (strong, nonatomic) UINavigationController *nav;
//Facebook
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) NSMutableDictionary *userPermissions;
@property (nonatomic, retain) NSMutableDictionary *dictFacebookInformation;
@property (nonatomic) facebookStatus statusFbInfo;

//FaceBook Access
- (void)initialSettingForFacebook;
- (void)showLoggedIn;
- (void)apiFQLIMe;
- (void)uploadFeed;
- (NSDictionary *)parseURLParams:(NSString *)query;
+(NSMutableDictionary *)getGlobalInfo;
-(void)GotoDrawingCanvas;

@end
