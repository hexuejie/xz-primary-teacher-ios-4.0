//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCalendarManager.h"

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    
    _circleRatio = .9;
    _dotRatio = 1. / 9.;
    {
        
        _dayViewBackgroundImgV = [[UIImageView alloc]init];
        [self addSubview:_dayViewBackgroundImgV];
    }
    
    {
        _circleView = [UIView new];
        [self addSubview:_circleView];
        
        _circleView.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleView.hidden = YES;

        _circleView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleView.layer.shouldRasterize = YES;
    }
    
    {
        _dotView = [UIView new];
        [self addSubview:_dotView];
        
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.hidden = YES;

        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView.layer.shouldRasterize = YES;
        UIImageView * imgV = [UIImageView new];
        [imgV setTag:11222];
        [_dotView addSubview:imgV];
    }
    
    {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
   
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textLabel.frame = self.bounds;
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleRatio;
    sizeDot = sizeDot * _dotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    _circleView.layer.cornerRadius = sizeCircle / 2.;
    
    _dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    _dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) +sizeDot * 2.5);
    _dotView.layer.cornerRadius = sizeDot / 2.;
    
    /////
    _dotView.frame =  CGRectMake(0, 0,25, 25);
    _dotView.center = CGPointMake(self.frame.size.width / 2.+4, (self.frame.size.height / 2.)+5);

    _textLabel.frame = CGRectMake(4, 0, self.bounds.size.width,30);
    _textLabel.textAlignment =  NSTextAlignmentLeft;
    UIImageView * imgV = [_dotView viewWithTag:11222];
    [imgV setFrame:CGRectMake(0, 0,25, 25)];
//    self.layer.borderColor = project_main_blue.CGColor;
//    self.layer.borderWidth =  0.5;
    [self setupBackgroundImg];
}

- (void)setupBackgroundImg{
    UIImage * img = [[UIImage imageNamed:@"date_backgroud"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    [_dayViewBackgroundImgV setImage:img];
    
    _dayViewBackgroundImgV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
}
- (void)setDate:(NSDate *)date
{
    NSAssert(date != nil, @"date cannot be nil");
    NSAssert(_manager != nil, @"manager cannot be nil");
    
    self->_date = date;
    [self reload];
}

- (void)reload
{    
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [_manager.dateHelper createDateFormatter];
    }
    [dateFormatter setDateFormat:self.dayFormat];

    _textLabel.text = [ dateFormatter stringFromDate:_date];       
    [_manager.delegateManager prepareDayView:self];
}

- (void)didTouch
{
    [_manager.delegateManager didTouchDayView:self];
}

- (NSString *)dayFormat
{
    return self.manager.settings.zeroPaddedDayFormat ? @"dd" : @"d";
}

@end
