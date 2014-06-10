/**
 
 ClassName:: GradientView
 
 Superclass:: UIView
 
 Class Description:: This class is GradientView it is use in color picker controller.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 17/09/12.
 
 Modified Date:: 17/09/12.
*/
#import <UIKit/UIKit.h>

@interface GradientView : UIView {
    
@private
    CGGradientRef _gradient;
    NSArray *_colors;
        
}

@property (nonatomic, readwrite, copy) NSArray *colors;

@end
