//
//  HZYTimeScrollView.h
//  HZYTimeView
//
//  Created by jacky on 16/4/1.
//  Copyright © 2016年 com.jacky.cc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HZYRuleView : UIView

//@property(nonatomic,assign,getter=isLastCell) BOOL lastCell;

@end


//***   _(:3 」∠)_ _(:3 」∠)_  *★,°*:.☆\(￣▽￣)/$:*.°★*  _(:3 」∠)_ _(:3 」∠)_  ***//
//****************************      我是伟大的分割线    ***************************//

@interface HZYTimeCell : UITableViewCell

@property(nonatomic,strong) NSString *time;

@end

//***   _(:3 」∠)_ _(:3 」∠)_  *★,°*:.☆\(￣▽￣)/$:*.°★*  _(:3 」∠)_ _(:3 」∠)_  ***//
//****************************      我是伟大的分割线    ***************************//

@class HZYTimeScrollView;

@protocol HZYTimeScrollViewDelegate <NSObject>

- (void)timeScrollView:(HZYTimeScrollView *)scrollView didScrollTime:(NSDate *)date;

@end

@interface HZYTimeScrollView : UIView

@property(nonatomic,strong) UISlider *slider;

@property(nonatomic,weak) id<HZYTimeScrollViewDelegate> delegate;

- (instancetype)initWithStartTime:(NSDate *)date timeLength:(NSTimeInterval)timeLength;

@end
