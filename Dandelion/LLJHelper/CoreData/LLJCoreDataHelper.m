//
//  LLJCoreDataHelper.m
//  Dandelion
//
//  Created by 刘帅 on 2020/10/29.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJCoreDataHelper.h"
#import <CoreData/CoreData.h>

@implementation LLJCoreDataHelper

/**
 *  coreData数据库相关api
 */
#pragma mark - 创建单例 -
+ (LLJCoreDataHelper *)helper
{
    static LLJCoreDataHelper *_helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[LLJCoreDataHelper alloc] init];
        //创建文件存储路径
        [LLJHelper createSourcePath:LLJ_CoreData_Path];
        [LLJHelper createSourcePath:LLJ_image_Path];
        [LLJHelper createSourcePath:LLJ_video_Path];

        //创建coredata
        [_helper createMyCoreData];
    }) ;
    return _helper;
}

/*
 *  coreData数据库相关api
 */
#pragma mark - 创建数据库 -
- (void)createMyCoreData{
    
    //1、创建模型对象
    //获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LLJCoreData" withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2、创建持久化存储助理：数据库
    //利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //数据库的名称和路径
    NSString *sqlPath = [LLJ_CoreData_Path stringByAppendingPathComponent:@"LLJCoreData.sqlite"];
    //先删除原路径后面重新创建，否则，改变模型时，会崩溃
    //[[NSFileManager defaultManager] removeItemAtPath:sqlPath error:nil];
    
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    NSError *error = nil;
    //设置数据库相关信息 添加一个持久化存储库并设置存储类型和路径，NSSQLiteStoreType：SQLite作为存储库
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    
    //3、创建上下文 保存信息 操作数据库
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //关联持久化助理
    context.persistentStoreCoordinator = store;
    
    _context = context;
    
}

#pragma mark - *创建存储model * -
- (id)createModel:(NSString *)entityName{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName  inManagedObjectContext:_context];
}

- (id)getModel:(NSString *)entityName predicate:(NSString *)preString{
    
    NSArray *array = [self getResourceWithEntityName:entityName predicate:preString];
    if (IS_VALID_ARRAY(array)) {
        return [array firstObject];
    }
    return [self createModel:entityName];
}

#pragma mark - 增 * 根据模型名称和查询条件插入数据 * -
- (BOOL)insertAndUpdateResource
{
    //3.保存插入的数据
    NSError *error = nil;
    if ([_context save:&error]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 删 * 根据模型名称和查询条件删除数据 * -
- (BOOL)deleteResourceWithEntityName:(NSString *)entityName  predicate:(NSString *)preString
{
    NSArray *array = [self getResourceWithEntityName:entityName predicate:preString];
   
    for (id object in array) {
        [_context deleteObject:object];
    }
    NSError * error = nil;
    [_context save:&error];
    
    if (error !=nil ) {
        return NO;
    }
    return YES;
}

#pragma mark - 查 * 根据模型名称和查询条件查询数据 * -
- (NSArray *)getResourceWithEntityName:(NSString *)entityName predicate:(NSString *)preString
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (preString) {
        request.predicate = [NSPredicate predicateWithFormat:preString];
    }
    
    NSError * error = nil;
    NSArray * array = [_context executeFetchRequest:request error:&error];
    if (error || !IS_VALID_ARRAY(array)) {
        return nil;
    }else{
        
    }
    if (0==[array count]) {
        return nil;
    }
    return array;
}

@end
