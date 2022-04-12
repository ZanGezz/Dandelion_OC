//
//  LLJChanelItem.h
//  Dandelion
//
//  Created by 刘帅 on 2019/11/12.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLJChanelItem : UICollectionViewCell

//删除
@property (nonatomic, copy) void (^deletIamgeBlock)(NSInteger index);
//标题
@property (nonatomic, copy) NSString *title;
//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;
//图片
@property (nonatomic, strong) UIImageView *imageView;
//是否被固定
@property (nonatomic, assign) BOOL isFixed;

- (void)setIamgeName:(id)imageName index:(NSInteger)imageIndex deletHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
