//
//  ADVSegmentedControl.h
//
//  Created by Nosov Pavel on 08/03/16.
//

#import <UIKit/UIKit.h>

@interface ADVSegmentedControl : UIControl

@property (strong, nonatomic) UIColor *selectedLabelColor;
@property (strong, nonatomic) UIColor *unselectedLabelColor;
@property (strong, nonatomic) UIColor *thumbColor;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIFont *font;


@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
