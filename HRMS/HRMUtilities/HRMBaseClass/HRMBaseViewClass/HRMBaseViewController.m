//
//  HRMBaseViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 30/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#import "HRMBaseViewController.h"

@interface HRMBaseViewController ()

@end

@implementation HRMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = UIColorRGB(244.0, 244.0, 244.0, 1.0);
    [[HRMHelper sharedInstance] setBackButton:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
