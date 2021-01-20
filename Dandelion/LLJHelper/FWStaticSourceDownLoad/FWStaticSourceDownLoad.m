//
//  FWStaticSourceDownLoad.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/19.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWStaticSourceDownLoad.h"
#import <AFNetworking/AFNetworking.h>
#import "LLJWebCacheModel+CoreDataClass.h"

@implementation FWStaticSourceDownLoad

#pragma mark - 静态资源缓存 -
+ (void)checkStaticSourceVersion{
    
    //去下载
    LLJCDHelper.webStaticArray = [LLJCDHelper getResourceWithEntityName:@"LLJWebCacheModel" predicate:nil];

    [self downLoadWebCache:LLJCDHelper.webStaticArray];
}

//获取版本号请求
+ (void)getManifestReq{
    
    //去下载
    LLJCDHelper.webStaticArray = [LLJCDHelper getResourceWithEntityName:@"LLJWebCacheModel" predicate:nil];

    [self downLoadWebCache:LLJCDHelper.webStaticArray];
}

+ (BOOL)downLoadWebCache:(NSArray *)webSource{
    
    LLJWebCacheModel *model = [self getUnDownLoadSourceModel:webSource];
    if (model) {
        [self downLoadTask:model array:webSource];
        return NO;
    }else{
        return YES;
    }
}
+ (LLJWebCacheModel *)getUnDownLoadSourceModel:(NSArray *)array{
    
    __block LLJWebCacheModel *model;
    [array enumerateObjectsUsingBlock:^(LLJWebCacheModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isDownLoadFinish) {
            model = obj;
            *stop = YES;
        }
    }];
    return model;
}

//下载
+ (void)downLoadTask:(LLJWebCacheModel *)model array:(NSArray *)array;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"baseUrl",model.fileName]]];
    
    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下载进度
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //创建路径
        if (IS_VALID_STRING(model.filePath)) {
            [LLJCDHelper createSourcePath:[NSString stringWithFormat:@"%@%@",LLJ_Base_Path,model.filePath]];
        }
        NSString *fullPath = [LLJ_Base_Path stringByAppendingPathComponent:model.fileName];
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                
        if (!error) {
            
            model.isDownLoadFinish = YES;
            // YES表示全部资源下载完成
            if([self downLoadWebCache:array]){
                //转移文件
                if([self moveItemAtPath:LLJ_Base_Path toPath:LLJ_Base_Path overwrite:YES error:nil]){
                    //文件转移成功更新数据库  存储版本号
                    if([LLJCDHelper insertAndUpdateResource]){
                        LLJCDHelper.webStaticArray = [LLJCDHelper getResourceWithEntityName:@"LLJWebCacheModel" predicate:nil];
                    }
                }
            }
        }
    }];
    
    [downTask resume];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 判断目标路径文件是否存在
    if ([self isExistsAtPath:toPath]) {
        //如果覆盖，删除目标路径文件
        if (overwrite) {
            //删掉目标路径文件
            [self removeItemAtPath:toPath error:error];
        }
    }
    //移动文件，当要移动到的文件路径文件存在，会移动失败
    BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
    return isSuccess;
}

#pragma mark - 判断文件(夹)是否存在
+ (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

@end
