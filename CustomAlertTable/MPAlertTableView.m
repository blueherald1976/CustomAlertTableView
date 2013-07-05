//
//  MPAlertTableView.m
//  CustomAlert
//
//  Created by blueherald on 13. 7. 4..
//  see :: http://iosdevtricks.blogspot.kr/2013/04/creating-custom-alert-view-for-iphone.html
//  copy from :: https://github.com/marichka/Custom-Alert-View
//

#import "MPAlertTableView.h"
#import <QuartzCore/QuartzCore.h>

#define MAX_ALERT_HEIGHT (260.0)
#define BTN_TAG_BASE     (0x1000)

#define BTN_1ST_X        (14.0)
#define BTN_GAP          (5.0)

#define MY_TITLE_LABEL_H (52.0)
//#define MY_TABLE_CELL_HEIGHT (36.0)

@interface MPAlertTableView () <UITableViewDelegate, UITableViewDataSource>
{
    //    id delegate;
    UIView *_alertViewWithTable;
    ///////////////////////////////////////
    NSArray *data;
}
@property(nonatomic, assign) id<MPAlertTableViewDelegate> caller;
@property(nonatomic, retain) NSArray             *data;
@property(nonatomic, retain) NSMutableDictionary *tableSelectedRowIndexs;
@end

@implementation MPAlertTableView

@synthesize  selectionType;
@synthesize  caller, data;
@synthesize  tableSelectedRowIndexs;
//@synthesize  mp_tableView;
//@synthesize  mp_buttons;

//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    self.data = nil;
    self.caller = nil;
    
    if(tableSelectedRowIndexs)
        [tableSelectedRowIndexs release];
    
    [super dealloc];
}

- (id) initWithCaller:(id<MPAlertTableViewDelegate>)_caller title:(NSString*)_title
      tableDataSource:(NSArray*)_tableDataArray
