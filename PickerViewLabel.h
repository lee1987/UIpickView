//
//  PickerViewLabel.h
//
//  Created by Hongfu lin on 07/08/2012.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PickerViewLabel : UILabel
@property (nonatomic, strong)UIImageView *checkmarkImageView;

-(void)highlightLable ;

-(void)unHighlightLable ;
@end
