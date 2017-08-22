//
//  HRMAddTimesheetViewController.m
//  HRMS
//
//  Created by Priyam Dutta on 07/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMAddTimesheetViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HRMPicker.h"

@interface HRMAddTimesheetViewController ()
{
    AVCaptureSession *session;
    AVCaptureStillImageOutput *stillImageOutput;
    NSDictionary *rules;
    NSData *imageData;
    NSString *projectId;
    NSDate *time;
}
@end

@implementation HRMAddTimesheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rules = [NSDictionary dictionary];
    rules = [HRMHelper sharedInstance].dataDictionary;
    [self ruleSetup];
//    [self openCamera];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HRMNavigationalHelper sharedInstance].headerViewController.lblHeaderTitle.text = ADD_TIMESHEET;
    [[[HRMNavigationalHelper sharedInstance] headerViewController] hideAddButton:YES];
    [[HRMHelper sharedInstance] setBackButton:YES];
    
    if (IS_IPAD) {
        [buttonProject setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(buttonProject.bounds)+480, 0, 0)];
        [buttonDate setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(buttonProject.bounds)+480, 0, 0)];
    }else{
        [buttonProject setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(buttonProject.bounds)+90, 0, 0)];
        [buttonDate setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(buttonProject.bounds)+90, 0, 0)];
    }
    
    buttonProject.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
    buttonProject.layer.borderWidth = 1.0;
    [buttonProject addTarget:self action:@selector(actionShowProjects:) forControlEvents:UIControlEventTouchUpInside];
    [buttonTakePhoto addTarget:self action:@selector(actionCaptureImage:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)ruleSetup{
    
    // Allow clock In Out
    if (![rules[@"clockType"] boolValue]) {
        [buttonOutTime setBackgroundColor:[UIColor lightGrayColor]];
        [buttonOutTime setUserInteractionEnabled:NO];
    }else{
        [buttonInTime setBackgroundColor:[UIColor lightGrayColor]];
        [buttonInTime setUserInteractionEnabled:NO];
    }
    // Allow Edit Date
    if ([rules[@"editDiffDate"] boolValue]) {
        buttonDate.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
        buttonDate.layer.borderWidth = 1.0;
        [buttonDate addTarget:self action:@selector(actionShowDate:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [buttonDate setBackgroundColor:[UIColor clearColor]];
        [buttonDate setUserInteractionEnabled:NO];
    }
    [buttonDate setTitle:[[NSDate date] stringFromDateWithFormat:@"dd.MM.yyyy"] forState:UIControlStateNormal];
    // Allow Edit Time
    if ([rules[@"editTime"] boolValue]) {
        [buttonCurrentTime setBackgroundColor:[UIColor whiteColor]];
        buttonCurrentTime.layer.borderColor = UIColorRGB(233.0, 233.0, 233.0, 1.0).CGColor;
        buttonCurrentTime.layer.borderWidth = 1.0;
        [buttonCurrentTime addTarget:self action:@selector(actionShowTime:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [buttonCurrentTime setBackgroundColor:[UIColor clearColor]];
        [buttonCurrentTime setUserInteractionEnabled:NO];
    }
    [buttonCurrentTime setTitle:[[NSDate date] stringFromDateWithFormat:@"hh:mm a"] forState:UIControlStateNormal];
    time = [NSDate date];
    // Allow Location Trace
    if (![rules[@"enableGPS"] boolValue]) {
        [[HRMSLocationHandler handler] requestAndStartLocationManager];
    }
    // Project Selection
    if ([rules[@"projects"] count] > 0) {
        [buttonProject setTitle:[rules[@"projects"] objectAtIndex:0][@"projectName"] forState:UIControlStateNormal];
        [buttonProject setUserInteractionEnabled:YES];
        projectId = [rules[@"projects"] objectAtIndex:0][@"projectId"];
    }
    // Enable Project
    if (![rules[@"enableProject"] boolValue]) {
        [buttonProject setBackgroundColor:UIColorRGB(233.0, 233.0, 233.0, 1.0)];
        [buttonProject setEnabled:NO];
    }
}

#pragma mark - AVCaptureSession

-(void)openCamera{
    // Start Session
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.frame = imageCamera.bounds;
    [imageCamera.layer addSublayer:captureVideoPreviewLayer];
    // Alloc Device
    AVCaptureDevice *device = [self frontCamera];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    stillImageOutput = [AVCaptureStillImageOutput new];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:stillImageOutput];
    [session addInput:input];
    [session startRunning];
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

-(void)captureImage:(UIButton *)sender{
    if ([session isRunning] && sender.tag == 0) {
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *connection in stillImageOutput.connections) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                    videoConnection = connection;
                    break;
                }
            }
        }
        [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [imageCamera setImage:image];
            [sender setImage:[UIImage imageNamed:@"RetakeCameraB"] forState:UIControlStateNormal];
            [session stopRunning];
        }];
    }else{
        [self openCamera];
        [sender setImage:[UIImage imageNamed:@"CameraB"] forState:UIControlStateNormal];
    }
    [sender setTag:sender.tag == 0 ? 1 : 0];
}

#pragma mark - IBAction

-(IBAction)actionCaptureImage:(UIButton *)sender{
    [[HRMHelper sharedInstance] animateButtonClickedZoom:sender completion:^{
        [self captureImage:sender];
    }];
}

-(IBAction)actionShowDate:(UIButton *)sender{
    [HRMDatePickerView showWithDateWithMaximumDate:^(NSDate *date) {
        [sender setTitle:[date stringFromDateWithFormat:@"dd.MM.yyyy"] forState:UIControlStateNormal];
    } date:[NSDate date] isMax:YES];
}

-(IBAction)actionShowTime:(UIButton *)sender{
    [HRMDatePickerView showWithDate:^(NSDate *date) {
        [sender setTitle:[date stringFromDateWithFormat:@"hh:mm a"] forState:UIControlStateNormal];
        time = date;
    } isTimeMode:YES];
}

-(IBAction)actionShowProjects:(UIButton *)sender
{
    NSMutableArray *arrayProject = [NSMutableArray new];
    [rules[@"projects"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayProject addObject:obj[@"projectName"]];
    }];
    if (arrayProject.count > 0) {
        [HRMPicker showWithArrayWithSelectedIndex:[arrayProject containsObject:sender.titleLabel.text] ? [arrayProject indexOfObject:sender.titleLabel.text] : 0 andArray:[arrayProject mutableCopy] didSelect:^(NSString *data, NSInteger index) {
            [sender setTitle:data forState:UIControlStateNormal];
            projectId = [rules[@"projects"] objectAtIndex:index][@"projectId"];
        }];
    }
}

- (IBAction)actionTime:(UIButton *)sender {
    /**
     *  tag 1 - InTime, tag 2 - OutTime
     */
    if ([session isRunning]) {
        [self captureImage:buttonTakePhoto];
    }
    
    [[HRMAPIHandler handler] addTimesheetWithProjectId:projectId date:buttonDate.titleLabel.text time:[time stringFromDateWithFormat:@"HH:mm:ss"] clockType:sender.tag == 1 ? @"0" : @"1" location:![rules[@"enableGPS"] boolValue] ? [NSString stringWithFormat:@"%@, %@",[HRMSLocationHandler handler].placemark.subLocality, [HRMSLocationHandler handler].placemark.country] : @"" andImage:imageData WithSuccess:^(NSDictionary *responseDict) {
            [HRMToast showWithMessage:ADD_TIMESHEET_SUCCESS];
            [[[HRMNavigationalHelper sharedInstance] contentNavController] popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self captureImage:buttonTakePhoto];
        }];
}

@end
