//
//  UIView+UIScreenDisplaying.h
//  LTScrollViewDemo
//
//  Created by 龙 on 2022/3/3.
//  Copyright © 2022 yelon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UIScreenDisplaying)

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen;
@end

NS_ASSUME_NONNULL_END
