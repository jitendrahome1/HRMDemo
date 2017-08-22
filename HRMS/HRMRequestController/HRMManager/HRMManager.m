//
//  HRMManager.m
//  HRMS
//
//  Created by Priyam Dutta on 18/04/16.
//  Copyright © 2016 Indus Net Technologies. All rights reserved.
//

#import "HRMManager.h"
#import "AFNetworkActivityLogger.h"

@interface GradientView : UIView

@end

@implementation GradientView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setFrame:frame];
        self.backgroundColor = [UIColor clearColor];
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.frame = self.bounds;
        [self.layer addSublayer:gradientLayer];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    /***** Out to In *****/
    /* CGContextRef ctx = UIGraphicsGetCurrentContext();
     size_t gradLocationsNum = 2;
     CGFloat gradLocations[2] = {0.0f, 1.0f};
     CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.5f};
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
     CGColorSpaceRelease(colorSpace);
     CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
     float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
     CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsBeforeStartLocation);
     CGGradientRelease(gradient);*/
    
    /****** In to Out ******/
  /* CGFloat colorComponents[] = {0.0, 0.0, 0.0, 1.0,   // First color:  R, G, B, ALPHA (currently opaque black)
        0.0, 0.0, 0.0, 0.0};  // Second color: R, G, B, ALPHA (currently transparent black)
    CGFloat locations[] = {1, 0}; // {0, 1) -> from center to outer edges, {1, 0} -> from outer edges to center
    CGFloat radius = MIN((self.bounds.size.height / 2), (self.bounds.size.width / 2));
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    // Prepare a context and create a color space
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create gradient object from our color space, color components and locations
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, 2);
    
    // Draw a gradient
    CGContextDrawRadialGradient(context, gradient, center, 0.0, center, radius+400, 0);
    CGContextRestoreGState(context);
    
    // Release objects
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);*/
}

@end

static HRMManager *manager = nil;

@interface HRMManager ()
{
    GradientView *radialGrad;
}
@end

@implementation HRMManager

+(instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HRMManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager setHeader];
        [manager.requestSerializer setValue:kAPIKey forHTTPHeaderField:@"apikey"];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        manager.operationQueue.maxConcurrentOperationCount = 1;
#ifdef DEBUG
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif
    });
    return manager;
}

-(void)setHeader{
    [manager.requestSerializer setValue:OBJ_FOR_KEY(kCompanyId) forHTTPHeaderField:@"companyId"];
    [manager.requestSerializer setValue:OBJ_FOR_KEY(kUserdId) forHTTPHeaderField:@"userId"];
    
}

-(NSURLSessionDataTask *)POST:(NSString * __nonnull)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id response))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        [HRMToast showWithMessage:NO_NETWORK];
        return nil;
    }
    else
    {
        if (![[[[UIApplication sharedApplication] keyWindow] subviews] containsObjectOfType:[JTMaterialSpinner class]] && ![URLString isEqualToString:LOGIN]) {
            [self addLoader];
        }
        return [super POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id response){
            [spinner endRefreshing];
            [spinner removeFromSuperview];
            [radialGrad removeFromSuperview];
            success(task, response);
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            [spinner endRefreshing];
            [spinner removeFromSuperview];
            [radialGrad removeFromSuperview];
            [HRMToast showWithMessage:error.localizedDescription];
            failure(task, error);
        }];
    }
}

-(NSURLSessionDataTask *)POST:(NSString * __nonnull)URLString withLoader:(BOOL)enable parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *task, id response))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        [HRMToast showWithMessage:NO_NETWORK];
        return nil;
    }
    else
    {
        if (![[[[UIApplication sharedApplication] keyWindow] subviews] containsObjectOfType:[JTMaterialSpinner class]] && ![URLString isEqualToString:LOGIN] && enable) {
            [self addLoader];
        }
        return [super POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id response){
            [spinner endRefreshing];
            [spinner removeFromSuperview];
            [radialGrad removeFromSuperview];
            success(task, response);
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            [spinner endRefreshing];
            [spinner removeFromSuperview];
            [radialGrad removeFromSuperview];
            [HRMToast showWithMessage:error.localizedDescription];
            failure(task, error);
        }];
    }
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
    {
        return nil;
    }
    else{
         [self addLoader];
        return [super POST:URLString parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject){
            [spinner endRefreshing];
            [spinner removeFromSuperview];
            [radialGrad removeFromSuperview];
            success(task ,responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error){
            [spinner endRefreshing];
            [spinner removeFromSuperview];
            [radialGrad removeFromSuperview];
            [HRMToast showWithMessage:error.localizedDescription];
            failure(task ,error);
        }];
    }
}

-(void)addLoader
{
    spinner = [[JTMaterialSpinner alloc] initWithFrame:CGRectMake(0, 0, IS_IPAD ? 70 : 50, IS_IPAD ? 70 : 50)];
    spinner.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])/2.0, CGRectGetHeight([[UIScreen mainScreen] bounds])/2.0);
    spinner.circleLayer.strokeColor = UIColorRGB(35.0, 134.0, 203.0, 1.0).CGColor;
    spinner.circleLayer.lineWidth = 2.0;
    [spinner beginRefreshing];
    radialGrad = [[GradientView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[[UIApplication sharedApplication] keyWindow] bounds]), CGRectGetHeight([[[UIApplication sharedApplication] keyWindow] bounds]))];
    radialGrad.alpha = 0.7;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = radialGrad.bounds;
    gradient.opacity = 0.5;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor],(id)[[UIColor brownColor] CGColor], nil];
    [radialGrad.layer insertSublayer:gradient atIndex:0];
    
    [radialGrad addSubview:spinner];
    [[[UIApplication sharedApplication] keyWindow] addSubview:radialGrad];
}

@end
