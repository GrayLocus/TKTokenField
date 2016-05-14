//
//  TKTokenFieldInternalView.m
//  Tapatalk
//
//  Created by graylocus on 16/5/9.
//
//

#import <Foundation/Foundation.h>
#import "TKTokenFieldInternalView.h"
#import "TKTokenCell.h"


#define TextFieldMinWidth 30.f
#define TextFieldDefaultWidth 70.f
#define MoreButtonDefaultWidth 30.f

static NSString *const ZeroWidthSpace = @"\u200B";

#pragma mark - TKTokenTextField
@interface TKTokenTextField : UITextField

@end

@implementation TKTokenTextField
- (void)setText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        TKTokenFieldInternalView *tokenField;
        UIView *view = self.superview;
        while (view) {
            if ([view isKindOfClass:[TKTokenFieldInternalView class]]) {
                tokenField = (TKTokenFieldInternalView *)view;
                break;
            }
            view = view.superview;
        }
        if (tokenField.numberOfToken > 0) {
            text = ZeroWidthSpace;
        }
    }
    [super setText:text];
}

- (NSString *)text {
    return [super.text stringByReplacingOccurrencesOfString:ZeroWidthSpace withString:@""];
}

- (NSString *)rawText {
    return super.text;
}

@end

@interface TKTokenFieldInternalView () <UITextFieldDelegate>
@property (nonatomic, strong) NSString *tempTextFieldText;
@property (nonatomic, strong) NSMutableArray *tokens;
@property (nonatomic, strong) TKTokenCell *selectedToken;
@end

@implementation TKTokenFieldInternalView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _textField = [[TKTokenTextField alloc] initWithFrame:CGRectZero];
    self.textField.placeholder = @"To";
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.opaque = NO;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.font = [UIFont systemFontOfSize:TKTokenFontSize];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSEnumerator *enumerator = [self.tokens objectEnumerator];
    [self enumerateViewFrameWithBlock:^(CGRect frame) {
        UIView *view = [enumerator nextObject];
        view.frame = frame;
    }];
}

- (CGSize)intrinsicContentSize {
    if (self.tokens.count == 0) {
        return CGSizeZero;
    }
    
    __block CGRect rect = CGRectNull;
    
    [self enumerateViewFrameWithBlock:^(CGRect frame) {
        rect = CGRectUnion(rect, frame);
    }];
    return rect.size;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self selectToken:nil];
}

#pragma mark - Public Methods
- (NSInteger)numberOfToken {
    // count out textField
    NSInteger count = self.tokens.count - 1;
    return count;
}

