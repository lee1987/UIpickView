#import "PopView.h"

@interface PopView()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation PopView
@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize onActionSheetDone = _onActionSheetDone;
@synthesize onActionSheetCancel = _onActionSheetCancel;
@synthesize delegate;

+ (id)showPickerWithTitle:(NSString *)title 
                     rows:(NSArray *)strings 
         initialSelection:(NSInteger)index 
                doneBlock:(ActionStringDoneBlock)doneBlock 
              cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil 
                   origin:(id)origin 
                 withFlag: (PickViewReturnFlag)flag {
    PopView * picker = [[PopView alloc] initWithTitle:title rows:strings initialSelection:index doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin withFlag: flag];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin withFlag: (PickViewReturnFlag)flag {
    self = [self initWithTitle:title rows:strings initialSelection:index target:nil successAction:nil cancelAction:nil origin:origin withFlag: flag];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (id)showPickerWithTitle:(NSString *)title 
                     rows:(NSArray *)data 
         initialSelection:(NSInteger)index 
                   target:(id)target 
            successAction:(SEL)successAction 
             cancelAction:(SEL)cancelActionOrNil 
                   origin:(id)origin  
                 withFlag: (PickViewReturnFlag)flag {
    PopView *picker = [[PopView alloc] initWithTitle:title rows:data initialSelection:index target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin withFlag: flag];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title rows:(NSArray *)data initialSelection:(NSInteger)index target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin withFlag: (PickViewReturnFlag)flag {
    self = [self initWithTarget:target successAction:successAction cancelAction:cancelActionOrNil origin:origin withFlag: flag];
    if (self) {
        self.data = data;
        self.selectedIndex = index;
        self.title = title;
    }
    return self;
}

- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    stringPicker.showsSelectionIndicator = NO;
    [stringPicker selectRow:self.selectedIndex inComponent:0 animated:NO];
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    [self setDefaultSelection];
    return stringPicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {    
    if (self.onActionSheetDone) {
        _onActionSheetDone(self, self.selectedIndex, [self.data objectAtIndex:self.selectedIndex], self.flag);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
        [target performSelector:successAction withObject:[NSNumber numberWithInt:self.selectedIndex] withObject:origin];
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (char *)successAction);
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction])
        [target performSelector:cancelAction withObject:origin];
}

-(void)setDefaultSelection {
    PickerViewLabel *selected = (PickerViewLabel*)[(UIPickerView *)self.pickerView viewForRow:self.selectedIndex forComponent:0];
    [selected highlightLable];
    [self.allSelectedIndex addObject:selected];
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    for (PickerViewLabel *obj in self.allSelectedIndex) {
        [obj unHighlightLable];
    }
    [self.allSelectedIndex removeAllObjects];
    
    [delegate updateTitleByIndex:row withTarget:self.flag];

    self.selectedIndex = row;
    PickerViewLabel *selected = (PickerViewLabel*)[pickerView viewForRow:row forComponent:component];
    [selected highlightLable];
    [self.allSelectedIndex addObject:selected];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.data objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width - 30;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
#ifdef DEBUG_2
    NSLog(@" <<<<<< Function: %s>>>>>>> %d %d %d view: %@",__func__, row, index, component, view);  
#endif
    
    PickerViewLabel *pickerRowLabel = (PickerViewLabel *)view;
    
    if (view == nil) {
        CGRect frame = CGRectMake(30.0, 0.0, 280, 44);
        pickerRowLabel = [[PickerViewLabel alloc] initWithFrame:frame];
        // Rule 2: background color is clear. The view is positioned over
        //         the UIPickerView chrome.
        pickerRowLabel.backgroundColor = [UIColor clearColor];
        // Rule 3: view must capture all touches otherwise the cell will highlight,
        //         because the picker view uses a UITableView in its implementation.
        pickerRowLabel.userInteractionEnabled = YES;
    } else {
        [pickerRowLabel unHighlightLable];
    }
    
    
    if (row <= [self.data count]) {
        pickerRowLabel.text = [self.data objectAtIndex:row];  
    }
    UIFont *font = [ UIFont boldSystemFontOfSize:18];
    
    
    if(row == 0) {
        font = [ UIFont boldSystemFontOfSize:12];
        
    }
    pickerRowLabel.font = font;
    
    return pickerRowLabel;
    
}


#pragma mark - Block setters

// NOTE: Sometimes see crashes when relying on just the copy property. Using Block_copy ensures correct behavior

- (void)setOnActionSheetDone:(ActionStringDoneBlock)onActionSheetDone {
    if (_onActionSheetDone) {
        _onActionSheetDone = nil;
    }
    _onActionSheetDone = onActionSheetDone;
}

- (void)setOnActionSheetCancel:(ActionStringCancelBlock)onActionSheetCancel {
    if (_onActionSheetCancel) {
        _onActionSheetCancel = nil;
    }
    _onActionSheetCancel = onActionSheetCancel;
}

@end