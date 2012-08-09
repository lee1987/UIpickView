#import "AbstractActionSheetPicker.h"
#import "PickViewDatasource.h"

@protocol UpdateSelection
- (void)updateTitleByIndex:(NSUInteger)index withTarget: (PickViewReturnFlag)target;
@end

@class PopView;
typedef void(^ActionStringDoneBlock)(PopView *picker, NSInteger selectedIndex, id selectedValue, PickViewReturnFlag flag);
typedef void(^ActionStringCancelBlock)(PopView *picker);

@interface PopView : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>
/* Create and display an action sheet picker. The returned picker is autoreleased. 
 "origin" must not be empty.  It can be either an originating container view or a UIBarButtonItem to use with a popover arrow.
 "target" must not be empty.  It should respond to "onSuccess" actions.
 "rows" is an array of strings to use for the picker's available selection choices. 
 "initialSelection" is used to establish the initially selected row;
 */
+ (id)showPickerWithTitle:(NSString *)title 
                     rows:(NSArray *)data 
         initialSelection:(NSInteger)index 
                   target:(id)target 
            successAction:(SEL)successAction 
             cancelAction:(SEL)cancelActionOrNil 
                   origin:(id)origin  
                 withFlag: (PickViewReturnFlag)flag ;

// Create an action sheet picker, but don't display until a subsequent call to "showActionPicker".  Receiver must release the picker when ready. */
- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;



+ (id)showPickerWithTitle:(NSString *)title 
                     rows:(NSArray *)strings 
         initialSelection:(NSInteger)index 
                doneBlock:(ActionStringDoneBlock)doneBlock 
              cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil 
                   origin:(id)origin 
                 withFlag: (PickViewReturnFlag)flag ;

- (id)initWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin withFlag: (PickViewReturnFlag)flag ;

-(void)setDefaultSelection ;

@property (nonatomic, copy) ActionStringDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionStringCancelBlock onActionSheetCancel;
@property (nonatomic, assign) id<UpdateSelection> delegate;

@end