- (void)reloadData {

    // clear
    for (UIView *view in self.tokens) {
        [view removeFromSuperview];
    }
    [self.tokens removeAllObjects];
    
    if (self.dataSource) {
        NSUInteger count = [self.dataSource numberOfTokensInTokenFieldInternalView:self];
        for (int i = 0 ; i < count ; i++) {
            TKTokenCell *cell = [self.dataSource tokenFieldInternalView:self tokenCellAtIndex:i];
            cell.autoresizingMask = UIViewAutoresizingNone;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//            [cell addGestureRecognizer:tap];
//            [cell addTarget:self action:@selector(selectToken:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:cell];
            [self.tokens addObject:cell];
        }
    }
    
    [self.tokens addObject:self.textField];
    [self addSubview:self.textField];
    self.textField.frame = CGRectMake(0, 0, TextFieldDefaultWidth, [self.dataSource rowHeightOfTokenFieldInternalView:self]);
    [self.textField setText:@""];
    
    [self invalidateIntrinsicContentSize];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(TKTokenTextField *)textField {
    self.tempTextFieldText = [textField rawText];
    
    if ([self.delegate respondsToSelector:@selector(tokenFieldInternalViewDidBeginEditing:)]) {
        [self.delegate tokenFieldInternalViewDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(TKTokenTextField *)textField {
    if ([self.delegate respondsToSelector:@selector(tokenFieldInternalViewShouldEndEditing:)]) {
        return [self.delegate tokenFieldInternalViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(TKTokenTextField *)textField {
    if ([self.delegate respondsToSelector:@selector(tokenFieldInternalViewDidEndEditing:)]) {
        [self.delegate tokenFieldInternalViewDidEndEditing:self];
    }
}

- (void)textFieldDidTextChanged:(TKTokenTextField *)textField {
    if ([[textField rawText] isEqualToString:@""]) {
        
        if ([self.tempTextFieldText isEqualToString:ZeroWidthSpace]) {
            if (self.tokens.count > 1) {
                NSUInteger removeIndex = self.tokens.count - 2;
                [self.tokens[removeIndex] removeFromSuperview];
                [self.tokens removeObjectAtIndex:removeIndex];
                
                [self.textField setText:@""];
                
                if ([self.delegate respondsToSelector:@selector(tokenFieldInternalView:didRemoveTokenAtIndex:)]) {
                    [self.delegate tokenFieldInternalView:self didRemoveTokenAtIndex:removeIndex];
                }
            }
        }
    }
    
    self.tempTextFieldText = [textField rawText];
    
    if (textField.text.length>0) {
        if ([self.delegate respondsToSelector:@selector(tokenFieldInternalView:didTextChanged:)]) {
            [self.delegate tokenFieldInternalView:self didTextChanged:textField.text];
        }
    }
    else {
        // cancel search
        if ([self.delegate respondsToSelector:@selector(tokenFieldInternalViewCancelSearch:)]) {
            [self.delegate tokenFieldInternalViewCancelSearch:self];
        }
    }
    [self invalidateIntrinsicContentSize];
}

- (BOOL)textFieldShouldReturn:(TKTokenTextField *)textField {
    if ([self.delegate respondsToSelector:@selector(tokenFieldInternalView:didReturnWithText:)]) {
        [self.delegate tokenFieldInternalView:self didReturnWithText:textField.text];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    TKTokenTextField *tkTextField = (TKTokenTextField *)textField;
    if (string.length == 0 && [[tkTextField rawText] isEqualToString:ZeroWidthSpace]) {
        [self modifySelectedToken];
        return NO;
    }
    else if (textField.hidden) {
        return NO;
    }
    return YES;
}


#pragma mark - Private Methods
- (void)enumerateViewFrameWithBlock:(void (^)(CGRect frame))block {
    CGFloat x = 0, y = 0;
    CGFloat margin = 0;
    CGFloat lineHeight = [self.dataSource rowHeightOfTokenFieldInternalView:self];
    
    if ([self.delegate respondsToSelector:@selector(tokenMarginInTokenFieldInternalView:)]) {
        margin = [self.delegate tokenMarginInTokenFieldInternalView:self];
    }
    
    for (TKTokenCell *token in self.tokens) {
        CGFloat tokenWidth = MIN(CGRectGetWidth(self.bounds), CGRectGetWidth(token.frame));
        CGFloat maxWidth = MAX(CGRectGetWidth(self.bounds), CGRectGetWidth(token.frame));
        
        if ([token isKindOfClass:[TKTokenTextField class]]) {
            TKTokenTextField *textField = (TKTokenTextField *)token;
            CGSize size = [textField sizeThatFits:(CGSize){CGRectGetWidth(self.bounds), lineHeight}];
            size.height = lineHeight;
            if (size.width > CGRectGetWidth(self.bounds)) {
                size.width = CGRectGetWidth(self.bounds);
            }
            
            CGFloat freeWidth = self.frame.size.width - x;
            if (size.width < freeWidth) {
                CGSize tokenSize = CGSizeMake(freeWidth, lineHeight);
                token.frame = (CGRect){{x, y}, tokenSize};
                tokenWidth = freeWidth;
            }
            else {
                // change line
                y += lineHeight;
                x = 0;
                size.width = maxWidth;
                token.frame = (CGRect){{x, y}, size};
                tokenWidth = size.width;
            }
        }
        else {
            if (x + tokenWidth > maxWidth) { // beyond boundary
                y += lineHeight;
                x = 0;
            }
        }
        
        block((CGRect){x, y, tokenWidth, token.frame.size.height});
        x += tokenWidth + margin;
    }
}


- (void)modifySelectedToken {
    TKTokenCell *token = self.selectedToken;
    if (token == nil) {
        NSInteger lastTokenIndex = self.tokens.count-2;
        token = [self.tokens objectAtIndex:lastTokenIndex];
        // Note: set selected token
        self.selectedToken = token;
    }
    [self modifyToken:token];
}

- (void)modifyToken:(TKTokenCell *)token {
    if (token != nil) {
        if (token == self.selectedToken) {
            [self removeToken:token];
        }
        else {
            [self selectToken:token];
        }
        [self setNeedsLayout];
    }
}

- (void)removeToken:(TKTokenCell *)token {
    self.textField.hidden = NO;
    self.selectedToken = nil;
    
    if ([self.delegate respondsToSelector:@selector(tokenFieldInternalView:didRemoveTokenAtIndex:)]) {
        [self.delegate tokenFieldInternalView:self didRemoveTokenAtIndex:[self indexOfToken:token]];
    }
    
    [token removeFromSuperview];
    [self.tokens removeObject:token];
    
    if (self.numberOfToken == 0) {
        [self.textField setText:@""];
    }
    
    [self setNeedsLayout];
}

- (NSInteger)indexOfToken:(TKTokenCell *)token {
    for (int i=0; i<self.tokens.count; ++i) {
        if (token == self.tokens[i]) {
            return i;
        }
    }
    return -1;
}


- (void)tapGesture:(UIGestureRecognizer *)gesture {
    if ([gesture.view isKindOfClass:[TKTokenCell class]]) {
        [self selectToken:(TKTokenCell *)gesture.view];
    }
}


- (void)selectToken:(TKTokenCell *)token {
    @synchronized (self) {
        if (token != nil) {
            self.textField.hidden = YES;
            [self.textField becomeFirstResponder];
        }
        else {
            self.textField.hidden = NO;
            [self.textField becomeFirstResponder];
        }
        self.selectedToken = token;
        for (TKTokenCell *cell in self.tokens) {
            if ([cell isKindOfClass:[TKTokenCell class]]) {
                cell.selected = (cell == token);
                [cell setNeedsDisplay];
            }
        }
    }
}

#pragma mark - Getter & Setter
- (NSMutableArray *)tokens {
    if (!_tokens) {
        _tokens = [NSMutableArray array];
    }
    return _tokens;
}
@end