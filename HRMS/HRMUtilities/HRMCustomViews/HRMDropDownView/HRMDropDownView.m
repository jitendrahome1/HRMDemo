//
//  HRMDropDownView.m
//  HRMS
//
//  Created by Jitendra Agarwal on 06/10/15.
//  Copyright © 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMDropDownView.h"

#define FONT_SIZE 25.0f
#define FONT_NAME @"FuturaBT-Book"

@implementation HRMDropDownView
@synthesize arrOfData;

-(void)awakeFromNib
{
    arrOfData = [[NSArray alloc]initWithObjects:@"abc",@"dsjhjsd",@"dfgdhf", nil];
    self.tblDropDown.layer.cornerRadius = 5.0;
}

- (id)initWithFrame:(CGRect)rect {
    self = [super initWithFrame:rect];
    self = [[[NSBundle mainBundle] loadNibNamed:@"HRMDropDownView" owner:self options:nil] objectAtIndex:0];
    self.frame  = rect;
    return self;
}

#pragma mark -
#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOfData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [arrOfData objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id superCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UITableView *cell = (UITableView*)superCell;
    return  cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [arrOfData objectAtIndex:indexPath.row];
    [self.delegate HRMViewControllerDoneAction:str];
    [self.delegate HRMViewControllerDismiss];
}

@end