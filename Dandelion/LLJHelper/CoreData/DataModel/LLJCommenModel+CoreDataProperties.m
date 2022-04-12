//
//  LLJCommenModel+CoreDataProperties.m
//  
//
//  Created by 刘帅 on 2019/11/11.
//
//

#import "LLJCommenModel+CoreDataProperties.h"

@implementation LLJCommenModel (CoreDataProperties)

+ (NSFetchRequest<LLJCommenModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"LLJCommenModel"];
}

@dynamic name;
@dynamic imagePath;
@dynamic age;

@end
