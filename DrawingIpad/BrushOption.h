/**
 
 ClassName:: BrushOption
 
 Superclass:: UIViewController
 
 Class Description:: This class is given different brush options for drawing.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 18/09/12.
 
 Modified Date:: 20/09/12.
 */

#import <UIKit/UIKit.h>
@protocol BrushOptionDelegate <NSObject>
- (void)ClosePopover;
@end
@interface BrushOption : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *Brushoption;
    NSMutableArray *BrushArray;
}
@property (nonatomic, readwrite, assign) id<BrushOptionDelegate> delegate;
@end
