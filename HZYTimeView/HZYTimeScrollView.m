//
//  HZYTimeScrollView.m
//  HZYTimeView
//
//  Created by jacky on 16/4/1.
//  Copyright © 2016年 com.jacky.cc. All rights reserved.
//

#import "HZYTimeScrollView.h"

#define timeScrollCellIdentify @"timeScroll"


@interface HZYRuleView ()

@property(nonatomic,assign,getter=isLastCell) BOOL lastCell;
@property(nonatomic,assign) NSTimeInterval leftTimeLength;

@end

@implementation HZYRuleView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawPieceTimeZone:ctx withHeight:self.bounds.size.height andBeginPoint:0];
}


- (void)drawPieceTimeZone:(CGContextRef)ctx withHeight:(CGFloat)height andBeginPoint:(CGFloat)orginY
{
    CGContextSetLineWidth(ctx, 1);
    CGContextMoveToPoint(ctx, 0, orginY);
    CGContextAddLineToPoint(ctx, 15, orginY);
    CGContextMoveToPoint(ctx, self.bounds.size.width, orginY);
    CGContextAddLineToPoint(ctx, self.bounds.size.width - 15, orginY);
    
    NSInteger section = 10;
    CGFloat width = height/(CGFloat)section ;
    
    if (self.lastCell) {
        section = (((NSInteger)self.leftTimeLength % 6) == 0 && (self.leftTimeLength - (NSInteger)self.leftTimeLength) == 0) ? self.leftTimeLength / 6 : self.leftTimeLength / 6 + 1;
    }
    
    for (int i = 0; i < section - 1; i++) {
        if (i == 4) {
            CGContextMoveToPoint(ctx, 0, orginY + width * (i+1));
            CGContextAddLineToPoint(ctx, 10, orginY + width * (i+1));
            CGContextMoveToPoint(ctx, self.bounds.size.width, orginY + width * (i+1));
            CGContextAddLineToPoint(ctx, self.bounds.size.width - 10, orginY + width * (i+1));
            continue;
        }
        CGContextMoveToPoint(ctx, 0, orginY + width * (i+1));
        CGContextAddLineToPoint(ctx, 5, orginY + width * (i+1));
        CGContextMoveToPoint(ctx, self.bounds.size.width, orginY + width * (i+1));
        CGContextAddLineToPoint(ctx, self.bounds.size.width - 5, orginY + width * (i+1));
    }
    
    if (self.lastCell) {
        CGContextMoveToPoint(ctx, 0, self.leftTimeLength / 60.f * self.bounds.size.height);
        CGContextAddLineToPoint(ctx, 15, self.leftTimeLength / 60.f * self.bounds.size.height);
        CGContextMoveToPoint(ctx, self.bounds.size.width, self.leftTimeLength / 60.f * self.bounds.size.height);
        CGContextAddLineToPoint(ctx, self.bounds.size.width - 15, self.leftTimeLength / 60.f * self.bounds.size.height);
    }else{
        CGContextMoveToPoint(ctx, 0, orginY + width * section);
        CGContextAddLineToPoint(ctx, 15, orginY + width * section);
        CGContextMoveToPoint(ctx, self.bounds.size.width, orginY + width * section);
        CGContextAddLineToPoint(ctx, self.bounds.size.width - 15, orginY + width * section);
    }
    
    CGContextStrokePath(ctx);
    
}

@end


//***   _(:3 」∠)_ _(:3 」∠)_  *★,°*:.☆\(￣▽￣)/$:*.°★*  _(:3 」∠)_ _(:3 」∠)_  ***//
//****************************      我是伟大的分割线    ***************************//


@interface HZYTimeCell ()

@property(nonatomic,strong) HZYRuleView *ruleView;
@property(nonatomic,assign) NSTimeInterval leftTimeLength;
@property(nonatomic,assign,getter=isLastCell) BOOL lastCell;

@property(nonatomic,strong) UILabel *timeLabel;

@end

@implementation HZYTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.ruleView = [[HZYRuleView alloc] init];
    self.ruleView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.ruleView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.contentView addSubview:self.timeLabel];
}

- (void)setLastCell:(BOOL)lastCell
{
    _lastCell = lastCell;
    if (lastCell) {
        self.ruleView.lastCell = YES;
    }else{
        self.ruleView.lastCell = NO;
    }
}

- (void)setLeftTimeLength:(NSTimeInterval)leftTimeLength
{
    _leftTimeLength = leftTimeLength;
    self.ruleView.leftTimeLength = leftTimeLength;
}

