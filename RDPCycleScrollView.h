//
//  RDPCycleScrollView.h
//  UIScrollView的无限滚动
//
//  Created by DongpoRen on 16/8/15.
//  Copyright © 2016年 yz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDPCycleScrollView : UIView<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *visibleView;
@property (strong, nonatomic) UIImageView *reuseView;

/* iamges */
@property (nonatomic, strong) NSMutableArray *images;

@end
