//
//  ADVSegmentedControl.h
//
//  Created by Nosov Pavel on 08/03/16.
//

#import "ADVSegmentedControl.h"

static NSInteger kDefaultFontSize = 15;
static NSString *const kDefaultFontName = @"Avenir-Black";

static CGFloat kAnimationDuration = 0.5;
static CGFloat kAnimationDelay = 0.0;
static CGFloat kSpringDamping = 0.6;
static CGFloat kInitialSpringVelocity = 0.8;

@interface ADVSegmentedControl()

@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) UIView *thumbView;

@end

@implementation ADVSegmentedControl

@synthesize items = _items;
@synthesize selectedLabelColor = _selectedLabelColor;
@synthesize unselectedLabelColor = _unselectedLabelColor;
@synthesize thumbColor = _thumbColor;
@synthesize borderColor = _borderColor;
@synthesize font = _font;
@synthesize thumbView = _thumbView;
@synthesize selectedIndex = _selectedIndex;

#pragma mark lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}


#pragma mark getters 

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [[NSMutableArray alloc] init];
    }
    return _labels;
}

- (NSArray *)items {
    if (!_items) {
        _items = [[NSArray alloc] initWithObjects:@"Item 1", @"Item 2",@"Item 3", nil];
    }
    return _items;
}

- (UIColor *)selectedLabelColor {
    if (!_selectedLabelColor) {
        _selectedLabelColor = [UIColor blackColor];
    }
    return _selectedLabelColor;
}

- (UIColor *)unselectedLabelColor {
    if (!_unselectedLabelColor) {
        _unselectedLabelColor = [UIColor whiteColor];
    }
    return _unselectedLabelColor;
}

- (UIColor *)thumbColor {
    if (!_thumbColor) {
        _thumbColor = [UIColor whiteColor];
    }
    return _thumbColor;
}

- (UIColor *)borderColor {
    if (!_borderColor) {
        _borderColor = [UIColor clearColor];
    }
    return _borderColor;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:kDefaultFontSize];
    }
    return _font;
}


- (UIView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIView alloc] init];
    }
    return _thumbView;
}

#pragma mark setters

- (void)setItems:(NSArray *)items {
    if (_items != items)
    {
        _items = items;
        [self setupLabels];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        [self displayNewSelectedIndex];
    }
}


- (void)setSelectedLabelColor:(UIColor *)selectedLabelColor {
    if (_selectedLabelColor != selectedLabelColor)
    {
        _selectedLabelColor = selectedLabelColor;
        [self setSelectedColors];
    }
}

- (void)setUnselectedLabelColor:(UIColor *)unselectedLabelColor {
    if (_unselectedLabelColor != unselectedLabelColor)
    {
        _unselectedLabelColor = unselectedLabelColor;
        [self setSelectedColors];
    }
}

- (void)setThumbColor:(UIColor *)thumbColor {
    if (_thumbColor != thumbColor)
    {
        _thumbColor = thumbColor;
        [self setSelectedColors];
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setFont:(UIFont *)font {
    
    if (_font != font)
    {
        _font = font;
        [self setFont];
    }
}

- (void)setSelectedColors {
    for (UILabel *label in self.labels) {
        label.textColor = self.unselectedLabelColor;
    }
    
    if (self.labels.count > 0) {
        UILabel *label = self.labels[0];
        label.textColor = self.selectedLabelColor;
    }
    
    self.thumbView.backgroundColor = self.thumbColor;
}

- (void)setFont {
    for (UILabel *label in self.labels) {
        label.font = self.font;
    }
}

#pragma mark setups

- (void)setupViews {
    
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    self.layer.borderWidth = 2;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setupLabels];
    
    [self addIndividualItemConstraints:self.labels mainView:self padding:0];
    
    [self insertSubview:self.thumbView atIndex:0];
}

- (void)setupLabels {
    
    for (UILabel *label in self.labels) {
        [label removeFromSuperview];
    }
    
    [self.labels removeAllObjects];
    
    for (int index = 1; index <= self.items.count;index++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        label.text = self.items[index - 1];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:kDefaultFontName size:kDefaultFontSize];
        label.textColor = index == 1 ? self.selectedLabelColor : self.unselectedLabelColor;
        label.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:label];
        [self.labels addObject:label];
    }
    
    [self addIndividualItemConstraints:self.labels mainView:self padding:0];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect selectFrame = self.bounds;
    CGFloat newWidth = CGRectGetWidth(selectFrame) / self.items.count;
    selectFrame.size.width = newWidth;
    self.thumbView.frame = selectFrame;
    self.thumbView.backgroundColor = self.thumbColor;
    self.thumbView.layer.cornerRadius = self.thumbView.frame.size.height / 2.0;
    
    [self displayNewSelectedIndex];
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint location = [touch locationInView:self];
    
    NSNumber *calculatedIndex;
    
    for (int index = 0; index < self.labels.count; index++) {
        
        UILabel *label = self.labels[index];
        
        if (CGRectContainsPoint(label.frame, location)) {
            calculatedIndex = @(index);
        }
    }
    
    
    
    if (calculatedIndex != nil) {
        self.selectedIndex = calculatedIndex.integerValue;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    return false;
}
            
            
- (void)displayNewSelectedIndex {
    
    for (int index = 0; index < self.labels.count; index++) {
        
        UILabel *label = self.labels[index];
        label.textColor = self.unselectedLabelColor;
    
    }

    UILabel *label = self.labels[self.selectedIndex];
    label.textColor = self.selectedLabelColor;
    
    [UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay usingSpringWithDamping:kSpringDamping initialSpringVelocity:kInitialSpringVelocity options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.thumbView.frame = label.frame;
        
    } completion:nil];

}
            
- (void)addIndividualItemConstraints:(NSArray *)items mainView:(UIView *)mainView padding:(CGFloat)padding {
    
//    NSArray *constraints = mainView.constraints;
    
    for (int index = 0; index < items.count; index++) {
        
        UIView *button = items[index];
    
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        
        
        NSLayoutConstraint *rightConstraint;
        
        if (index == items.count - 1) {
            
            rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-padding];
            
        } else {
            
            UIView *nextButton = items[index+1];
            
            rightConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:nextButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-padding];
        }
        
        
        NSLayoutConstraint *leftConstraint;
        
        if (index == 0) {
            
            leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:mainView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:padding];
        
            
        } else {
            
            UIView *prevButton = items[index-1];
            
            leftConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:prevButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:padding];
            
            UIView *firstItem = items[0];
            
            NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:firstItem attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
       
            
            [mainView addConstraint:widthConstraint];
        }
        
        [mainView addConstraints:@[topConstraint, bottomConstraint, rightConstraint, leftConstraint]];
    }
}


@end
