//
//  TKTokenCellViewModel.h
//  Tapatalk
//
//  Created by graylocus on 16/4/26.
//
//


#import <Foundation/Foundation.h>

@interface TKTokenCellViewModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * iconURL;

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo;
@end