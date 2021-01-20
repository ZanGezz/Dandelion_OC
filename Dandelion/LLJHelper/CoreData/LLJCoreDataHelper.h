//
//  LLJCoreDataHelper.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/29.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define LLJCDHelper [LLJCoreDataHelper helper]

@interface LLJCoreDataHelper : NSObject


@property (nonatomic, strong) NSArray *webStaticArray;
/**
 * coreData部分
 */
@property (nonatomic, strong) NSManagedObjectContext *context;

+ (LLJCoreDataHelper *)helper;
- (void)createMyCoreData;
- (void)createSourcePath:(NSString *)path;

//创建存储model
- (id)createModel:(NSString *)entityName;
- (id)getModel:(NSString *)entityName predicate:(NSString *)preString;
//插入数据
- (BOOL)insertAndUpdateResource;
//根据模型名称和查询条件删除数据
- (BOOL)deleteResourceWithEntityName:(NSString *)entityName  predicate:(NSString *)preString;
//根据模型名称和查询条件查询数据
- (NSArray *)getResourceWithEntityName:(NSString *)entityName predicate:(NSString *)preString;


@end

NS_ASSUME_NONNULL_END
