//
//  LLJCycleModel.m
//  Dandelion
//
//  Created by 刘帅 on 2021/2/24.
//  Copyright © 2021 liushuai. All rights reserved.
//

#import "LLJCycleModel.h"

@implementation LLJCycleModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _minRatio = 0.001;
        _strokeColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setTotalProperty:(double)totalProperty {
    _totalProperty = totalProperty;
    if (_totalProperty > 0.0) {
        _ratio         = _productProperty / _totalProperty;
        _estimateRatio = _ratio < _minRatio ? _minRatio : _ratio;
    }
}

- (void)setProductProperty:(double)productProperty {
    
    _productProperty = productProperty;
    if (_totalProperty > 0.0) {
        _ratio         = _productProperty / _totalProperty;
        _estimateRatio = _ratio < _minRatio ? _minRatio : _ratio;
    }
}
@end
