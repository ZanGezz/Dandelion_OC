//
//  FWLangageButton.m
//  SpringsCapital
//
//  Created by 刘帅 on 2020/4/30.
//  Copyright © 2020 SinoBridge. All rights reserved.
//

#import "FWLangageButton.h"

@implementation FWLangageButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //当前btn大小
    CGRect btnBounds = self.bounds;
    //判断点击位置
    CGRect selectRect = CGRectMake(btnBounds.origin.x, btnBounds.origin.y, btnBounds.size.width/2, btnBounds.size.height);
    if (CGRectContainsPoint(selectRect, point)) {
        self.clickPosition = @"left";
    }else{
        self.clickPosition = @"right";
    }
    //若点击的点在新的bounds里，就返回YES
    return CGRectContainsPoint(btnBounds, point);
}

@end
