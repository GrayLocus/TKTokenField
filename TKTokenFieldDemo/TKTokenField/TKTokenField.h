//
//  TKTokenField.h
//  Tapatalk
//
//  Created by graylocus on 16/4/25.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TKTokenFieldStyle) {
    TKTokenFieldStyleDefault = 0,
};

typedef NS_OPTIONS(NSUInteger, TKTokenFieldOptions) {
    TKTokenField_None = 0<<0,
    TKTokenField_MoreButton = 1<<0,
};

@class TKTokenField, TKTokenCell;

@protocol TKTokenFieldDelegate <NSObject>
// more button action
- (void)tokenField:(TKTokenField *)tokenField tapMoreButton:(UIButton *)button;

// text field action
- (void)tokenField:(TKTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index;
- (void)tokenField:(TKTokenField *)tokenField didReturnWithText:(NSString *)text;
- (void)tokenField:(TKTokenField *)tokenField didTextChanged:(NSString *)text;
- (void)tokenFieldDidBeginEditing:(TKTokenField *)tokenField;
- (BOOL)tokenFieldShouldEndEditing:(TKTokenField *)textField;
- (void)tokenFieldDidEndEditing:(TKTokenField *)tokenField;
- (void)tokenFieldCancelSearch:(TKTokenField *)tokenField;

- (void)tokenField:(TKTokenField *)tokenField updateFrame:(CGRect)frame;
- (CGFloat)tokenMarginInTokenInField:(TKTokenField *)tokenField;
@end

@protocol TKTokenFieldDataSource <NSObject>
@required
- (CGFloat)rowHeightOfTokenField:(TKTokenField *)tokenField;
- (NSInteger)numberOfTokensInTokenField:(TKTokenField *)tokenField;
- (TKTokenCell *)tokenField:(TKTokenField *)tokenField tokenCellAtIndex:(NSInteger)index;

@end

@interface TKTokenField : UIControl
@property (nonatomic, weak) id<TKTokenFieldDelegate> delegate;
@property (nonatomic, weak) id<TKTokenFieldDataSource> dataSource;
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;

- (instancetype)initWithFrame:(CGRect)frame style:(TKTokenFieldStyle)style options:(TKTokenFieldOptions)options;
- (NSInteger)numberOfToken;
- (void)reloadData;
@end