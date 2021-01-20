//
//  FWSelectCell.h
//  SpringsCapital
//
//  Created by 刘帅 on 2020/5/13.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FWSelectType) {
    FWSelectTypeNameLeft,
    FWSelectTypeNameCenter
};

@interface FWSelectCell : UITableViewCell

@property (nonatomic) BOOL isSelected;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(FWSelectType)type;
- (void)setTitle:(NSString *)title font:(NSString *)fontString;

@end

NS_ASSUME_NONNULL_END
