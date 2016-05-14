//
//  TKTokenCell.m
//  Tapatalk
//
//  Created by graylocus on 16/4/25.
//
//

#import <Foundation/Foundation.h>
#import "TKTokenCell.h"
#import "TKTokenCellViewModel.h"
#import "Masonry.h"

static const CGFloat AvatarWidth = 32.f;
static const CGFloat LabelMargin = AvatarWidth/2;
static const CGFloat Padding_Of_AvatarAndName = 5.f;

@interface TKTokenCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation TKTokenCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.userInteractionEnabled = YES;
        [self addSubview:self.containerView];

        CGFloat radius = AvatarWidth/2;
        self.imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, AvatarWidth, AvatarWidth)];
        self.imageView.layer.cornerRadius = radius;
        self.imageView.userInteractionEnabled = YES;
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.label.font = [UIFont systemFontOfSize:TKTokenFontSize];

        self.containerView.layer.cornerRadius = radius;
        self.containerView.backgroundColor = RGB_COLOR(240, 240, 240);
        self.containerView.clipsToBounds = YES;
        self.containerView.userInteractionEnabled = YES;
        [self.containerView addSubview:self.imageView];
        [self.containerView addSubview:self.label];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.containerView);
            make.centerY.equalTo(self.containerView);
            make.height.equalTo(@(AvatarWidth));
            make.width.equalTo(@(AvatarWidth));
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView);
            make.leading.equalTo(self.imageView.mas_trailing).with.offset(Padding_Of_AvatarAndName);;
        }];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.height.equalTo(@(AvatarWidth));
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

+ (CGSize)sizeForTokenWithViewModel:(TKTokenCellViewModel *)viewModel freeWidth:(CGFloat)freeWidth {
    CGRect rect = CGRectMake(0, 0, 0, 0);
    
    // avatar
    rect.size = CGSizeMake(AvatarWidth, AvatarWidth);
    rect.size.width += Padding_Of_AvatarAndName; // space
    
    // label
    if (viewModel.name.length>0) {
        NSString *nameString = viewModel.name;
        CGRect labelFrame = [nameString boundingRectWithSize:(CGSize){freeWidth, CGFLOAT_MAX}
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TKTokenFontSize]}
                                                     context:nil];
        labelFrame.size.height = TKTokenCellHeight;
        labelFrame.size.width += LabelMargin;
        labelFrame.origin = CGPointMake(rect.origin.x+rect.size.width, 0);
        rect = CGRectUnion(rect, labelFrame);
    }
    
    return rect.size;
}

- (void)configTokenWithViewModel:(TKTokenCellViewModel *)viewModel {
    // avatar
    UIImage* placeHolderImage = [UIImage imageNamed:@"DefaultAvatar"];
    self.imageView.image = placeHolderImage;
    // label
    if (viewModel.name.length>0) {
        self.label.text = viewModel.name;
    }
}

@end