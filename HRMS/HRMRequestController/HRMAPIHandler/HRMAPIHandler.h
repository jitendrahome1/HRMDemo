//
//  HRMAPIHandler.h
//  HRMS
//
//  Created by Priyam Dutta on 18/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRMAPIHandler : NSObject

+(instancetype)handler;

#pragma mark - Login & Logout
/**
 *  Login
 *
 *  @param companyID companyID description
 *  @param userName  userName description
 *  @param password  password description
 *  @param success   success description
 *  @param failure   failure description
 */
-(void)loginWithCompanyName:(NSString *)companyID userName:(NSString *)userName password:(NSString *)password WithSuccess:(void(^)(NSDictionary *responseDict))success failure:(void(^)(NSError *error))failure;
/**
 *  Logout
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)logoutWithSuccess:(void(^)(NSDictionary *responseDict))success failure:(void(^)(NSError *error))failure;

#pragma mark - Password
/**
 *  Forgot Password
 *
 *  @param companyName companyName description
 *  @param email       email description
 *  @param success     success description
 *  @param failure     failure description
 */
-(void)forgotPasswordWithCompanyName:(NSString *)companyName andEmail:(NSString *)email withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

/**
 *  Update Password
 *
 *  @param oldPassword oldPassword description
 *  @param newPassword newPassword description
 *  @param success     success description
 *  @param failure     failure description
 */
-(void)updatePasswordWithCurrentPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Access Permit
/**
 *  Get Acces Permit
 *
 *  @param show    show description
 *  @param success success description
 *  @param failure failure description
 */
-(void)getAccessPermitWithLoader:(BOOL)show WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Notification
/**
 *  Get Notification
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)getNotificationWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Employee
/**
 *  Get Employee list
 *
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param searchText searchText description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)getEmployeeListWithPageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber andSearchText:(NSString *)searchText withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Timesheet
/**
 *  Timesheet filed list for Official purpose
 *
 *  @param employeeid employeeid description
 *  @param department department description
 *  @param month      month description
 *  @param year       year description
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param searchText searchText description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)getAllEmployeeTimesheetWithEmpID:(NSString *)employeeid department:(NSString *)department month:(NSString *)month year:(NSString *)year pageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Employee Timesheet correction list
 *
 *  @param companyID  companyID description
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param searchText searchText description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)getEmployeeTimesheetCorrection:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Action for save correction requested
 *
 *  @param companyID      companyID description
 *  @param timesheetReqID timesheetReqID description
 *  @param date           date description
 *  @param project        project description
 *  @param outTime        outTime description
 *  @param location       location description
 *  @param description    description description
 *  @param success        success description
 *  @param failure        failure description
 */
-(void)saveTimesheetCorrectionWithTimesheetReqID:(NSString *)timesheetReqID clockTime:(NSString *)clockTime location:(NSString *)location withSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Employee Timesheet listing
 *
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)getEmployeeTimesheetListingWithPageCount:(NSString *)pageCount andPageNumber:(NSString *)pageNumber WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Request for Timesheet by employee
 *
 *  @param timesheetId timesheetId description
 *  @param request     request description
 *  @param success     success description
 *  @param failure     failure description
 */
-(void)requestEmployeeTimesheetCorrectionWithTimsheetId:(NSString *)timesheetId andRequest:(NSString *)request WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Employee Add Timesheet
 *
 *  @param projectId projectId description
 *  @param date      date description
 *  @param time      time description
 *  @param clockType clockType description
 *  @param image     image description
 *  @param success   success description
 *  @param failure   failure description
 */
-(void)addTimesheetWithProjectId:(NSString *)projectId date:(NSString *)date time:(NSString *)time clockType:(NSString *)clockType location:(NSString *)location andImage:(NSData *)image WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Interview
/**
 *  Get Interview List
 *
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param searchText searchText description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)getInterviewListWithPageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Departments
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)getDepartmentsForInterviewWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Interviewer List
 *
 *  @param departmentID departmentID description
 *  @param success      success description
 *  @param failure      failure description
 */
-(void)getInterviewerWithID:(NSString *)departmentID WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Add/Edit Interview
 *
 *  @param interviewId     interviewId description
 *  @param interviewerId   interviewerId description
 *  @param date            date description
 *  @param time            time description
 *  @param name            name description
 *  @param email           email description
 *  @param mobile          mobile description
 *  @param interviewType   interviewType description
 *  @param department      department description
 *  @param position        position description
 *  @param experience      experience description
 *  @param currentPackage  currentPackage description
 *  @param currentEmployer currentEmployer description
 *  @param notice          notice description
 *  @param status          status description
 *  @param success         success description
 *  @param failure         failure description
 */
