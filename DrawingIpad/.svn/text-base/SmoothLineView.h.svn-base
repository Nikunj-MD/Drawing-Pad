/**
 
 ClassName:: SmoothLineView
 
 Superclass:: UIView
 
 Class Description:: This class is drawing smooth line on canvas.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 18/09/12.
 
 */
#import <UIKit/UIKit.h>

enum
{
	DRAW					= 0x0000,
	CLEAR					= 0x0001,
	ERASE					= 0x0002,
	UNDO					= 0x0003,
	REDO					= 0x0004,
    RELOAD                  = 0x0005,
};

@interface SmoothLineView : UIView<UIPopoverControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    id delegate;
    
    NSMutableArray *lineArray;
    NSMutableArray *bufferArray;

    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGFloat lineWidth;
    UIColor *lineColor;
    CGFloat lineAlpha;
    
    UIImage *curImage;  
    int drawStep;
    
#if USEUIBezierPath
    UIBezierPath *myPath;
#endif
#if PUSHTOFILE
    int lineIndex;
    int redoIndex;
#endif
    

}
@property (nonatomic, retain) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;
@property (readwrite) CGFloat lineAlpha;
@property(assign) id delegate;

- (void)calculateMinImageArea:(CGPoint)pp1 :(CGPoint)pp2 :(CGPoint)cp;
- (void)redoButtonClicked;
- (void)undoButtonClicked;
- (void)clearButtonClicked;
- (void)eraserButtonClicked;
- (void)save2FileButtonClicked;
- (UIImage *)CaptureImageOnly;
- (void)EditFileButtonClicked;
- (void)save2AlbumButtonClicked;
- (void)loadFromAlbumButtonClicked:(UIImage*)_image;
- (void)setColor:(float)r g:(float)g b:(float)b a:(float)a;
- (void)checkDrawStatus;
- (void)ResetStack;
#if PUSHTOFILE
- (void)writeFilesBG;
#endif
@property (nonatomic,assign)CGFloat hue;
@property (nonatomic,assign)CGFloat saturation;
@property (nonatomic,assign)CGFloat brightness;

@end
