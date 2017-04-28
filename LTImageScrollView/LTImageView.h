//
//  LTImageView.h
//  LTScrollViewDemo
//
//  Created by yelon on 16/5/2.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTImageView : UIView

@property (nonatomic,strong,readonly) UIScrollView *scrollView;
@property (nonatomic,strong,readonly) UIImageView *imageView;
@end
