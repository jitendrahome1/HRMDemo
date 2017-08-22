//
//  HRMAPIHandler.m
//  HRMS
//
//  Created by Priyam Dutta on 18/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMAPIHandler.h"

static HRMAPIHandler *handler = nil;

@implementation HRMAPIHandler

+(instancetype)handler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [HRMAPIHandler new];
    });
    return handler;
}

#pragma mark - Login & Logout

-(void)loginWithCompanyName:(NSString *)companyID userName:(NSString *)userName password:(NSString *)password WithSuccess:(void(^)(NSDictionary *responseDict))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"companyName": companyID,
                                 @"username": userName,
                                 @"password": password,
                                 @"isOfficer": IS_IPAD ? @"1" : @"0",
                                 @"deviceToken": OBJ_FOR_KEY(kDeviceToken),
                                 @"deviceType": @"IOS"
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:LOGIN parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    success(responseObject);
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)logoutWithSuccess:(void(^)(NSDictionary *responseDict))success failure:(void(^)(NSError *error))failure
{
    NSDictionary *parameters = @{};
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:LOG_OUT parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    success(responseObject);
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark - Get Access Permit

-(void)getAccessPermitWithLoader:(BOOL)show WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{};
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_ACCESS_PERMIT withLoader:show parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    success(responseObject); //[HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark - Password

-(void)forgotPasswordWithCompanyName:(NSString *)companyName andEmail:(NSString *)email withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"companyName" : companyName,
                                 @"email" : email
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:FORGOT_PASSWORD parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)updatePasswordWithCurrentPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"oldpassword" : oldPassword,
                                 @"newpassword" : newPassword
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:UPDATE_PASSWORD parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark - Employee List

-(void)getEmployeeListWithPageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber andSearchText:(NSString *)searchText withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"pageCount" : pageCount,
                                 @"pageNumber" : pageNumber,
                                 @"searchText": searchText
                                 };

    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_EMPLOYEE_LIST withLoader:[pageNumber integerValue] == 1 ? YES : NO parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                 [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark - Notification

-(void)getNotificationWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"isOfficer" : IS_IPAD ? @"1" : @"0"
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_NOTIFICATION parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark- Interview

-(void)getInterviewListWithPageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"pageCount": pageCount,
                                 @"pageNumber": pageNumber,
                                 @"searchText": searchText
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:INTERVIEW_LIST withLoader:[pageNumber integerValue] == 1 ? YES : NO parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getDepartmentsForInterviewWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{ };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_DEPARTMENTS parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getInterviewerWithID:(NSString *)departmentID WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"departmentid": departmentID
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:INTERVIEWER_LIST parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                   success(responseObject); // [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)addInterviewWithInterviewId:(NSString *)interviewId interviewerId:(NSString *)interviewerId date:(NSString *)date time:(NSString *)time name:(NSString *)name email:(NSString *)email mobile:(NSString *)mobile interviewType:(NSString *)interviewType department:(NSString *)department position:(NSString *)position experience:(NSString *)experience currentPackage:(NSString *)currentPackage currentEmployer:(NSString *)currentEmployer noticePeriod:(NSString *)notice status:(NSString *)status WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"interviewid": interviewId,
                                 @"interviewerid": interviewerId,
                                 @"date": date,
                                 @"time": time,
                                 @"name": name,
                                 @"email": email,
                                 @"mobile": mobile,
                                 @"interviewType": interviewType,
                                 @"department": department,
                                 @"positionApplied": position,
                                 @"experience": experience,
                                 @"currentPackage": currentPackage,
                                 @"currentEmployer": currentEmployer,
                                 @"noticePeriod": notice,
                                 @"status": status
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:INTERVIEW_ADD parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark - Timesheet

-(void)getAllEmployeeTimesheetWithEmpID:(NSString *)employeeid department:(NSString *)department month:(NSString *)month year:(NSString *)year pageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
        NSDictionary *parameters = @{@"employeeid":employeeid,     // string may be optional
                                                        @"department" :department,       // string may be optional
                                                        @"month" :month,
                                                        @"year" : year,
                                                        @"pageCount":pageCount,
                                                        @"pageNumber":pageNumber,
                                                        @"searchText":searchText
                                                        };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:EMPLOYEE_TIMESHEET withLoader:[pageNumber integerValue] == 1 ? YES : NO parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                       [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
    
}

-(void)getEmployeeTimesheetCorrection:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"pageCount":pageCount,
                                 @"pageNumber":pageNumber,
                                 @"searchText":searchText
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:EMPLOYEE_TIMESHEET_CORRECTION withLoader:[pageNumber integerValue] == 1 ? YES : NO parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {     [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)saveTimesheetCorrectionWithTimesheetReqID:(NSString *)timesheetReqID clockTime:(NSString *)clockTime location:(NSString *)location withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"timesheetReqID":timesheetReqID,
                                                    @"clockTime":clockTime,
                                                    @"location":location
                                                     };
    

    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:EMPLOYEE_TIMESHEET_SAVE_CORRECTON parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                   [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getEmployeeTimesheetListingWithPageCount:(NSString *)pageCount andPageNumber:(NSString *)pageNumber WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"pageCount": pageCount,
                                 @"pageNumber": pageNumber
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:EMPLOYEE_TIMSHEET_LISTING withLoader:[pageNumber integerValue] == 1 ? YES : NO
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)requestEmployeeTimesheetCorrectionWithTimsheetId:(NSString *)timesheetId andRequest:(NSString *)request WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"timesheetid": timesheetId,
                                 @"request": request
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:EMPLOYEE_REQUEST_CORRECTION
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)addTimesheetWithProjectId:(NSString *)projectId date:(NSString *)date time:(NSString *)time clockType:(NSString *)clockType location:(NSString *)location andImage:(NSData *)image WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"project": projectId ? projectId : @"",
                                 @"date": date,
                                 @"clockTime": time,
                                 @"location": location,
                                 @"clockType": clockType
                                 };
    
        [[HRMManager manager] POST:EMPLOYEE_ADD_TIMESHEET parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if(image)
                [formData appendPartWithFileData:image name:@"image" fileName:@"MyPhoto.png" mimeType:@"image/png"];
            
        }  success:^(NSURLSessionDataTask *task, id responseObject){
            switch ([responseObject[@"responsecode"] integerValue]) {
                case 200:
                {
                    success(responseObject);
                }
                    break;
                default:
                {
                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                }
                    break;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            failure(error);
        }];
}

