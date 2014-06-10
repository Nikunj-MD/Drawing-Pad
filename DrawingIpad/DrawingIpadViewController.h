/**
 
 ClassName:: DrawingIpadViewController
 
 Superclass:: UIViewController
 
 Class Description:: This class is for drawing canvas so user can draw as per color,brush,erase,share etc...
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 18/09/12.
 
 Modified Date:: 12/10/12.
 */
#import <UIKit/UIKit.h>
#import "SmoothLineView.h"
#import "ColorPickerController.h"
#import "BrushOption.h"
#import "AFPhotoEditorController.h"
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>

#import "OAuthLoginPopupDelegate.h"
#import "TwitterLoginUiFeedback.h"

#define OAUTH_TWITTER_CONSUMER_KEY @"kte5iBlKKrkMp43LTtBfQ"
#define OAUTH_TWITTER_CONSUMER_SECRET @"9vXIy6ZhHiijPTPXS8jjXT2xWsM1oRkQo6OVx3II3c"

@class OAuthTwitter,OAuth,CustomLoginPopup;

@interface DrawingIpadViewController : UIViewController<UIPopoverControllerDelegate,BrushOptionDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,AFPhotoEditorControllerDelegate,AVAudioPlayerDelegate,MFMailComposeViewControllerDelegate,oAuthLoginPopupDelegate, TwitterLoginUiFeedback,ColorPickerDelegate>
{
    SmoothLineView *slv;
    UIPopoverController *ColorPickerPopup,*BrushPicker,*ErashPicker;
    ColorPickerController *colorPicker;
    UILabel *minLabel;
    UIColor *Sele_Color;
    id delegate;
    UIPopoverController *Imagepopover;
    NSString *ImagePath;
    AVAudioPlayer *audioPlayer;
    
    IBOutlet UIButton *Erash,*Clear,*Undo,*Redo,*Savetofile,*Savetophoto,*Color,*Brush,*Share,*New,*Back,*aviry;
    IBOutlet UIToolbar *Tool;
    IBOutlet UIImageView *TempImg;
    IBOutlet UIView *BrushView,*SharingOptionView,*trasferentView,*ToolBarView,*AboutView;
    IBOutlet UISlider *BrushSizeSlider;
    NSMutableArray *SolidColor;
    
    OAuthTwitter *oAuthTwitter;
    OAuth *oAuth;
    CustomLoginPopup *loginPopup;
    
}
@property(nonatomic,retain)UIPopoverController *ColorPickerPopup,*BrushPicker,*ErashPicker;
@property(nonatomic,retain)UIColor *Sele_Color;
@property(assign) id delegate;
@property(nonatomic,retain)NSString *ImagePath;
@property (nonatomic, retain) UIImage *pickedImage;
@property (nonatomic, retain) UIPopoverController *popoverController;
-(IBAction)showColorPicker:(id)sender;
-(IBAction)BrushPicker:(id)sender;
-(IBAction)ErashClick:(id)sender;
-(IBAction)SaveClick:(id)sender;
-(IBAction)ClearClick:(id)sender;
-(IBAction)UndoClick:(id)sender;
-(IBAction)BackClick:(id)sender;
-(IBAction)AviaryClick:(id)sender;
-(IBAction)ShareClick:(id)sender;
-(IBAction)NewClick:(id)sender;
-(IBAction)BrushTypeClick:(id)sender;
-(IBAction)ColorBrushClick:(id)sender;
-(IBAction)InfoClick:(id)sender;
-(IBAction)sliderActionForBrush:(UISlider *)sender;
-(IBAction)twitterAction:(id)sender;
-(IBAction)facebookAction:(id)sender;
-(IBAction)mailAction:(id)sender;
-(IBAction)CloseAboutInfo:(id)sender;
-(IBAction)OpenBrowser:(id)sender;
-(IBAction)Feedbackclick:(id)sender;
-(void) setUndoButtonEnable:(NSNumber*)isEnable;
-(void) setRedoButtonEnable:(NSNumber*)isEnable;
-(void) setClearButtonEnable:(NSNumber*)isEnable;
-(void) setEraserButtonEnable:(NSNumber*)isEnable;
-(void) setSave2AlbumButtonEnable:(NSNumber*)isEnable;
-(void) setShareButtonEnable:(NSNumber*)isEnable;
-(void) setNewButtonEnable:(NSNumber*)isEnable;
-(void) setBrushButtonEnable:(NSNumber*)isEnable;
-(void) setBackButtonEnable:(NSNumber*)isEnable;
-(void) setAviaryButtonEnable:(NSNumber*)isEnable;
-(void) setColorButtonEnable:(NSNumber*)isEnable;
-(void) setInfoButtonEnable:(NSNumber*)isEnable;
-(void) displayPhotoEditorWithImage:(UIImage *)image;
-(void) MessageShow;
-(void) Slideupview;
-(void) Slidedownview;
-(void) SlideupShareview;
-(void) SlidedownShareview;
-(void) SetColorArrayhsv;
-(void) handleOAuthVerifier:(NSString *)oauth_verifier;
-(void)presentLoginWithFlowType;
-(void)didPressPostImage;
-(void)uploadPhotoOnFacebook;
-(void)ClearFloder;
@end
