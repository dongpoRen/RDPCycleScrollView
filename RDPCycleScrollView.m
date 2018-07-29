//
//  RDPCycleScrollView.m
//  UIScrollView的无限滚动
//
//  Created by DongpoRen on 16/8/15.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "RDPCycleScrollView.h"
#define kCount self.images.count

@interface RDPCycleScrollView ()
@end

@implementation RDPCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self rdp_cycleScrollViewWithRect:frame];
    }

    return  self;
}

/**
 *  当同时重写一个读写属性的set和get方法的时候,就不会在生成相应的成员变量
 *  区别:self.images 和 _images;前者表示通过get方法,而后者直接是一个私有成员;
 *  @return <#return value description#>
 */
- (NSMutableArray *)images{
    // 如何同时在get方法中,使用self.images则将会引起死循环;
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)rdp_cycleScrollViewWithRect:(CGRect)frame {
    
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    // 初始化scrollView
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(w * 3, 0);
    _scrollView.contentOffset = CGPointMake(w, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    // 创建可见的imageView
    UIImageView *visibleView = [[UIImageView alloc] init];
    _visibleView = visibleView;

    _visibleView.frame = CGRectMake(w, 0, w, h);
    _visibleView.tag = 0;
    [_scrollView addSubview:_visibleView];
    
    // 创建重复利用的imageView
    UIImageView *reuseView = [[UIImageView alloc] init];
    _reuseView = reuseView;
    _reuseView.frame = CGRectMake(0, 0, w, h);
    [_scrollView addSubview:_reuseView];
}

#pragma mark- 重新开始布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    _visibleView.image = [UIImage imageNamed:self.images[0]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat w = scrollView.frame.size.width;
    
    // 1.设置 循环利用view 的位置
    CGRect f = _reuseView.frame;

    NSInteger index = 0;
    
    if (offsetX > _visibleView.frame.origin.x) { // 显示在最右边
        
        f.origin.x = scrollView.contentSize.width - w;
        
        index = _visibleView.tag + 1;
        if (index >= kCount) index = 0;
    } else { // 显示在最左边
        f.origin.x = 0;
        
        index = _visibleView.tag - 1;
        if (index < 0) index = kCount - 1;
    }

    // 设置重复利用的视图
    _reuseView.frame = f;
    _reuseView.tag = index;
    
    _reuseView.image = [UIImage imageNamed:self.images[index]];

    // 2.滚动到 最左 或者 最右 的图片
    if (offsetX <= 0 || offsetX >= w * 2) {
        // 2.1.交换 中间的 和 循环利用的指针
        UIImageView *temp = _visibleView;
        _visibleView = _reuseView;
        _reuseView = temp;
        
        // 2.2.交换显示位置
        _visibleView.frame = _reuseView.frame;
        // 2.3 初始化scrollView的偏移量
        scrollView.contentOffset = CGPointMake(w, 0);
        
    }
    
}

@end
