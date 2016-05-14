//
//  TKTokenFieldInternalView.h
//  Tapatalk
//
//  Created by graylocus on 16/5/9.
//  Copyright (c) 2015 Quoord Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKTokenFieldInternalView, TKTokenCell;

@protocol TKTokenFieldInternalViewDelegate <NSObject>
// text field action
- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView didRemoveTokenAtIndex:(NSUInteger)index;
- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView didReturnWithText:(NSString *)text;
- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView didTextChanged:(NSString *)text;
- (void)tokenFieldInternalViewDidBeginEditing:(TKTokenFieldInternalView *)internalView;
- (BOOL)tokenFieldInternalViewShouldEndEditing:(TKTokenFieldInternalView *)internalView;
- (void)tokenFieldInternalViewDidEndEditing:(TKTokenFieldInternalView *)internalView;
- (void)tokenFieldInternalViewCancelSearch:(TKTokenFieldInternalView *)internalView;
// frame related
- (void)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView updateFrame:(CGRect)frame;
- (CGFloat)tokenMarginInTokenFieldInternalView:(TKTokenFieldInternalView *)internalView;
@end

@protocol TKTokenFieldInternalViewDataSource <NSObject>
@required
- (CGFloat)rowHeightOfTokenFieldInternalView:(TKTokenFieldInternalView *)internalView;
- (NSInteger)numberOfTokensInTokenFieldInternalView:(TKTokenFieldInternalView *)internalView;
- (TKTokenCell *)tokenFieldInternalView:(TKTokenFieldInternalView *)internalView tokenCellAtIndex:(NSInteger)index;
@end


@interface TKTokenFieldInternalView : UIView

@property (nonatomic, weak) id<TKTokenFieldInternalViewDelegate> delegate;
@property (nonatomic, weak) id<TKTokenFieldInternalViewDataSource> dataSource;
@property (nonatomic, strong, readonly) UITextField *textField;

- (instancetype)initWithFrame:(CGRect)frame;

- (NSInteger)numberOfToken;
- (void)reloadData;

@end
