//
//  HRMConstants.h
//  HRMS
//
//  Created by Priyam Dutta on 29/09/15.
//  Copyright (c) 2015 Indus Net Technologies. All rights reserved.
//

#ifndef HRMS_HRMConstants_h
#define HRMS_HRMConstants_h

#define VIEWBACKCOLOR [UIColor colorWithRed:229.0f/255.0f green:229.0f/255.0f  blue:229.0f/255.0f  alpha:1.0]
#define BODERCOLOR [UIColor colorWithRed:166.0f/255.0f green:166.0f/255.0f  blue:166.0f/255.0f  alpha:1.0]
#define LIGHT_BODER_COLOR [UIColor colorWithRed:233.0f/255.0f green:233.0f/255.0f  blue:233.0f/255.0f  alpha:1.0]
#define BUTTONOLOR [UIColor colorWithRed:13.0f/255.0f green:76.0f/255.0f  blue:114.0f/255.0f  alpha:1.0]
#define GENERALOLOR [UIColor colorWithRed:6.0f/255.0f green:56.0f/255.0f  blue:86.0f/255.0f  alpha:1.0]
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

#define kFlatGreen          UIColorRGB(46.0, 204.0, 133.0, 1.0);
#define kFlatRed            UIColorRGB(217.0, 30.0, 24.0, 1.0);
#define kAppThemeColor      UIColorRGB(35.0, 134.0, 203.0, 1.0);

#define kHRMSFont @"FuturaBT-Book"
#define FONT_LIGHT(i)   [UIFont fontWithName:@"Futura-Light" size:i]
#define FONT_REGULAR(i) [UIFont fontWithName:@"FuturaBT-Book" size:i]

#define kDeviceToken    @"deviceToken"

#define NUMERICS        @"0123456789"
#define ALPHABETS       @"qwertyuioplkjhgfdsazxcvbnm QWERTYUIOPLKJHGFDSAZXCVBNM"

#define kDefaultColor [UIColor colorWithRed:40.0f/255.0f green:120.0f/255.0f blue:196.0f/255.0f alpha:1.0]

#define kApplicationTitle                       @"Virbula"
#define SYSTEM_VERSION                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPAD                                 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)
#define IS_IPHONE4                              (SCREEN_HEIGHT == 480 ? YES : NO)

#define SCREEN_WIDTH                            CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT                           CGRectGetHeight([[UIScreen mainScreen] bounds])

#define SET_OBJ_FOR_KEY(obj, key)               [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key]
#define OBJ_FOR_KEY(key)                        [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define SET_INTEGER_FOR_KEY(integer, key)       [[NSUserDefaults standardUserDefaults] setInteger:integer forKey:key]
#define INTEGER_FOR_KEY(key)                    [[NSUserDefaults standardUserDefaults] integerForKey:key]

#define SET_BOOL_FOR_KEY(bool, key)             [[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]
#define BOOL_FOR_KEY(key)                       [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define UIColorRGB(r, g, b, a)                  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

#endif
