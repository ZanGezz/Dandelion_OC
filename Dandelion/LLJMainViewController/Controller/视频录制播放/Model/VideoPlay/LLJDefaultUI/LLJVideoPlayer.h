//
//  LLJVideoPlayer.h
//  Dandelion
//
//  Created by 刘帅 on 2020/10/22.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJBaseVideoPlayer.h"
#import "LLJDefaultPlayerUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLJVideoPlayer : LLJBaseVideoPlayer

@property (nonatomic, strong) LLJDefaultPlayerUI *defaultUI;

@property (nonatomic, strong) UIViewController *superViewController;

- (void)createDefaultPlayerUI;

@end

NS_ASSUME_NONNULL_END
