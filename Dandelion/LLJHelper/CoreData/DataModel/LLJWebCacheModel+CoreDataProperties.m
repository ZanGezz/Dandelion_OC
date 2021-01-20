//
//  LLJWebCacheModel+CoreDataProperties.m
//  
//
//  Created by 刘帅 on 2020/11/13.
//
//

#import "LLJWebCacheModel+CoreDataProperties.h"

@implementation LLJWebCacheModel (CoreDataProperties)

+ (NSFetchRequest<LLJWebCacheModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LLJWebCacheModel"];
}

@dynamic fileName;
@dynamic filePath;
@dynamic isDownLoadFinish;

@end
