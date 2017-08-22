//
//  HRMMenuView.m
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMMenuView.h"

@interface HRMMenuView ()
{
    NSArray *arrList;
}
@end

@implementation HRMMenuView

NSInteger selectedRow;

-(void)awakeFromNib
{
    [self addArrayItems];
}

-(void)dealloc
{
    [self.listView removeFromSuperview];
    self.listView = nil;
}

-(void)addArrayItems
{
    if (IS_IPAD)
    {
        arrList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HRMOfficialMenu" ofType:@"plist"]];
    }
    else
    {
        arrList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HRMEmployeeMenu" ofType:@"plist"]];
    }
    _animating = NO;
    [HRMHelper sharedInstance].arrMenuInfo = arrList;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRMMenuItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HRMMenuItemViewCell class])];
    
    if (cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:[[HRMHelper sharedInstance] getNIBNameForOriginalNIBName:NSStringFromClass([HRMMenuItemViewCell class])] owner:self options:nil];
        for (id item in arr) {
            if ([item isKindOfClass:[HRMMenuItemViewCell class]]) {
                cell = item;
            }
        }
    }
    [cell.imageLogo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.labelTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [cell setDatasource:arrList[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    if (selectedRow == indexPath.row)
    //        cell.contentView.backgroundColor=[UIColor colorWithRed:13.0/255 green:28.0/255 blue:57.0/255 alpha:1];
    //    else
    //        cell.contentView.backgroundColor=[UIColor colorWithRed:18.0/255 green:41.0/255 blue:83.0/255 alpha:1];
    
    return cell;
}

#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPAD ? 77 : 50;
}

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //1. Setup the CATransform structure
    if (_animating == YES) {
        if (indexPath.section ==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self toggleTableCellAnimation];
            });
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == arrList.count - 1) {
        // selectedRow = 0;
    }
    else
        selectedRow = indexPath.row;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(listView:indexPath:)])
    {
        [self.delegate listView:arrList indexPath:indexPath];
    }
}

/**
 Starting table cell animation
 */
-(void)toggleTableCellAnimation
{
    for (int i = 0; i < [arrList count]; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        HRMMenuItemViewCell *cell = (HRMMenuItemViewCell*)[self.listView cellForRowAtIndexPath:indexPath];
        
        cell.imageLogo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        cell.labelTitle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.02+(0.06*i)) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //cell.contentView.hidden = FALSE;
            [UIView animateWithDuration:0.2 animations:^{
                cell.imageLogo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                cell.labelTitle.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 animations:^{
                    cell.imageLogo.transform = CGAffineTransformIdentity;
                    cell.labelTitle.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    
                }];
            }];
            
            if (indexPath.row == [arrList count]-1) {
                self.animating = NO;
            }
        });
    }
}

@end
