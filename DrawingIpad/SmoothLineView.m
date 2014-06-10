/**
 
 ClassName:: SmoothLineView
 
 Superclass:: UIView
 
 Class Description:: This class is drawing smooth line on canvas.
 
 Version:: 1.0
 
 Author:: Nikunj Modi
 
 Created Date:: 18/09/12.
 
 */
#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage-Extensions.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 5.0f
#define DEFAULT_ALPHA 1.0f

@interface SmoothLineView () 

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation SmoothLineView

@synthesize lineAlpha;
@synthesize lineColor;
@synthesize lineWidth;
@synthesize delegate;
@synthesize hue,saturation,brightness;
#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = DEFAULT_WIDTH;
        self.lineColor = DEFAULT_COLOR;
        self.lineAlpha = DEFAULT_ALPHA;
        
        bufferArray=[[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        
#if PUSHTOFILE
        lineIndex = 0;
        redoIndex = 0;
        
        NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/WB"];

        // Check if the directory already exists
        BOOL isDir;        
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:pngPath isDirectory:&isDir];
        if (exists) 
        {
            if (!isDir) 
            {
                NSError *error = nil;
                [[NSFileManager defaultManager]  removeItemAtPath:pngPath error:&error];
                // Directory does not exist so create it
                [[NSFileManager defaultManager] createDirectoryAtPath:pngPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        else
        {
            // Directory does not exist so create it
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/",pngPath]withIntermediateDirectories:YES attributes:nil error:nil];
        }
#endif        
    }
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"0.97" forKey:@"hue"];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"1.0" forKey:@"saturation"];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"1.0" forKey:@"brightness"];
    [[DrawingIpadAppDelegate getGlobalInfo] setValue:@"15" forKey:@"BrushWidth"];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    switch (drawStep) {
        case DRAW:
        {
            int brushwidth = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushWidth"] intValue];
           
            UIColor *color;
            
            if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushOption"] isEqualToString:@"Pencial"])
            {
                  color=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"PatternImage"]]];
            }
            else if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushOption"] isEqualToString:@"Crayon"])
            {
                color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"PatternImage"]]];
            }
            else if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushOption"] isEqualToString:@"Solid"])
            {
                self.hue = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"hue"] floatValue];
                self.saturation = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"saturation"] floatValue];
                self.brightness = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"brightness"] floatValue];
                
                color = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:1.0];
            }
            CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
            CGPoint mid2 = midPoint(currentPoint, previousPoint1);
#if USEUIBezierPath
            [myPath moveToPoint:mid1];
            [myPath addQuadCurveToPoint:mid2 controlPoint:previousPoint1];
            self.lineColor = color;
            [myPath strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
#else
            if (mid1.x !=0 && mid1.y !=0 && mid2.x !=0 && mid2.y)
            {
                self.lineColor = color;
                self.lineWidth = brushwidth;
                self.contentScaleFactor=1.0;
                [curImage drawAtPoint:CGPointMake(0, 0)];
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                [self.layer renderInContext:context];
                CGContextMoveToPoint(context, mid1.x, mid1.y);
                CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
                if(previousPoint1.x == previousPoint2.x && previousPoint1.y == previousPoint2.y && previousPoint1.x == currentPoint.x && previousPoint1.y == currentPoint.y)
                {
                    CGContextSetLineCap(context, kCGLineCapRound);
                }
                else
                {
                    CGContextSetLineCap(context, kCGLineCapRound);
                }
                
                CGContextSetBlendMode(context, kCGBlendModeNormal);
                CGContextSetLineJoin(context, kCGLineJoinRound);
                CGContextSetLineWidth(context, self.lineWidth);
                CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
                //CGContextSetShadowWithColor(context, CGSizeZero, brushwidth, self.lineColor.CGColor);
                
                CGContextSetShouldAntialias(context, YES);
                CGContextSetAllowsAntialiasing(context, YES);
                CGContextSetFlatness(context, 0.1f);
                
                CGContextSetAlpha(context, self.lineAlpha);
                CGContextStrokePath(context);
            }
#endif
            [curImage release];

            
        }
            break;
        case CLEAR:
        {
            CGContextRef context = UIGraphicsGetCurrentContext(); 
            CGContextClearRect(context, rect);
            break;
        }
        case ERASE:
        {
            int brushwidth = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"BrushType"] intValue];
            if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashOption"] isEqualToString:@"True"]) 
            {
                self.hue = 0.000000;
                self.saturation = 0.000000;
                self.brightness = 1.000000;
                brushwidth = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ErashRadius"] intValue];
            }
            else
            {
                self.hue = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"hue"] floatValue];
                self.saturation = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"saturation"] floatValue];
                self.brightness = [[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"brightness"] floatValue];
            }
            UIColor *color = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:self.brightness alpha:1.0];
            self.lineColor = color;
            self.lineWidth = brushwidth;
            CGPoint mid1 = midPoint(previousPoint1, previousPoint2); 
            CGPoint mid2 = midPoint(currentPoint, previousPoint1);
