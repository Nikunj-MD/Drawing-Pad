/**
 
 ClassName:: DrawingViewer
 
 Superclass:: UIViewController
 
 Class Description:: This class is drawing canvas so user can draw here anything.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 27/09/12.
 
 Modified Date:: 15/10/12.
 */


#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>

#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"

#define OAUTH_TWITTER_CONSUMER_KEY @"kte5iBlKKrkMp43LTtBfQ"
#define OAUTH_TWITTER_CONSUMER_SECRET @"9vXIy6ZhHiijPTPXS8jjXT2xWsM1oRkQo6OVx3II3c"

@class OAuthTwitter,OAuth,CustomLoginPopup;

@interface DrawingViewer : UIViewController<iCarouselDataSource, iCarouselDelegate,MFMailComposeViewControllerDelegate,oAuthLoginPopupDelegate, TwitterLoginUiFeedback,AVAudioPlayerDelegate>
{
    IBOutlet UIView *ToolBarView,*SharingOptionView;
    IBOutlet UIButton *Share,*Clear;
    AVAudioPlayer *audioPlayer;
    
    OAuthTwitter *oAuthTwitter;
    OAuth *oAuth;
    CustomLoginPopup *loginPopup;
}
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) IBOutlet UIButton *Delete;
- (IBAction)removeItem;
- (IBAction)CreateNewDrawing:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)mailAction:(id)sender;
- (IBAction)ShareClick:(id)sender;
- (void)ReloadView;
-(void)uploadPhotoOnFacebook;
- (void) handleOAuthVerifier:(NSString *)oauth_verifier;
- (void)presentLoginWithFlowType;
- (void)didPressPostImage;
@end
