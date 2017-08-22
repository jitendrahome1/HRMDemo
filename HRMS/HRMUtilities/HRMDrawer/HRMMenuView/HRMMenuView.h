//
//  HRMMenuView.h
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRMMenuItemViewCell.h"

@protocol HRMMenuViewDelegate <NSObject>

-(void)listView:(NSArray *)listArray indexPath:(NSIndexPath *)indexPath;

@end

@interface HRMMenuView : UIView <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listView;

@property (nonatomic, readwrite, getter=isAnimating) BOOL animating;
@property (nonatomic, weak) id <HRMMenuViewDelegate> delegate;

@end
