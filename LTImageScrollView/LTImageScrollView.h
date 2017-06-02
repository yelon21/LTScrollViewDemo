//
//  LTImageScrollView.h
//  LTScrollViewDemo
//
//  Created by yelon on 16/5/2.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTImageScrollView;

@protocol LTImageScrollViewDelegate <NSObject>

- (NSInteger)ltImageScrollViewNumbersOfContents:(LTImageScrollView *)imageScrollView;
- (void)ltImageScrollView:(LTImageScrollView *)imageScrollView
             imageAtIndex:(NSInteger)index
                imageView:(UIImageView *)imageView;
@optional
- (void)ltImageScrollView:(LTImageScrollView *)imageScrollView
      clickContentAtIndex:(NSInteger)index;

- (void)ltImageScrollView:(LTImageScrollView *)imageScrollView
             currentIndex:(NSInteger)currentIndex;
@end

@interface LTImageScrollView : UIView

@property (nonatomic,assign) NSInteger currentPageIndex;

@property(nonatomic,assign) id<LTImageScrollViewDelegate>delegate;

@property (nonatomic,assign) NSTimeInterval scrollDuration;
@property (nonatomic,assign) BOOL autoScroll;
@property (nonatomic,assign) BOOL pullStyle;

@property (nonatomic,assign) BOOL forceToNoCycle;

@property(nonatomic,strong,readonly)UIScrollView *scrollView;

@property (nonatomic,strong,readonly) UIPageControl *pageControl;

- (void)lt_reloadContents;

- (UIImageView *)lt_currentImageView;

- (void)lt_clearImageContents;
@end
