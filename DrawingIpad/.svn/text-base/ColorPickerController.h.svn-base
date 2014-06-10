/**
 
 ClassName:: ColorPickerController
 
 Superclass:: UIViewController
 
 Class Description:: This class is for color picker controller.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 17/09/12.
 
 Modified Date:: 17/09/12.
 
 */

#import <UIKit/UIKit.h>
#import "GradientView.h"

@class ColorPickerController;

@protocol ColorPickerDelegate <NSObject>

- (void)colorPickerSaved:(ColorPickerController *)controller;
- (void)colorPickerCancelled:(ColorPickerController *)controller;

@end

typedef struct {
    int hueValue;
    int saturationValue;
    int brightnessValue;
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
} HsvColor;

typedef struct {
    int redValue;
    int greenValue;
    int blueValue;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} RgbColor;

@interface ColorPickerController : UIViewController 
                                  <UITextFieldDelegate>
{
    
@private
    UIColor *_selectedColor;
    UIView *_colorView;
    UIImageView *_hueSaturationView;
    GradientView *_brightnessView;
    UIImageView *_horizontalSelector;
    UIImageView *_crosshairSelector;
    UITextField *_hueField;
    UITextField *_saturationField;
    UITextField *_brightnessField;
    UITextField *_redField;
    UITextField *_greenField;
    UITextField *_blueField;
    UITextField *_hexField;
    HsvColor _hsvColor;
    id<ColorPickerDelegate> _delegate;
    UITextField *_entryField;
    UIImageView *_movingView;
    NSCharacterSet *_hexadecimalCharacters;
    NSCharacterSet *_decimalCharacters;
    
}

+ (HsvColor)hsvColorFromColor:(UIColor *)color;
+ (RgbColor)rgbColorFromColor:(UIColor *)color;
+ (NSString *)hexValueFromColor:(UIColor *)color;
+ (UIColor *)colorFromHexValue:(NSString *)hexValue;
+ (BOOL)isValidHexValue:(NSString *)hexValue;
@property (nonatomic, readwrite, retain) UIColor *selectedColor;
@property (nonatomic, readwrite, assign) id<ColorPickerDelegate> delegate;

- (id)initWithColor:(UIColor *)color andTitle:(NSString *)title;
- (void)SetColor;
@end
