//
//  WCQSegmentView.h
//  Test
//
//  Created by wcq on 2017/4/26.
//  Copyright © 2017年 Aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCQSegmentView : UIView

@property (nonatomic, strong) void(^selectedItemBlock)(NSIndexPath *indexPath);

- (instancetype)initWithFrame:(CGRect)frame itemsCount:(NSInteger)itemsCount;

@end
