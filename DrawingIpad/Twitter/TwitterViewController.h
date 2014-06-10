//
//  TwitterViewController.h
//  PlainOAuth
//
//  Created by Nikunj Modi on 18/10/12.
//
//

#import <UIKit/UIKit.h>
#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"

#define OAUTH_TWITTER_CONSUMER_KEY @"RY497KYQjZFoUGlPuyqkXw"
#define OAUTH_TWITTER_CONSUMER_SECRET @"9qEsOEho0I1UZtQYW3ArQDcgVJRuBLLBohdQMeFnHo4"

@class OAuthTwitter,OAuth,CustomLoginPopup;
@interface TwitterViewController : UIViewController<oAuthLoginPopupDelegate, TwitterLoginUiFeedback>
{
    OAuthTwitter *oAuthTwitter;
    OAuth *oAuth;
    CustomLoginPopup *loginPopup;
}
- (void) handleOAuthVerifier:(NSString *)oauth_verifier;
- (IBAction)Twitte:(id)sender;
- (void)presentLoginWithFlowType;
-(void)didPressPostImage;
@end