-(void)addInterviewWithInterviewId:(NSString *)interviewId interviewerId:(NSString *)interviewerId date:(NSString *)date time:(NSString *)time name:(NSString *)name email:(NSString *)email mobile:(NSString *)mobile interviewType:(NSString *)interviewType department:(NSString *)department position:(NSString *)position experience:(NSString *)experience currentPackage:(NSString *)currentPackage currentEmployer:(NSString *)currentEmployer noticePeriod:(NSString *)notice status:(NSString *)status WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Leave
/**
 *  GET LEAVE TYPE
 *
 *  @param leaveYear leaveYear description
 *  @param success   success description
 *  @param failure   failure description
 */
-(void)getLeaveTypeListWithYear:(NSString *)leaveYear WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get AO and RO List
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)getAOROListWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Apply Leave
 *
 *  @param leaveId   leaveId description
 *  @param fromDate  fromDate description
 *  @param toDate    toDate description
 *  @param duration  duration description
 *  @param roId      roId description
 *  @param aoId      aoId description
 *  @param ccPerson  ccPerson description
 *  @param isMorning isMorning description
 *  @param address   address description
 *  @param reason    reason description
 *  @param success   success description
 *  @param failure   failure description
 */
-(void)applyLeaveWithLeaveTypeId:(NSString *)leaveId fromDate:(NSString *)fromDate toDate:(NSString *)toDate duration:(NSString *)duration roId:(NSString *)roId aoId:(NSString *)aoId ccPerson:(NSString *)ccPerson isMorning:(NSString *)isMorning address:(NSString *)address reason:(NSString *)reason WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Leave list for Employee
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)getEmployeeLeaveListWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Leave List Official
 *
 *  @param employeeId employeeId description
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param searchText searchText description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)getLeaveListOfficialWithEmployeeId:(NSString *)employeeId pageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Approve or Reject Leave
 *
 *  @param leaveID     leaveID description
 *  @param leaveAction leaveAction description
 *  @param success     success description
 *  @param failure     failure description
 */
-(void)leaveApproveOrRejectWithLeaveID:(NSString *)leaveID leaveAction:(NSString *)leaveAction WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Reimbursement
/**
 *  Get Benifits List with Officer
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)getBenifitsTypeAndOfficerWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Employee Reimbursement List
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)getEmployeeReimbursementListWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Apply Reimbursement
 *
 *  @param officerID      officerID description
 *  @param incurredDate   incurredDate description
 *  @param amount         amount description
 *  @param description    description description
 *  @param fileImage      fileImage description
 *  @param submissionDate submissionDate description
 *  @param benefitId      benefitId description
 *  @param success        success description
 *  @param failure        failure description
 */
-(void)applyEmployeeReimbursementWithOfficerID:(NSString *)officerID incurredDate:(NSString *)incurredDate amount:(NSString *)amount description:(NSString *)description fileImage:(NSData *)fileImage submissionDate:(NSString *)submissionDate benefitId:(NSString *)benefitId  WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Reimbursement List Official
 *
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param searchText searchText description
 *  @param employeeId employeeId description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)getReimbursementListOfficialWithPageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText employeeId:(NSString *)employeeId WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Approve or Reject Reimbursement
 *
 *  @param reimburseID     reimburseID description
 *  @param reimburseAction reimburseAction description
 *  @param success         success description
 *  @param failure         failure description
 */
-(void)reimbursementApproveOrRejectWithReimbursementID:(NSString *)reimburseID leaveAction:(NSString *)reimburseAction WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

#pragma mark - Payroll
/**
 *  Salary Progress List
 *
 *  @param employeeID employeeID description
 *  @param success    success description
 *  @param failure    failure description
 */
-(void)salaryProgressListEmployeeID:(NSString *)employeeID WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Reason for Increament
 *
 *  @param success success description
 *  @param failure failure description
 */
-(void)getReasonForIncreamentWithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Add Increament
 *
 *  @param employeeID  employeeID description
 *  @param date        date description
 *  @param amount      amount description
 *  @param reason      reason description
 *  @param description description description
 *  @param success     success description
 *  @param failure     failure description
 */
-(void)increamentedSalaryForemployeeID:(NSString *)employeeID date:(NSString *)date amount:(NSString *)amount reason:(NSString *)reason andDescription:(NSString *)description WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;

-(void)getAppraisalListWithEmployeeid:(NSString *)employeeid pageCount:(NSString *)pageCount pageNumber:(NSString *)pageNumber searchText:(NSString *)searchText WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *  Get Appraisal List
 *
 *  @param pageCount  pageCount description
 *  @param pageNumber pageNumber description
 *  @param searchText searchText description
 *  @param employeeId employeeId description
 *  @param success    success description
 *  @param failure    failure description
 */

-(void)paySlipPinVerifiedWithPin:(NSString *)paySlipPin WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *   verified PaySlipPin
 *
 *  @param pin  verified
 
 */

-(void)getGetPayslipWithMothAndYear:(NSString *)month year:(NSString *)year WithSuccess:(void (^)(NSDictionary *responseDict))success failure:(void (^)(NSError *error))failure;
/**
 *   Get Employee PaySlip
 *
 *  @param month  
    @param year 
 
 */


@end

