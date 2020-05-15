//
//  WFHistoryAddressModel.h
//  WFKit
//
//  Created by 王宇 on 2019/4/19.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFHistoryAddressModel : NSObject

/**实例化*/
+ (instancetype)shareInstance;

/**
 *  保存数据
 *
 */
- (void)saveData:(NSMutableArray *)searchArray;

/**
 *  读取数据
 *
 */
- (NSMutableArray *)readData;

/**
 *
 *   删除数据
 */
- (void)deleteData;
@end

NS_ASSUME_NONNULL_END
