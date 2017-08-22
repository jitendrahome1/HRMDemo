//
//  HRMReimbursementAddCell.m
//  
//
//  Created by Priyam Dutta on 13/10/15.
//
//

#import "HRMReimbursementAddCell.h"

@implementation HRMReimbursementAddCell

-(void)setDataSource:(id)dataSource
{
    _dataSource = dataSource;
    _imgAttached.image = dataSource;
}


-(IBAction)showImagePicker:(id)sender
{
    if (_imageHandler)
    {
        _imageHandler();
    }
}

@end
