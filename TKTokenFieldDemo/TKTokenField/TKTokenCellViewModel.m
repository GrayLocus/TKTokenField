//
//  TKTokenCellViewModel.m
//  Tapatalk
//
//  Created by graylocus on 16/4/26.
//
//

#import <Foundation/Foundation.h>
#import "TKTokenCellViewModel.h"

@implementation TKTokenCellViewModel

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        self.iconURL = userInfo[@"iconURL"];
        self.name = userInfo[@"userName"];
    }
    
    return self;
}

@end
