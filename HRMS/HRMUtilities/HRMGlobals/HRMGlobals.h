//
//  HRMGlobals.h
//  HRMS
//
//  Created by Priyam Dutta on 06/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark - FONTS

#define kAddButton              @"Add"
#define kSearchButton           @"Search"
#define kEditButton             @"Edit"
#define kShowSearchBar          @"showSearchBar"
#define kSearchEmployee         @"Search employee name"

#define kBaseUrl                @"http://52.6.251.159/~cwebapp/hrpayroll/api/"
#define kAPIKey                 @"inthrms@apr_2016"
#define kCompanyId              @"companyId"
#define kUserdId                @"userId"
#define kIsLogin                @"isLogin"
#define kAssignPermit           @"assignPermit"
#define kModulePermit           @"modulePermit"
#define kNotificationCount      @"notifyCount"
#define kviewTransform          @"viewTransform"
#define kLoginUserName          @"loginUserName"
#pragma mark - API


// GENERAL
#define LOGIN                                       @"login"
#define UPDATE_PASSWORD                             @"updatepassword"
#define FORGOT_PASSWORD                             @"forgotpassword"
#define GET_ACCESS_PERMIT                           @"getAccess"
#define GET_NOTIFICATION                            @"getnotification"
#define LOG_OUT                                     @"logout"
// EMPLOYEE
#define GET_EMPLOYEE_LIST                           @"getemployeelist"
// INTERVIEW
#define GET_DEPARTMENTS                             @"getDepartments"
#define INTERVIEW_LIST                              @"interviews"
#define INTERVIEWER_LIST                            @"getInterviewer"
#define INTERVIEW_ADD                               @"addInterview"
// TIMESHEET
#define EMPLOYEE_TIMESHEET                          @"getEmployeeTimesheet"
#define EMPLOYEE_TIMESHEET_CORRECTION               @"timesheetcorrectionrequest"
#define EMPLOYEE_TIMESHEET_SAVE_CORRECTON           @"savetimesheetcorrectionrequest"
#define EMPLOYEE_TIMSHEET_LISTING                   @"employeetimesheet"
#define EMPLOYEE_REQUEST_CORRECTION                 @"employeeTimesheetCorrection"
#define EMPLOYEE_ADD_TIMESHEET                      @"employeeAddTimesheet"
// LEAVE
#define EMPLOYEE_LEAVE_TYPE                         @"employeeGetLeaveType"
#define LEAVE_RO_AO_LIST                            @"employeeGetLeaveROAO"
#define APPLY_LEAVE                                 @"employeeApplyLeave"
#define GET_EMPLOYEE_LEAVES                         @"employeeLeaveList"
#define GET_LEAVES_OFFICIAL                         @"leaves"
#define APPROVE_OR_REJECT_LEAVE                     @"actiononleave"
// Reimbursement
#define GET_BENEFITS_OFFICER                        @"getbenefitandofficer"
#define GET_EMPLOYEE_REIMBURSEMENT                  @"employeeReimbursementList"
#define APPLY_EMPLOYEE_REIMBURSEMENT                @"employeeApplyReimbursement"
#define GET_OFFICIAL_REIMBURSEMENT                  @"getreimbursements"
#define APPROVE_OR_REJECT_REIMBURSEMENT             @"actiononreimbursements"
// Payroll
#define SALARRY_PROGRESS                            @"employeeSalaryIncriment"
#define APPRAISAL_LIST_EMPLOYEE                     @""
#define INCREAMENT_REASON                           @"reasonIncreament"
#define ADD_INCREAMENT                              @"incrementedSalary"

#define PAYSLIP_PIN                                  @"paySlipPin"

#define GET_PAYSLIP_EMPLOYEE                         @"employeePayslip"
// Appraisals
#define GET_APPRAISALS_LIST                          @"appraisals"
@interface HRMGlobals : NSObject

+(instancetype)sharedClient;

@end
