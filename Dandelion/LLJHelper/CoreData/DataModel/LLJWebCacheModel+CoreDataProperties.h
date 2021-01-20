//
//  LLJWebCacheModel+CoreDataProperties.h
//  
//
//  Created by 刘帅 on 2020/11/13.
//
//

#import "LLJWebCacheModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LLJWebCacheModel (CoreDataProperties)

+ (NSFetchRequest<LLJWebCacheModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fileName;
@property (nullable, nonatomic, copy) NSString *filePath;
@property (nonatomic) BOOL isDownLoadFinish;

@end

NS_ASSUME_NONNULL_END