- (void)setTime:(NSString *)time
{
    _time = time;
    self.timeLabel.text = time;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.ruleView.frame = self.bounds;
    [self.ruleView setNeedsDisplay];
    
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.bounds.size.width - 15 - self.timeLabel.bounds.size.height, 3, self.timeLabel.bounds.size.height, self.timeLabel.bounds.size.width);
}

@end



//***   _(:3 」∠)_ _(:3 」∠)_  *★,°*:.☆\(￣▽￣)/$:*.°★*  _(:3 」∠)_ _(:3 」∠)_  ***//
//****************************      我是伟大的分割线    ***************************//


@interface HZYTimeScrollView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *centerLine;

@property(nonatomic,strong) NSDate *date;
@property(nonatomic,strong) NSDateFormatter *formatter;
@property(nonatomic,assign) NSTimeInterval timeLength;
@property(nonatomic,assign) NSTimeInterval leftTimeLength;

@property(nonatomic,assign) NSInteger numberOfRow;

@end

@implementation HZYTimeScrollView


- (instancetype)initWithStartTime:(NSDate *)date timeLength:(NSTimeInterval)timeLength
{
    if (self = [super init]) {
        self.date = date;
        self.timeLength = timeLength;
        [self calculateNumberOfCell];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - 布局子控件

- (void)setupSubviews
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 62.f;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    ///中心线
    self.centerLine = [[UIView alloc] init];
    self.centerLine.backgroundColor = [UIColor redColor];
    [self addSubview:self.centerLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    self.tableView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.width * 0.5, 0, self.bounds.size.width * 0.5 - (1 - self.leftTimeLength / 60.f) * self.tableView.rowHeight, 0);
    
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.contentOffset = CGPointMake(0, -self.bounds.size.width*0.5);
    
    self.centerLine.frame = CGRectMake(self.bounds.size.width * 0.5 - 1, 0, 2, self.bounds.size.height);
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HZYTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:timeScrollCellIdentify];
    if (cell == nil) {
        cell = [[HZYTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeScrollCellIdentify];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.time = [self.formatter stringFromDate:[NSDate dateWithTimeInterval:60 * indexPath.row sinceDate:self.date]];
    if (indexPath.row == self.numberOfRow - 1) {
        cell.lastCell = YES;
        cell.leftTimeLength = self.leftTimeLength;
    }else{
        cell.lastCell = NO;
        cell.leftTimeLength = 0;
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSDate *date = [NSDate dateWithTimeInterval:self.timeLength * ((scrollView.contentOffset.y + self.bounds.size.width * 0.5) - (1 - self.leftTimeLength==0?60.f:self.leftTimeLength/ 60.f) * self.tableView.rowHeight)/(self.tableView.contentSize.height) sinceDate:self.date];
    if ([self.delegate respondsToSelector:@selector(timeScrollView:didScrollTime:)]) {
        [self.delegate timeScrollView:self didScrollTime:date];
    }
}

#pragma mark - 事件

- (void)calculateNumberOfCell
{
    self.leftTimeLength = (NSInteger)self.timeLength % 60 + self.timeLength - (NSInteger)self.timeLength;
    self.numberOfRow = (((NSInteger)self.timeLength % 60) == 0 && (self.timeLength - (NSInteger)self.timeLength) == 0)? self.timeLength / 60 : self.timeLength / 60 + 1;
}

- (void)scaleBegin:(UISlider *)sender
{
    [self.tableView beginUpdates];
//    CGFloat value = (self.tableView.contentOffset.y + self.bounds.size.width * 0.5) / self.tableView.contentSize.height;
    NSLog(@"height : %f offset : %f",self.tableView.contentSize.height,self.tableView.contentOffset.y);
    self.tableView.rowHeight = sender.value;
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.width * 0.5, 0, self.bounds.size.width * 0.5 - (1 - self.leftTimeLength / 60.f) * sender.value, 0);
//    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, value * self.tableView.contentSize.height - self.bounds.size.width * 0.5);
    [self.tableView endUpdates];
}

- (void)setSlider:(UISlider *)slider
{
    _slider = slider;
    slider.maximumValue = 310.f;
    slider.minimumValue = 62.f;
    [slider addTarget:self action:@selector(scaleBegin:) forControlEvents:UIControlEventValueChanged];
}

- (void)setTimeLength:(NSTimeInterval)timeLength
{
    NSAssert(timeLength > 0, @"timeLength should not equal or smaller than 0");
    
    _timeLength = timeLength;
}

- (NSDateFormatter *)formatter
{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"mm:ss";
    }
    return _formatter;
}

@end
