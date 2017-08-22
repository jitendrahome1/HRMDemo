//
//  HRMContentBaseViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMContentBaseViewController.h"

@interface HRMContentBaseViewController ()

@end

@implementation HRMContentBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [HRMNavigationalHelper sharedInstance].baseViewController=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ContentNavigationControllerEmbedSegue"])
    {
        [HRMNavigationalHelper sharedInstance].contentNavController = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"ContentHeaderBarEmbedSegue"])
    {
        [HRMNavigationalHelper sharedInstance].headerViewController = segue.destinationViewController;
    }
  
}

@end
