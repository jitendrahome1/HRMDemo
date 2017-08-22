//
//  HRMManager.h
//  HRMS
//
//  Created by Priyam Dutta on 18/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "JTMaterialSpinner.h"

@interface HRMManager : AFHTTPSessionManager
{
    JTMaterialSpinner *spinner;
}

-(void)setHeader;

-(NSURLSessionDataTask *)POST:(NSString *)URLString withLoader:(BOOL)enable parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id response))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
