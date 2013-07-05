//
//  MPAlertTableView.h
//  CustomAlert
//
//  Created by blueherald on 13. 7. 4..
//  see :: http://iosdevtricks.blogspot.kr/2013/04/creating-custom-alert-view-for-iphone.html
//  copy from :: https://github.com/marichka/Custom-Alert-View
//

#import <UIKit/UIKit.h>

typedef enum _ATV_SELECTION_TYPE
{
    ATV_SELECTION_TYPE_NORMAL = 0,
    ATV_SELECTION_TYPE_SINGLE = 1,
	ATV_SELECTION_TYPE_MULTI  = 2
} ATV_SELECTION_TYPE;

@protocol MPAlertTableViewDelegate
- (void) didSelectedButtonIndex:(NSInteger)btnIdx withSelectedTableRowIndexArray:(NSArray *)array;
@end

@interface MPAlertTableView : UIView
{
    ATV_SELECTION_TYPE selectionType;
}

- (id) initWithCaller:(id<MPAlertTableViewDelegate>)_caller title:(NSString*)_title
      tableDataSource:(NSArray*)_tableDataArray
tableSelectedRowIndexs:(NSArray*)_tableSelectedRowIndexs buttonTitles:(NSArray*)buttonTitles;

- (void) showInView:(UIView*)view;
@property(nonatomic, assign) ATV_SELECTION_TYPE selectionType;

@end
