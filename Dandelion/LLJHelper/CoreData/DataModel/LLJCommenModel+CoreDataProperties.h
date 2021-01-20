//
//  LLJCommenModel+CoreDataProperties.h
//  
//
//  Created by 刘帅 on 2019/11/11.
//
//

#import "LLJCommenModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LLJCommenModel (CoreDataProperties)

+ (NSFetchRequest<LLJCommenModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *imagePath;
@property (nullable, nonatomic, copy) NSString *age;

@end

NS_ASSUME_NONNULL_END
