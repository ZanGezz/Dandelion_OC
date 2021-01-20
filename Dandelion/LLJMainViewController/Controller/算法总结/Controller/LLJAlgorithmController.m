//
//  LLJAlgorithmController.m
//  Dandelion
//
//  Created by 刘帅 on 2020/2/24.
//  Copyright © 2020 liushuai. All rights reserved.
//

#import "LLJAlgorithmController.h"

@interface LLJAlgorithmController ()

@end

@implementation LLJAlgorithmController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *numArray = [NSMutableArray arrayWithArray: @[@"9",@"1",@"4",@"6",@"8",@"12",@"3",@"6",@"5",@"15",@"88",@"66"]];
    //NSLog(@"冒泡正序 = %@",[self bubbleSortWithArray:numArray sort:YES]);
    //NSLog(@"选择正序 = %@",[self bubbleSortWithArray:numArray sort:YES]);
    NSLog(@"插入正序 = %@",[self insertSortArray:numArray sort:NO]);

    [self quickSortArray:numArray leftIndex:0 rightIndex:numArray.count-1 sort:NO];
    NSLog(@"快速正序 = %@",numArray);
}
#pragma mark - 冒泡排序 -
- (NSArray *)bubbleSortArray:(NSArray *)array sort:(BOOL)smallToLarge {
    /** 冒泡排序原理：取数组最后一个和倒数第二个数做比较，如果小就交换两者位置，然后去倒数第二个和倒数第三个做比较，如果小就
        交换位置，一次类推，交换array.count - 1次后，最小的数被换到第一个位置，然后从剩余的数里，再次循环上面操作，将第二个小
        数换到第二的位置，一次类推，循环array.count - 1次后，所以数排序完成。
        共计操作次数：(n-1)+(n-2)+......+1 = n(n-1)/2，因此时间复杂度为 O(n2)
     */
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < sortArray.count - 1; i ++) {
        for (NSInteger j = sortArray.count - 1; j > 0; j --) {
            if (smallToLarge) {
                if ([sortArray[j] integerValue] < [sortArray[j - 1] integerValue]) {
                    [sortArray exchangeObjectAtIndex:j withObjectAtIndex:j - 1];
                }
            } else {
                if ([sortArray[j] integerValue] > [sortArray[j - 1] integerValue]) {
                    [sortArray exchangeObjectAtIndex:j withObjectAtIndex:j - 1];
                }
            }
        }
    }
    return sortArray;
}

#pragma mark - 选择排序 -
- (NSArray *)selectSortArray:(NSArray *)array sort:(BOOL)smallToLarge {
    /** 选择排序原理：取数组第一个数，然后依次取剩余的数与之比较，如果小就交换两者位置，这样一轮之后，最小数排序完成，然后取第二个数，取剩余的数与之比较，如果小就交换两者位置，一轮之后，第二个小的数排序完成，一次类推，所以数排序完成。
        共计操作次数：(n-1)+(n-2)+......+1 = n(n-1)/2，因此时间复杂度为 O(n2)
     */
    NSMutableArray *numArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < numArray.count - 1; i ++) {
        for (int j = i + 1; j < numArray.count; j ++) {
            if (smallToLarge) {
                if ([numArray[i] integerValue] > [numArray[j] integerValue]) {
                    [numArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            } else {
                if ([numArray[i] integerValue] < [numArray[j] integerValue]) {
                    [numArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    return numArray;
}

#pragma mark - 快速排序 -
- (NSArray *)quickSortArray:(NSArray *)array sort:(BOOL)smallToLarge {
    NSMutableArray *numArray = [NSMutableArray arrayWithArray:array];
    [self quickSortArray:numArray leftIndex:0 rightIndex:numArray.count - 1 sort:smallToLarge];
    return numArray;
}
- (void)quickSortArray:(NSMutableArray *)numArray
            leftIndex:(NSInteger)left
           rightIndex:(NSInteger)right
                 sort:(BOOL)smallToLarge {
    if (left > right) {
        return;
    }
    NSInteger i = left;
    NSInteger j = right;
    //记录基准数 pivoty
    NSInteger key = [numArray[i] integerValue];
    while (i < j) {
        if (smallToLarge) {
            //首先从右边j开始查找(从最右边往左找)比基准数(key)小的值<---
            while (i < j && key <= [numArray[j] integerValue]) {
                j --;
            }
            //如果从右边j开始查找的值[array[j] integerValue]比基准数小，则将查找的小值调换到i的位置
            if (i < j) {
                [numArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            //从i的右边往右查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 --->
            while (i < j && [numArray[i] integerValue] <= key) {
                i ++;
            }
            //如果从i的右边往右查找的值[array[i] integerValue]比基准数大，则将查找的大值调换到j的位置
            if (i < j) {
                [numArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        } else {
            //首先从右边j开始查找(从最右边往左找)比基准数(key)小的值<---
            while (i < j && key >= [numArray[j] integerValue]) {
                j --;
            }
            //如果从右边j开始查找的值[array[j] integerValue]比基准数小，则将查找的小值调换到i的位置
            if (i < j) {
                [numArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            //从i的右边往右查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 --->
            while (i < j && [numArray[i] integerValue] >= key) {
                i ++;
            }
            //如果从i的右边往右查找的值[array[i] integerValue]比基准数大，则将查找的大值调换到j的位置
            if (i < j) {
                [numArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    //递归排序
    //将i左边的数重新排序
    [self quickSortArray:numArray leftIndex:left rightIndex:i - 1 sort:smallToLarge];
    //将i右边的数重新排序
    [self quickSortArray:numArray leftIndex:i + 1 rightIndex:right sort:smallToLarge];
}
#pragma mark - 插入排序 -
- (NSArray *)insertSortArray:(NSArray *)array sort:(BOOL)smallToLarge {
    NSMutableArray *numArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < numArray.count; i ++) {
        for (int j = i; j > 0; j --) {
            if (smallToLarge) {
                if ([numArray[j] integerValue] < [numArray[j - 1] integerValue]) {
                    [numArray exchangeObjectAtIndex:j withObjectAtIndex:j - 1];
                }
            } else {
                if ([numArray[j] integerValue] > [numArray[j - 1] integerValue]) {
                    [numArray exchangeObjectAtIndex:j withObjectAtIndex:j - 1];
                }
            }
        }
    }
    return numArray;
}
@end
