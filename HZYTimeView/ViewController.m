//
//  ViewController.m
//  HZYTimeView
//
//  Created by jacky on 16/4/1.
//  Copyright © 2016年 com.jacky.cc. All rights reserved.
//

#import "ViewController.h"
#import "HZYTimeScrollView.h"

@interface ViewController ()<HZYTimeScrollViewDelegate>

@property(nonatomic,weak) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    HZYTimeScrollView *sv = [[HZYTimeScrollView alloc] initWithStartTime:[NSDate date] timeLength:600];
    sv.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300);
    sv.backgroundColor = [UIColor clearColor];
    sv.delegate = self;
    [self.view addSubview:sv];
    
    //add a slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 500, 200, 50)];
    [self.view addSubview:slider];
    
    //connect slider and timeScrollView
    sv.slider = slider;
    
    //add a label to show current time. protocol can get center time in view
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    label.center = CGPointMake(self.view.center.x, 50);
    [self.view addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
}

- (void)timeScrollView:(HZYTimeScrollView *)scrollView didScrollTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.ms";
    self.label.text = [formatter stringFromDate:date];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
