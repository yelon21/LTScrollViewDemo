//
//  ViewController.m
//  LTScrollViewDemo
//
//  Created by yelon on 16/5/2.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "ViewController.h"
#import "LTImageScrollView.h"
#import <UIImageView+WebCache.h>
@interface ViewController ()<LTImageScrollViewDelegate>{

    NSArray *listArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    listArray = @[@"http://n.7k7kimg.cn/2014/1209/1418109581623.gif",
                  @"http://pic6.nipic.com/20100323/4214896_084058018310_2.jpg",
                  @"http://www.bz55.com/uploads/allimg/150311/139-150311110321-50.jpg",
                  @"http://cdn.duitang.com/uploads/item/201409/19/20140919072040_45WBX.thumb.700_0.jpeg"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    LTImageScrollView *imageScrollView0 = [[LTImageScrollView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 130.0)];
    imageScrollView0.delegate = self;
    imageScrollView0.autoScroll =YES;
    
    [self.view addSubview:imageScrollView0];
    imageScrollView0.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    LTImageScrollView *imageScrollView1 = [[LTImageScrollView alloc]initWithFrame:CGRectMake(0.0, 140.0, CGRectGetWidth(self.view.bounds), 130.0)];
    imageScrollView1.delegate = self;
    imageScrollView1.autoScroll = NO;
    imageScrollView1.pullStyle = YES;
    
    [self.view addSubview:imageScrollView1];
    imageScrollView1.autoresizingMask = UIViewAutoresizingFlexibleWidth;

}

- (NSInteger)ltImageScrollViewNumbersOfContents:(LTImageScrollView *)imageScrollView{

    NSInteger count = [listArray count];
    NSLog(@"NumbersOfContents=%@",@(count));
    return count;
}

- (void)ltImageScrollView:(LTImageScrollView *)imageScrollView
             imageAtIndex:(NSInteger)index
                imageView:(UIImageView *)imageView{

    NSLog(@"imageAtIndex=%@",@(index));
    NSString *url = [[listArray objectAtIndex:index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([url hasPrefix:@"http"]) {
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    else{
    
        [imageView setImage:[UIImage imageNamed:url]];
    }
    
}

-(void)ltImageScrollView:(LTImageScrollView *)imageScrollView
     clickContentAtIndex:(NSInteger)index{

    NSString *url = [listArray objectAtIndex:index];
    NSLog(@"clickContentAtIndex=%@",url);
}

@end