#pragma mark - Leave

-(void)getLeaveTypeListWithYear:(NSString *)leaveYear WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"leaveYear": leaveYear
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:EMPLOYEE_LEAVE_TYPE
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getAOROListWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{};
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:LEAVE_RO_AO_LIST
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)applyLeaveWithLeaveTypeId:(NSString *)leaveId fromDate:(NSString *)fromDate toDate:(NSString *)toDate duration:(NSString *)duration roId:(NSString *)roId aoId:(NSString *)aoId ccPerson:(NSString *)ccPerson isMorning:(NSString *)isMorning address:(NSString *)address reason:(NSString *)reason WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"leaveTypeId": leaveId,
                                 @"fromDate": fromDate,
                                 @"toDate": toDate,
                                 @"leaveDuration": duration,
                                 @"roId": roId,
                                 @"aoId": aoId,
                                 @"ccPerson": ccPerson,
                                 @"isMorning": isMorning,
                                 @"address": address,
                                 @"reason": reason
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:APPLY_LEAVE
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getEmployeeLeaveListWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{};
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_EMPLOYEE_LEAVES
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getLeaveListOfficialWithEmployeeId:(NSString *)employeeId pageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"employeeid": employeeId,
                                 @"pageCount": pageCount,
                                 @"pageNumber": pageNumber,
                                 @"searchText": searchText
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_LEAVES_OFFICIAL
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
//                                       success(responseObject);
                                   [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)leaveApproveOrRejectWithLeaveID:(NSString *)leaveID leaveAction:(NSString *)leaveAction WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"leaveid": leaveID,
                                                @"action": leaveAction        // if(Action 0 rejected and Action 1  approved).
                                                };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:APPROVE_OR_REJECT_LEAVE
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark - Reimbursement

-(void)getBenifitsTypeAndOfficerWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{};
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_BENEFITS_OFFICER
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getEmployeeReimbursementListWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{};
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_EMPLOYEE_REIMBURSEMENT
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)applyEmployeeReimbursementWithOfficerID:(NSString *)officerID incurredDate:(NSString *)incurredDate amount:(NSString *)amount description:(NSString *)description fileImage:(NSData *)fileImage submissionDate:(NSString *)submissionDate benefitId:(NSString *)benefitId  WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"officerId": officerID,
                                                @"incurredDate": incurredDate,
                                                @"amount": amount,
                                                @"submissionDate":submissionDate,
                                                @"benefitId":benefitId,
                                                @"description":description
                                                };
    
    [[HRMManager manager] POST:APPLY_EMPLOYEE_REIMBURSEMENT parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        

        if(fileImage)
            [formData appendPartWithFileData:fileImage name:@"fileImage" fileName:@"ReimbursementImage.jpg" mimeType:@"image/jpg"];
        
    }  success:^(NSURLSessionDataTask *task, id responseObject){
        switch ([responseObject[@"responsecode"] integerValue]) {
            case 200:
            {
                success(responseObject);
            }
                break;
            default:
            {
                success(responseObject); //[HRMToast showWithMessage:responseObject[@"responsedetails"]];
            }
                break;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        failure(error);
    }];
}

-(void)getReimbursementListOfficialWithPageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText employeeId:(NSString *)employeeId WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"pageCount": pageCount,
                                 @"pageNumber": pageNumber,
                                 @"searchText": searchText,
                                 @"employeeid": employeeId
                                 };

    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_OFFICIAL_REIMBURSEMENT
                        withLoader:[pageNumber integerValue] == 1 ? YES : NO
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)reimbursementApproveOrRejectWithReimbursementID:(NSString *)reimburseID leaveAction:(NSString *)reimburseAction WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"reimbursementid": reimburseID,
                                 @"action": reimburseAction
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:APPROVE_OR_REJECT_REIMBURSEMENT
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

#pragma mark - Payroll

-(void)salaryProgressListEmployeeID:(NSString *)employeeID WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"employeeID": employeeID
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:SALARRY_PROGRESS
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)getReasonForIncreamentWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{};
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:INCREAMENT_REASON
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}

-(void)increamentedSalaryForemployeeID:(NSString *)employeeID date:(NSString *)date amount:(NSString *)amount reason:(NSString *)reason andDescription:(NSString *)description WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"employeeID": employeeID,
                                 @"Date": date,
                                 @"Amount": amount,
                                 @"Reason": reason,
                                 @"Desc": description
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:ADD_INCREAMENT
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
}
-(void)getAppraisalListWithEmployeeid:(NSString *)employeeid pageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    NSDictionary *parameters = @{@"pageCount": pageCount,
                                 @"pageNumber": pageNumber,
                                 @"searchText": searchText,
                                 @"employeeid": employeeid
                                 };
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_APPRAISALS_LIST
                        withLoader:[pageNumber integerValue] == 1 ? YES : NO
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
    
}
#pragma mark- verified PaySlipPin
-(void)paySlipPinVerifiedWithPin:(NSString *)paySlipPin WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure

{
        NSDictionary *parameters = @{@"pin": paySlipPin,
                               };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:PAYSLIP_PIN
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
    
}

#pragma mark:- Get Payslip
-(void)getGetPayslipWithMothAndYear:(NSString *)month year:(NSString *)year WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *parameters = @{@"month": month,
                                 @"year": year,
                                 };
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {
        [[HRMManager manager] POST:GET_PAYSLIP_EMPLOYEE
                        parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject){
                            switch ([responseObject[@"responsecode"] integerValue]) {
                                case 200:
                                {
                                    success(responseObject);
                                }
                                    break;
                                default:
                                {
                                    [HRMToast showWithMessage:responseObject[@"responsedetails"]];
                                }
                                    break;
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error){
                            failure(error);
                        }];
    }else [HRMToast showWithMessage:NO_NETWORK];
    
}



@end
