//
//  BFBackButton.m
//  bfclass
//
//  Created by 刘帅 on 2018/11/27.
//  Copyright © 2018 fltrp. All rights reserved.
//

#import "BFBackButton.h"

@implementation BFBackButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect  bounds = self.bounds;
    CGFloat widthDelta = MAX(self.touchSize.width - bounds.size.width, 0);
    CGFloat heightDelta = MAX(self.touchSize.height - bounds.size.height, 0);
    CGRect  NewBounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(NewBounds, point);
}

@end