tableSelectedRowIndexs:(NSArray*)_tableSelectedRowIndexs buttonTitles:(NSArray*)buttonTitles
{
    CGRect frame;
    UIInterfaceOrientation orient = [[UIApplication sharedApplication] statusBarOrientation];
    if (orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight)
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    else
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width,  [[UIScreen mainScreen] bounds].size.height);
    
    self = [super initWithFrame:frame];
    if(!self)
        return self;
    
    self.caller         = _caller;
    self.data           = _tableDataArray;
    self.tableSelectedRowIndexs    = nil;
    self.selectionType  = ATV_SELECTION_TYPE_SINGLE; // default
    
    int data_cnt = 0x00;
    if(_tableDataArray) data_cnt = [_tableDataArray count];

    if(data_cnt > 0)
    {
        self.tableSelectedRowIndexs = [NSMutableDictionary dictionary];
        for(int idx=0x00; idx<data_cnt; idx++)
        {
            NSNumber *num = [NSNumber numberWithInt:idx];
            [tableSelectedRowIndexs setObject:[NSNumber numberWithBool:FALSE] forKey:num];
        }
        
        if(_tableSelectedRowIndexs)
        {   // _selIdxs가 있으면 배열의 값을 설정함.
            for(id num in _tableSelectedRowIndexs)
            {
                NSNumber *insert_num = nil;
                int sel_idx;
                if([num isKindOfClass:[NSNumber class]])
                {
                    sel_idx    = [num intValue];
                    insert_num = num;
                }
                else if([num isKindOfClass:[NSString class]])
                {
                    sel_idx = [((NSString *)num) intValue];
                    insert_num = [NSNumber numberWithInt:sel_idx];
                }
                else
                    sel_idx = -1;
                
                if(insert_num && (sel_idx >= 0x00) && (sel_idx < data_cnt))
                    [tableSelectedRowIndexs setObject:[NSNumber numberWithBool:TRUE] forKey:insert_num];
            }
        }
    }
    
    //self.delegate = AlertDelegate;
    self.alpha = 0.95;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *_alertBg = [UIImage imageNamed:@"alert_bg.png"];
    
    if ([_alertBg respondsToSelector:@selector(resizableImageWithCapInsets:)])
        _alertBg = [[UIImage imageNamed: @"alert_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 25.0, 25.0, 25.0)];
    else
        _alertBg = [[UIImage imageNamed: @"alert_bg.png"] stretchableImageWithLeftCapWidth: 25 topCapHeight: 40];
    
    
    UIImage     *_cancelBtnImg = [UIImage imageNamed:@"cancel_btn.png"];
    UIImageView *_alertImgView = [[UIImageView alloc] initWithImage:_alertBg];
    
    float alert_width = _alertImgView.frame.size.width;
    float alert_height = 5.0;
    
    //add text
    UILabel *_titleLbl = nil;
    //UIScrollView *MsgScrollView;
    
    // title
    if (_title)
    {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, alert_height, alert_width-20.0, MY_TITLE_LABEL_H)];
        _titleLbl.adjustsFontSizeToFitWidth = YES;

        _titleLbl.numberOfLines = 0;
        _titleLbl.lineBreakMode = UILineBreakModeWordWrap;
        
        _titleLbl.font = [UIFont boldSystemFontOfSize:15.0];
        _titleLbl.textAlignment = UITextAlignmentCenter;
        _titleLbl.minimumFontSize = 12.0;
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.text = _title;
        
        alert_height += _titleLbl.frame.size.height + 5.0;
    }
    else
    {
        alert_height += 15.0;
    }
    
    UITableView *_tableView = nil;
    if(data_cnt)
    {
        float max_table_height = MAX_ALERT_HEIGHT - alert_height - _cancelBtnImg.size.height;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0, alert_height, alert_width-20.0, max_table_height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView.layer setCornerRadius:5.0f];
        
        alert_height += _tableView.frame.size.height + 5.0; // 15.0;
    }
    
    //add buttons
    NSMutableArray *btn_array  = [NSMutableArray array];
    if(buttonTitles)
    {
        int btn_count = [buttonTitles count];
        float x_displ = (int)((alert_width-_cancelBtnImg.size.width*btn_count)/(btn_count+0x01));
        CGFloat width = _cancelBtnImg.size.width;
              
        if(x_displ < BTN_1ST_X)
        {
            x_displ = BTN_1ST_X;
            width = (alert_width - (BTN_1ST_X*0x02) - (BTN_GAP * (btn_count - 0x01))) / btn_count;
        }
        
        if(btn_count == 0x01)
        {
            x_displ = BTN_1ST_X;
            width = alert_width - (BTN_1ST_X*0x02);
        }

        UIButton  *_cancelBtn = nil;
        int       i          = 0x00;
        for(NSString *btn_title in buttonTitles)
        {
            _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(x_displ + (width + BTN_GAP)*i, alert_height, width, _cancelBtnImg.size.height)];
            [_cancelBtn setTag:BTN_TAG_BASE + i++];
            [_cancelBtn setTitle:btn_title forState:UIControlStateNormal];
            [_cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            
            [_cancelBtn setBackgroundImage:_cancelBtnImg forState:UIControlStateNormal];
            [_cancelBtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn_array addObject:_cancelBtn];
        }
        
        if(i && _cancelBtn)
        {
            alert_height += _cancelBtn.frame.size.height + 15.0;
        }
    }
    
    //add background
    _alertViewWithTable = [[UIView alloc] initWithFrame:CGRectMake((int)((self.frame.size.width-alert_width)/2.0), (int)((self.frame.size.height-alert_height)/2.0 + 0x05), alert_width, alert_height)];
    _alertViewWithTable.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
                                           UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    _alertImgView.frame = _alertViewWithTable.bounds;
    [_alertViewWithTable addSubview:_alertImgView];
    
    [self addSubview:_alertViewWithTable];
    
    if (_titleLbl)
        [_alertViewWithTable addSubview:_titleLbl];
    
    if(_tableView)
        [_alertViewWithTable addSubview:_tableView];
    
    for(UIButton *btn in btn_array)
        [_alertViewWithTable addSubview:btn];
    
    return self;
}

