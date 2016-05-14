//
//  TKTokenCell.h
//  Tapatalk
//
//  Created by graylocus on 16/4/25.
//
//

#import <UIKit/UIKit.h>

#define RGB_COLOR(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA_COLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/100.0]

static const CGFloat TKTokenFontSize = 14.0f;
static const CGFloat TKTokenCellHeight = 40.f;

@class TKTokenCellViewModel;

@interface TKTokenCell : UIControl

- (void)configTokenWithViewModel:(TKTokenCellViewModel *)viewModel;

+ (CGSize)sizeForTokenWithViewModel:(TKTokenCellViewModel *)viewModel freeWidth:(CGFloat)freeWidth;

@end
