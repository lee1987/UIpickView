//
//  PickerViewLabel.m
//
//  Created by Hongfu lin on 07/08/2012.
//

#import "PickerViewLabel.h"
#import "TECSOLDEBUG.h"

@implementation PickerViewLabel
@synthesize checkmarkImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect {
    rect = CGRectMake(30, 0, 270, 40);
    [super drawTextInRect:rect];
}

-(void)highlightLable {
    checkmarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 24, 19)];
    checkmarkImageView.image = [UIImage imageNamed:@"checkmark.png"];
    
    __block PickerViewLabel *selectedPickViewLabel = self;
    
    void (^completionBlock)(BOOL ) = ^(BOOL num) {
        selectedPickViewLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
    };
    [UIView animateWithDuration:0.5 animations:^{
        self.layer.backgroundColor = [UIColor colorWithRed:76/255.0 green:132/255.0 blue:235/255.0 alpha:1].CGColor;
        [self addSubview:checkmarkImageView];
    } completion:completionBlock];
    selectedPickViewLabel.highlighted = YES;
    selectedPickViewLabel.highlightedTextColor = [UIColor colorWithRed:38/255.0 green:83/255.0 blue:129/255.0 alpha:1];


}

-(void)unHighlightLable {
#ifdef DEBUG_2
    NSLog(@" <<<<<< Function: %s >>>>>>> ",__func__);  
#endif
    self.highlightedTextColor = [UIColor blackColor];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.checkmarkImageView removeFromSuperview];
    self.checkmarkImageView.image = nil;
}

@end