#if USEUIBezierPath
            [myPath moveToPoint:mid1];
            [myPath addQuadCurveToPoint:mid2 controlPoint:previousPoint1];
            [self.lineColor setStroke];
            [myPath strokeWithBlendMode:kCGBlendModeClear alpha:self.lineAlpha];
#else
            [curImage drawAtPoint:CGPointMake(0, 0)];
            CGContextRef context = UIGraphicsGetCurrentContext(); 
            [self.layer renderInContext:context];
            CGContextMoveToPoint(context, mid1.x, mid1.y);
            CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetBlendMode(context, kCGBlendModeClear);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);  
            CGContextSetShouldAntialias(context, YES);  
            CGContextSetAllowsAntialiasing(context, YES); 
            CGContextSetFlatness(context, 0.1f);
            
            CGContextSetAlpha(context, self.lineAlpha);
            CGContextStrokePath(context); 
#endif
            [curImage release];
            
        }
            break;
        case UNDO:
        {
            [curImage drawInRect:self.bounds];   
            [curImage release];
            break;
        }
        case REDO:
        {
            [curImage drawInRect:self.bounds];   
            [curImage release];
            break;
        }
        case RELOAD:
        {
            //http://stackoverflow.com/a/6176608/489594
            if(curImage.size.width>curImage.size.height)
            {
                UIImage *_tmp = curImage;
                curImage = [_tmp imageRotatedByDegrees:90];
            }
            [curImage drawInRect:self.bounds];
            break;
        }
        default:
            break;
    }    
    [super drawRect:rect];
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

