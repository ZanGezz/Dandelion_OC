//
//  LLJFTableView.m
//  Dandelion
//
//  Created by 刘帅 on 2019/11/11.
//  Copyright © 2019 liushuai. All rights reserved.
//

#import "LLJFTableView.h"

@implementation LLJFTableView

- (void)scrollToViewTop{
    
    //4种使Tableview滚动到顶部的方法
    
    //建议使用这种方法
    if ([self numberOfRowsInSection:0] > 0) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    //[self setContentOffset:CGPointMake(0, 0)];
    
    //[self setContentOffset:CGPointMake(0,0) animated:YES];
    
    //[self scrollRectToVisible:CGRectMake(0, 0, 0.1, 0.1) animated:YES];
}

@end