- (void)showInView:(UIView*)view
{
    if ([view isKindOfClass:[UIView class]])
    {
        [view addSubview:self];
        [self animateShow];
    }
}


- (void)onBtnPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    int button_index = button.tag-BTN_TAG_BASE;
#ifdef DEBUG
    NSLog(@"selected btn idx : %d", button_index);
#endif
    
    if (caller && [(NSObject *)caller respondsToSelector:@selector(didSelectedButtonIndex:withSelectedTableRowIndexArray:)])
    {
        NSMutableArray *selArray = [NSMutableArray array];
        if(tableSelectedRowIndexs)
        {

            int idx = 0x00;
            
            NSArray *key_list = [tableSelectedRowIndexs allKeys];
            for(NSNumber *key in key_list)
            {
                BOOL yesNo = [[tableSelectedRowIndexs objectForKey:key] boolValue];
                if(yesNo)
                    [selArray addObject:[NSNumber numberWithInt:idx]];
                idx++;
            }
        }
        [caller didSelectedButtonIndex:button_index withSelectedTableRowIndexArray:selArray];
    }
    caller = nil;
    [self animateHide];
}

#pragma mark AlertTableView ShowHide relate code

- (void)animateHide
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.0, 0.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.2;
    
    [_alertViewWithTable.layer addAnimation:animation forKey:@"hide"];
    
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:0.105];
}

- (void)animateShow
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.2;
    
    [_alertViewWithTable.layer addAnimation:animation forKey:@"show"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark UITableView relate code
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return MY_TABLE_CELL_HEIGHT;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"ABC"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ABC"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    if(data)
        cell.textLabel.text = [[data objectAtIndex:indexPath.row] description];
    else
        cell.textLabel.text = @"";
    
    if(tableSelectedRowIndexs)
    {
        NSNumber *num = [NSNumber numberWithInteger:indexPath.row];
        if(tableSelectedRowIndexs && [[tableSelectedRowIndexs objectForKey:num] boolValue])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(self.selectionType == ATV_SELECTION_TYPE_NORMAL)
    {
        if (caller && [(NSObject *)caller respondsToSelector:@selector(didSelectedButtonIndex:withSelectedTableRowIndexArray:)])
        {
            NSArray *selArray = [NSArray arrayWithObject:[NSNumber numberWithInteger:indexPath.row]];
            [caller didSelectedButtonIndex:(-1) withSelectedTableRowIndexArray:selArray];
        }
        
        caller = nil;
        [self animateHide];
        return;
    }
    else if(self.selectionType == ATV_SELECTION_TYPE_MULTI)
    {
        // toggle value.
        if(tableSelectedRowIndexs)
        {
            NSNumber *num   = [NSNumber numberWithInteger:indexPath.row];
            BOOL checkOrNot = ![[tableSelectedRowIndexs objectForKey:num] boolValue];
            [tableSelectedRowIndexs setObject:[NSNumber numberWithBool:checkOrNot] forKey:num];
        }
        
        if( cell.accessoryType == UITableViewCellAccessoryNone )
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if(data && tableSelectedRowIndexs)
        {
            NSNumber *num   = [NSNumber numberWithInteger:indexPath.row];
            [tableSelectedRowIndexs setObject:[NSNumber numberWithBool:TRUE] forKey:num];
            int cnt = [data count];
            for(int i=0; i<cnt; i++)
            {
                NSNumber *reset_num = [NSNumber numberWithInt:i];
                BOOL yesNo = [[tableSelectedRowIndexs objectForKey:reset_num] boolValue];
                if(yesNo && (i != indexPath.row))
                {
                    [tableSelectedRowIndexs setObject:[NSNumber numberWithBool:FALSE] forKey:reset_num];
                    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

@end