#pragma mark Gesture handle
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"DrawerOpen"] isEqualToString:@"True"])
    {
        [delegate performSelectorOnMainThread:@selector(Slidedownview)
                                   withObject:self
                                waitUntilDone:YES];
        return;
    }
    else if([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ShareDrawerOpen"] isEqualToString:@"True"])
    {
        [delegate performSelectorOnMainThread:@selector(SlidedownShareview)
                                   withObject:self
                                waitUntilDone:YES];
        return;
    }
    UITouch *touch = [touches anyObject];
    
#if USEUIBezierPath
    myPath=[[UIBezierPath alloc]init];
    myPath.lineWidth=self.lineWidth;
    myPath.lineCapStyle = kCGLineCapRound;

#endif
    
    previousPoint1 = [touch locationInView:self];
    previousPoint2 = [touch locationInView:self];
    currentPoint = [touch locationInView:self];
    
    [self touchesMoved:touches withEvent:event];
#if  PUSHTOFILE
    redoIndex=0;
#else
    [bufferArray removeAllObjects];
#endif
    [self checkDrawStatus];
    
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch  = [touches anyObject];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = currentPoint;
    currentPoint    = [touch locationInView:self];
    
    if(drawStep != ERASE) 
        drawStep = DRAW;
    [self calculateMinImageArea:previousPoint1 :previousPoint2 :currentPoint];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    [curImage retain];
    UIGraphicsEndImageContext();
#if PUSHTOFILE    
    lineIndex++;
    [self performSelectorInBackground:@selector(writeFilesBG)
                               withObject:nil];
#else    
    NSDictionary *lineInfo = [NSDictionary dictionaryWithObjectsAndKeys:curImage, @"IMAGE",nil];
    [lineArray addObject:lineInfo];
#endif    
                              
    [curImage release];
    
    [self checkDrawStatus];
}
/*!
 @method calculateMinImageArea
 @param1.. It will be previousPoint1.
 @param2.. It will be previousPoint2.
 @param2.. It will be user current touch point.
 @abstract It is used to calculate image min area.
 @discussion It is used to calculate image min area..
 @result User will calculate min for any image.
 */
#pragma mark Private Helper function
- (void) calculateMinImageArea:(CGPoint)pp1 :(CGPoint)pp2 :(CGPoint)cp
{
    // calculate mid point
    CGPoint mid1    = midPoint(pp1, pp2); 
    CGPoint mid2    = midPoint(cp, pp1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, pp1.x, pp1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 1;
    drawBox.origin.y        -= self.lineWidth * 1;
    drawBox.size.width      += self.lineWidth * 2;
    drawBox.size.height     += self.lineWidth * 2;
    
    UIGraphicsBeginImageContext(drawBox.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    [curImage retain];
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
    [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
    
}
/*!
 @method writeFilesBG
 @abstract It is used to write drawing image in local folder.
 @discussion It is used to write drawing image in local folder.
 @result User can save image in local floder.
 */
#if PUSHTOFILE
-(void)writeFilesBG
{
    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/WB/%d.png",lineIndex]];
    NSURL *pathURL= [NSURL fileURLWithPath:pngPath];
    BOOL data = [self addSkipBackupAttributeToItemAtURL:pathURL];
    if(data)
    {
        NSLog(@"Do Not Backup not work..");
    }
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UIImagePNGRepresentation(saveImage) writeToFile:pngPath atomically:YES];
}
#endif

-(void)redrawLine
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
#if PUSHTOFILE
    curImage = [UIImage imageWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/WB/%d.png",lineIndex]]];
    [curImage retain];
#else
    NSDictionary *lineInfo = [lineArray lastObject];
    curImage = (UIImage*)[lineInfo valueForKey:@"IMAGE"];
#endif
    UIGraphicsEndImageContext();
    [self setNeedsDisplayInRect:self.bounds];    
}


#pragma mark Button Handle

-(void)undoButtonClicked
{
    if (![[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"] isEqualToString:@""] && lineIndex == 1)
    {
        UIImage *Img = [UIImage imageWithContentsOfFile:[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"]];
        drawStep = RELOAD;
        curImage = Img;
        [curImage retain];
        [self setNeedsDisplay];
        lineIndex--;
        redoIndex++;
    }
    else
    {
        #if PUSHTOFILE
            lineIndex--;
            redoIndex++;
            drawStep = UNDO;
            [self redrawLine];
        #else
            if([lineArray count]>0){
                NSMutableArray *_line=[lineArray lastObject];
                [bufferArray addObject:[_line copy]];
                [lineArray removeLastObject];
                drawStep = UNDO;
                [self redrawLine];
            }
        #endif

    }
    [self checkDrawStatus];
}

-(void)redoButtonClicked
{
#if PUSHTOFILE
    lineIndex++;
    redoIndex--;
    drawStep = REDO;
    [self redrawLine];
#else
    if([bufferArray count]>0){
        NSMutableArray *_line=[bufferArray lastObject];
        [lineArray addObject:_line];
        [bufferArray removeLastObject];
        drawStep = REDO;
        [self redrawLine];
    }
#endif
    [self checkDrawStatus];
}
-(void)clearButtonClicked
{    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    curImage = UIGraphicsGetImageFromCurrentImageContext();
    [curImage retain];
    UIGraphicsEndImageContext();
    drawStep = CLEAR;
    [self setNeedsDisplayInRect:self.bounds];
#if PUSHTOFILE
    lineIndex = 0;
    redoIndex = 0;
    [lineArray removeAllObjects];
    [bufferArray removeAllObjects];
    //REMOVE ALL FILES
#else
    [lineArray removeAllObjects];
    [bufferArray removeAllObjects];
#endif
    [self checkDrawStatus];
}
- (void)ResetStack
{
    lineIndex = 0;
    redoIndex = 0;
    [lineArray removeAllObjects];
    [bufferArray removeAllObjects];
}
-(void)eraserButtonClicked
{    
    if(drawStep!=ERASE)
    {
        drawStep = ERASE;
    }
    else 
    {
        drawStep = DRAW;
    }
}
/*!
 @method setColor
 @param1.. It will be red color float value.
 @param2.. It will be green color float value.
 @param3.. It will be blue color float value.
 @param4.. It will be alpha flaot value.
 It will be red color float value.
 @abstract It is set line color and alpha.
 @discussion It is set line color and alpha.
 @result User will set line color and alpha depends upon red,blue and green color.
 */
-(void)setColor:(float)r g:(float)g b:(float)b a:(float)a
{
    self.lineColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    self.lineAlpha = a;
}

-(void)save2FileButtonClicked
{
    BOOL error;
    NSString *message;  
    NSString *title;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Screenshot %@.png",dateString]];
    
    
    NSURL *pathURL= [NSURL fileURLWithPath:pngPath];
    BOOL data = [self addSkipBackupAttributeToItemAtURL:pathURL];
    if(data)
    {
          NSLog(@"Do Not Backup not work..");
    }
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    error = [UIImagePNGRepresentation(saveImage) writeToFile:pngPath atomically:YES];
    
    if (!error) {  
        title = NSLocalizedString(@"SaveSuccessTitle", @"");  
        message = NSLocalizedString(@"SaveSuccessMessage", @"");  
    } else {  
        title = NSLocalizedString(@"SaveFailedTitle", @"");  
        message = NSLocalizedString(@"SaveFailMessage", @"");  ;  
    }  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
                                                    message:message
                                                   delegate:nil  
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")  
                                          otherButtonTitles:nil];  
    //[alert show];
    [alert release];  
}
/*!
 @method EditFileButtonClicked
 @abstract It is editing this app drawing.
 @discussion It is editing this app drawing.
 @result User can edit older image.
 */
- (void)EditFileButtonClicked
{
    BOOL error;
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    NSURL *pathURL= [NSURL fileURLWithPath:[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"]];
    BOOL data = [self addSkipBackupAttributeToItemAtURL:pathURL];
    if(data)
    {
        NSLog(@"Do Not Backup not work..");
    }
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    error = [UIImagePNGRepresentation(saveImage) writeToFile:[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"] atomically:YES];
}
/*!
 @method save2AlbumButtonClicked
 @abstract It is store drawing in ipad album.
 @discussion It is store drawing in ipad album.
 @result User can see our app drawing in photo library.
 */
-(void)save2AlbumButtonClicked
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library saveImage:saveImage toAlbum:@"Draw Album" withCompletionBlock:^(NSError *error) {
        NSString *message;  
        NSString *title;
        if (!error) {
            title = NSLocalizedString(@"Message", @"");  
            message = NSLocalizedString(@"Drawing save successfully", @"");  
        }
        else {
            
            title = NSLocalizedString(@"Error", @"");
            message = NSLocalizedString(@"Drawing is not save", @"");
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
                                                        message:message  
                                                       delegate:nil  
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")  
                                              otherButtonTitles:nil];  
        [alert show];  
        [alert release];
        
    }];

}
- (UIImage *)CaptureImageOnly
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return saveImage;
}
/*!
 @method loadFromAlbumButtonClicked
 @param1.. It will be image form album.
 @abstract It is load image from photo album.
 @discussion It is load image from photo album.
 @result User can load image from photo library.
 */
- (void)loadFromAlbumButtonClicked:(UIImage*)_image
{
    if ([[[DrawingIpadAppDelegate getGlobalInfo] valueForKey:@"ImageName"] isEqualToString:@""])
    {
        #if PUSHTOFILE
            lineIndex++;
            [self performSelectorInBackground:@selector(writeFilesBG)
                                   withObject:nil];
        #else
            NSDictionary *lineInfo = [NSDictionary dictionaryWithObjectsAndKeys:curImage, @"IMAGE",nil];
            [lineArray addObject:lineInfo];
        #endif
            
            [self performSelectorInBackground:@selector(writeFilesBG)
                                   withObject:nil];
    }
    drawStep = RELOAD;
    curImage = _image;
    [curImage retain];
    [self setNeedsDisplay];
}

#pragma mark toolbarDelegate Handle
- (void) checkDrawStatus
{
#if PUSHTOFILE
    if(lineIndex > 0)
        
#else
        if([lineArray count]>0)
#endif
        {
            [delegate performSelectorOnMainThread:@selector(setUndoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setClearButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setEraserButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setSave2AlbumButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setShareButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setNewButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            
        }
        else 
        {
            [delegate performSelectorOnMainThread:@selector(setUndoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setClearButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setEraserButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setSave2AlbumButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setShareButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setNewButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
        }
#if PUSHTOFILE
    if(redoIndex > 0)
#else
        if([bufferArray count]>0)
#endif
        {
            [delegate performSelectorOnMainThread:@selector(setRedoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            [delegate performSelectorOnMainThread:@selector(setClearButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
            
        }
        else 
        {
            [delegate performSelectorOnMainThread:@selector(setRedoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
        }

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentScaleFactor=1.0;
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
     if (&NSURLIsExcludedFromBackupKey == nil)
         { // iOS <= 5.0.1
               const char* filePath = [[URL path] fileSystemRepresentation];
               
               const char* attrName = "com.apple.MobileBackup";
               u_int8_t attrValue = 1;
               
               int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
               return result == 0;
             }
     else
         { // iOS >= 5.1
               NSError *error = nil;
               [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
               return error == nil;
             }
}
@end


