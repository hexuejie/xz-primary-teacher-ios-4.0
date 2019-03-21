//
//  THScrollChooseView.m
//  THChooseTool


#define THScreenW [UIScreen mainScreen].bounds.size.width

#define THScreenH [UIScreen mainScreen].bounds.size.height

#define THWParam [UIScreen mainScreen].bounds.size.width/375.0f

#define THfloat(a) a*THWParam

#import "THScrollChooseView.h"
#import "PublicDocuments.h"

#define   kWhiteViewHeight  THfloat(45+220)
@interface THScrollChooseView()<UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) UIView *bottomView;

/**
 取消按钮
 */
@property (strong, nonatomic) UIButton *cancelButton;

/**
 确定按钮
 */
@property (strong, nonatomic) UIButton *confirmButton;

/**
 选中数据是第几条
 */
@property (assign, nonatomic) NSInteger selectedValue;

/**
 数组
 */
@property (strong, nonatomic) NSArray *questionArray;
/**
 默认的值
 */
@property (copy, nonatomic) NSString *defaultDesc;

@end

@implementation THScrollChooseView


static NSInteger recordRowOfQuestion;


- (instancetype)initWithQuestionArray:(NSArray *)questionArray withDefaultDesc:(NSString *)defaultDesc {
    
    if (self = [super init]) {
        
        self.questionArray = questionArray;
        self.defaultDesc = defaultDesc;
        [self setupSubView];
    }
    
    return self;
}

- (void)setupSubView{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    self.frame = CGRectMake(0, 0, THScreenW, THScreenH);
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 220 - THfloat(45), CGRectGetWidth(self.frame), 220+THfloat(45))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    //按钮所在区域
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0,0,THScreenW,THfloat(45))];
    [viewBg setBackgroundColor:[UIColor whiteColor]];
    [whiteView addSubview:viewBg];
    
    //创建取消 确定按钮
    UIButton *cannel = [UIButton buttonWithType:UIButtonTypeCustom];
    cannel.frame = CGRectMake(THfloat(20), 0, THfloat(50), THfloat(45));
    [cannel setTitle:@"取消" forState:0];
    cannel.titleLabel.font = [UIFont systemFontOfSize:THfloat(16)];
    [cannel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    cannel.tag = 1;
    [cannel addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:cannel];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame = CGRectMake(THScreenW - THfloat(70), 0, THfloat(50), THfloat(45));
    [confirm setTitle:@"确定" forState:0];
    confirm.titleLabel.font = [UIFont systemFontOfSize:THfloat(16)];
    [confirm setTitleColor:project_main_blue forState:UIControlStateNormal];
    confirm.tag = 2;
    [confirm addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:confirm];
    
    UIView *lineV = [UIButton buttonWithType:UIButtonTypeCustom];
    lineV.frame = CGRectMake(10, THfloat(45)+4, THScreenW- 20, THfloat(1));
    lineV.backgroundColor = project_line_gray;
    [viewBg addSubview:lineV];
    
    UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,THScreenW , THfloat(45))];
    // Setup label properties - frame, font, colors etc
    //adjustsFontSizeToFitWidth property to YES
    [pickerLabel setTextColor:UIColorFromRGB(0x6b6b6b)];
    pickerLabel.adjustsFontSizeToFitWidth = YES;
    [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    [pickerLabel setFont:fontSize_15];
    pickerLabel.text = @"请选择确定的单元";
    [whiteView addSubview:pickerLabel];
    
    
    CGFloat y = self.pickerView.frame.size.height/2 - THfloat(40)/2 +CGRectGetMaxY(lineV.frame)-5;
    UIView * selectedBgV = [[UIView alloc]initWithFrame:CGRectMake(0, y, THScreenW,  THfloat(40))];
    selectedBgV.backgroundColor = UIColorFromRGB(0xC3DBF9);
    [whiteView addSubview:selectedBgV];
    
    [whiteView addSubview:self.pickerView];
    

}

- (void)clearSpearatorLine
{
    [self.pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}


#pragma mark - action

- (void)cancelButtonAction:(UIButton *)button {
    
    [self dismissView];
    
}

- (void)confirmButtonAction:(UIButton *)button {
    
    self.confirmBlock(self.selectedValue);
    
    [self dismissView];
}

- (void)showView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}


#pragma mark - pickerView 代理方法

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.questionArray.count;
}

-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component {
    return THfloat(35);
}

// 显示什么
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.questionArray[row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
     [self clearSpearatorLine];
    /*重新定义row 的UILabel*/
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel){

        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setTextColor:UIColorFromRGB(0x6b6b6b)];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor: [UIColor clearColor]];
        [pickerLabel setFont:fontSize_15];

    }
//    if (row == self.selectedValue) {
//        [pickerLabel setBackgroundColor:UIColorFromRGB(0xC3DBF9)];
//    }else{
//         [pickerLabel setBackgroundColor: [UIColor clearColor]];
//    }
     pickerLabel.text = self.questionArray[row];
    
    return pickerLabel;
}
// 选中时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedValue = row;
//    [self.pickerView reloadAllComponents];
}


- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, THfloat(45), THScreenW, THfloat(220))];
        _pickerView.backgroundColor = [UIColor clearColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        // _pickerView 初始化显示的值
        if (self.defaultDesc.length == 0) {
            //无默认值时显示第一个
            [_pickerView selectRow:0 inComponent:0 animated:YES];
            
        }else {
            //有默认值时显示默认值
            recordRowOfQuestion = [self rowOfQuestionWithName:self.defaultDesc];
            [_pickerView selectRow:recordRowOfQuestion inComponent:0 animated:YES];
            self.selectedValue = recordRowOfQuestion;
            
        }
    }
    return _pickerView;
}


- (NSInteger)rowOfQuestionWithName:(NSString *)questionName{
    
    NSInteger row = 0;
    for (NSString *str in self.questionArray) {
        if ([str containsString:self.defaultDesc]) {
            return row;
        }
        row++;
    }
    return row;
}




@end
