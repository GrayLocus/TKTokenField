//
//  TKTokenField.m
//  Tapatalk
//
//  Created by graylocus on 16/4/25.
//
//

#import <Foundation/Foundation.h>
#import "TKTokenField.h"
#import "TKTokenCell.h"
#import "TKTokenFieldInternalView.h"
#import "Masonry.h"

#define MoreButtonDefaultWidth 30.f

#pragma mark - TKTokenField

@interface TKTokenField () <UITextFieldDelegate, TKTokenFieldInternalViewDelegate, TKTokenFieldInternalViewDataSource>

@property (nonatomic, assign) TKTokenFieldStyle style;
@property (nonatomic, assign) TKTokenFieldOptions options;

// UI components
@property (nonatomic, strong) TKTokenFieldInternalView *internalView;
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation TKTokenField
- (instancetype)initWithFrame:(CGRect)frame style:(TKTokenFieldStyle)style options:(TKTokenFieldOptions)options{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        _options = options;
        [self initializeSubviews];
    }
    return self;
}

- (void)initializeSubviews {
    self.opaque = NO;
    self.backgroundColor = [UIColor whiteColor];
    _internalView = [[TKTokenFieldInternalView alloc] initWithFrame:CGRectZero];
    _internalView.delegate = self;
    _internalView.dataSource = self;
    [self addSubview:self.internalView];
    
    id left = self.mas_leading;
    id right = self.mas_trailing;
    
    if (self.options & TKTokenField_MoreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.moreButton setImage:[UIImage imageNamed:@"ParticipantAddIcon"] forState:UIControlStateNormal];
        self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.moreButton addTarget:self action:@selector(addMoreContact:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).with.offset(10.f);
            make.top.equalTo(self).with.offset(5);
            make.width.equalTo(@(MoreButtonDefaultWidth));
            make.height.equalTo(@(MoreButtonDefaultWidth));
        }];
        right = self.moreButton.mas_leading;
    }
    
    [self.internalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(left);
        make.trailing.equalTo(right);
        make.bottom.equalTo(self);
    }];
}

- (BOOL)becomeFirstResponder {
    [self.internalView.textField becomeFirstResponder];
    return [super becomeFirstResponder];
}

#pragma mark - Public Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.internalView layoutSubviews];
}

- (CGSize)intrinsicContentSize {
    CGSize internalViewSize = self.internalView.intrinsicContentSize;
    CGRect rect = CGRectMake(0, 0, internalViewSize.width, internalViewSize.height);
    
    if (self.moreButton) {
        CGRect buttonFrame = self.moreButton.frame;
        rect = CGRectUnion(rect, buttonFrame);
    }
    
    if ([self.delegate respondsToSelector:@selector(tokenField:updateFrame:)]) {
        [self.delegate tokenField:self updateFrame:rect];
    }
    return rect.size;
}

- (NSInteger)numberOfToken {
    return self.internalView.numberOfToken;
}

- (void)reloadData {
    [self.internalView reloadData];
    
    [self invalidateIntrinsicContentSize];
    [self.internalView.textField becomeFirstResponder];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedString {
    self.internalView.textField.attributedPlaceholder = attributedString;
}

#pragma mark - TKTokenFieldInternalViewDelegate
- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView didRemoveTokenAtIndex:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(tokenField:didRemoveTokenAtIndex:)]) {
        [self.delegate tokenField:self didRemoveTokenAtIndex:index];
    }
    [self invalidateIntrinsicContentSize];
}

- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView didReturnWithText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(tokenField:didReturnWithText:)]) {
        [self.delegate tokenField:self didReturnWithText:text];
    }
}

- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView didTextChanged:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(tokenField:didTextChanged:)]) {
        [self.delegate tokenField:self didTextChanged:text];
    }
    [self invalidateIntrinsicContentSize];
}

- (void)tokenFieldInternalViewDidBeginEditing:(TKTokenFieldInternalView *)internalView {
    if ([self.delegate respondsToSelector:@selector(tokenFieldDidBeginEditing:)]) {
        [self.delegate tokenFieldDidBeginEditing:self];
    }
}

- (BOOL)tokenFieldInternalViewShouldEndEditing:(TKTokenFieldInternalView *)internalView {
    return YES;
}

- (void)tokenFieldInternalViewDidEndEditing:(TKTokenFieldInternalView *)internalView {
    if ([self.delegate respondsToSelector:@selector(tokenFieldDidEndEditing:)]) {
        [self.delegate tokenFieldDidEndEditing:self];
    }
}

- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView updateFrame:(CGRect)frame {
    if ([self.delegate respondsToSelector:@selector(tokenField:updateFrame:)]) {
        [self.delegate tokenField:self updateFrame:frame];
    }
}

- (CGFloat)tokenMarginInTokenFieldInternalView:(TKTokenFieldInternalView *)internalView {
    if ([self.delegate respondsToSelector:@selector(tokenMarginInTokenInField:)]) {
        return [self.delegate tokenMarginInTokenInField:self];
    }
    return 0.f;
}

- (void)tokenFieldInternalViewCancelSearch:(TKTokenFieldInternalView *)internalView {
    if ([self.delegate respondsToSelector:@selector(tokenFieldCancelSearch:)]) {
        return [self.delegate tokenFieldCancelSearch:self];
    }
}

#pragma mark - TKTokenFieldInternalViewDataSource
- (CGFloat)rowHeightOfTokenFieldInternalView:(TKTokenFieldInternalView *)internalView {
    if ([self.dataSource respondsToSelector:@selector(rowHeightOfTokenField:)]) {
        return [self.dataSource rowHeightOfTokenField:self];
    }
    return 0.f;
}

- (NSInteger)numberOfTokensInTokenFieldInternalView:(TKTokenFieldInternalView *)internalView {
    if ([self.dataSource respondsToSelector:@selector(numberOfTokensInTokenField:)]) {
        return [self.dataSource numberOfTokensInTokenField:self];
    }
    return 0;
}

- (TKTokenCell *)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView tokenCellAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(tokenField:tokenCellAtIndex:)]) {
        return [self.dataSource tokenField:self tokenCellAtIndex:index];
    }
    return [[TKTokenCell alloc] initWithFrame:CGRectZero];
}

#pragma mark - Private Methods
- (void)addMoreContact:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tokenField:tapMoreButton:)]) {
        [self.delegate tokenField:self tapMoreButton:sender];
    }
}

@end

