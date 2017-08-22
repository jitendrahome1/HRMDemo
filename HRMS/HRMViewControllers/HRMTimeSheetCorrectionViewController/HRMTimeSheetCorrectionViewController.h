//
//  HRMTimeSheetCorrectionViewController.h
//  HRMS
//
//  Created by Chinmay Das on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseTableViewController.h"

@interface HRMTimeSheetCorrectionViewController : HRMBaseTableViewController

   @property(nonatomic,strong)NSMutableArray *arrTimeSheetData;
@property (strong, nonatomic) IBOutlet UITableView *tblTimeSheetCorrection;
@end
