//
//  ViewController.m
//  TKTokenFieldDemo
//
//  Created by graylocus on 16/5/14.
//  Copyright © 2016年 Tapatalk Inc. All rights reserved.
//

#import "ViewController.h"
#import "TKTokenField.h"
#import "TKTokenCell.h"
#import "TKTokenCellViewModel.h"
#import "Masonry.h"

@interface ViewController ()
<TKTokenFieldDelegate,
TKTokenFieldDataSource>
@property (nonatomic, strong) TKTokenField * tokenField;
@property (nonatomic, strong) NSMutableArray *tokenArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
    [self.tokenField reloadData];
}

#pragma mark - TKTokenFieldDelegate
- (void)tokenField:(TKTokenField *)tokenField updateFrame:(CGRect)frame {
    CGFloat height = CGRectGetHeight(frame);
    
    [self.tokenField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
}

- (void)tokenField:(TKTokenField *)tokenField didRemoveTokenAtIndex:(NSUInteger)index {
    if (index < self.tokenArray.count) {
        [self.tokenArray removeObjectAtIndex:index];
    }
}

- (CGFloat)tokenMarginInTokenInField:(TKTokenField *)tokenField {
    return 5.f;
}

#pragma mark - TKTokenFieldDataSource

- (CGFloat)rowHeightOfTokenField:(TKTokenField *)tokenField {
    return TKTokenCellHeight;
}

- (NSInteger)numberOfTokensInTokenField:(TKTokenField *)tokenField {
    NSInteger count = self.tokenArray.count;
    return count;
}

- (TKTokenCell *)tokenField:(TKTokenField *)tokenField tokenCellAtIndex:(NSInteger)index {
    TKTokenCell *cell = [[TKTokenCell alloc] initWithFrame:CGRectZero];
    if (index >= self.tokenArray.count) {
        return nil;
    }
    
    TKTokenCellViewModel *viewModel = [self.tokenArray objectAtIndex:index];
    
    CGSize cellSize = [TKTokenCell sizeForTokenWithViewModel:viewModel freeWidth:self.view.frame.size.width];
    cell.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);
    [cell configTokenWithViewModel:viewModel];
    
    return cell;
}

- (void)tokenField:(TKTokenField *)tokenField didReturnWithText:(NSString*)text {
    if (text.length>0) {
        TKTokenCellViewModel *viewModel = [[TKTokenCellViewModel alloc] initWithUserInfo:@{@"userName":text}];
        if (viewModel) {
            [self.tokenArray addObject:viewModel];
        }
    }
    [self.tokenField reloadData];
}


#pragma mark - Private Methods

- (void)initUI {
    _tokenField = [[TKTokenField alloc] initWithFrame:CGRectZero style:TKTokenFieldStyleDefault options:TKTokenField_MoreButton];
    _tokenField.dataSource = self;
    _tokenField.delegate = self;
    UIFont *font = [UIFont systemFontOfSize:TKTokenFontSize];
    NSAttributedString *placeHolder =
    [[NSAttributedString alloc] initWithString:@"To"
                                    attributes:@{NSForegroundColorAttributeName:RGB_COLOR(168, 168, 168), NSFontAttributeName:font}];
    _tokenField.attributedPlaceholder = placeHolder;
    _tokenField.backgroundColor = RGB_COLOR(250, 250, 250);
    [self.view addSubview:self.tokenField];
    [self.tokenField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(20.f);
        make.trailing.equalTo(self.view).with.offset(-20.f);
        make.top.equalTo(self.view).with.offset(100.f);
    }];
}

- (void)initData {
    _tokenArray = [NSMutableArray array];
}

@end
