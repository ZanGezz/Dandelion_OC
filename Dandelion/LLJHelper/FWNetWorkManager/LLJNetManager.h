//
//  LLJNetManager.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/21.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWNoDataView.h"
#import "FWBaseReq.h"
#import "FWBaseResp.h"

NS_ASSUME_NONNULL_BEGIN

#define LLJNetWork [LLJNetManager shareInstance]

@interface LLJNetManager : NSObject

@property (nonatomic, copy) NSString *networkState;       

/**
 *  单例模式
 */
+ (LLJNetManager *)shareInstance;

/**
 *  检测网络
 */
- (void)monitorNetworking;

/**
 *  普通网络请求
 */
- (void)startWithMethod:(NSString *)method
                    url:(NSString *)urlString
                baseURL:(NSURL *)baseURL
                headers:(NSDictionary *)headers
                   body:(id)body
         completedBlock:(void (^)(NSInteger, NSDictionary * _Nullable, NSString * _Nullable))completedBlock;

/**
 *  AFNW Post请求
 */
- (void)postAFNWRequest:(FWBaseReq*)request
       withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
            failure:(void (^)(FWBaseReq *req, NSError *error))failure;

/**
 *  AFNW post请求 传入tableview
 */
- (void)postAFNWRequest:(FWBaseReq *)request
          tableView:(UITableView *)tableView
         noDataType:(void (^)(FWNoDataType))noDataType
       withSucessed:(void (^)(FWBaseReq * _Nonnull, FWBaseResp * _Nonnull))success
            failure:(void (^)(FWBaseReq * _Nonnull, NSError * _Nonnull))failure;

/**
 *  Post请求
 */
- (void)postRequest:(FWBaseReq*)request
       withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
            failure:(void (^)(FWBaseReq *req, NSError *error))failure;

/**
 *  post请求 传入tableview
 */
- (void)postRequest:(FWBaseReq *)request
          tableView:(UITableView *)tableView
         noDataType:(void (^)(FWNoDataType))noDataType
       withSucessed:(void (^)(FWBaseReq * _Nonnull, FWBaseResp * _Nonnull))success
            failure:(void (^)(FWBaseReq * _Nonnull, NSError * _Nonnull))failure;

/**
 *  get请求
 */
- (void)getRequest:(FWBaseReq*)request
       withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
            failure:(void (^)(FWBaseReq *req, NSError *error))failure;

/**
 *  get请求 传入tableview
 */
- (void)getRequest:(FWBaseReq *)request
         tableView:(UITableView *)tableView
        noDataType:(void (^)(FWNoDataType type))noDataType
      withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
           failure:(void (^)(FWBaseReq *req, NSError *error))failure;

/**
 *  put请求
 */
- (void)putRequest:(FWBaseReq *)request
      withSucessed:(void (^)(FWBaseReq *req, FWBaseResp *resp))success
           failure:(void (^)(FWBaseReq *req, NSError *error))failure;




#pragma mark - 下载相关api -

/**
 *  使用afnetworking封装的下载
 */
- (NSURLSessionTask *)downLoadAFNWWithUrlString:(NSString *)urlString
                                   progress:(void (^)(NSProgress * _Nonnull progress))downLoadProgress
                                destination:(NSString * (^)(NSURL * sourcePath, NSURLResponse * _Nonnull response))destination
                          completionHandler:(void (^)(NSURLResponse * _Nonnull response,NSURL * _Nullable        filePath,NSError * _Nullable error))completionHandler
                               autoDownLoad:(BOOL)autoDownLoad;


@end

NS_ASSUME_NONNULL_END
