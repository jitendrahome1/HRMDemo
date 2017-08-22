//
//  JTMaterialSpinner.h
//  JTMaterialSpinner
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

@interface JTMaterialSpinner : UIView

@property (nonatomic, readwrite)  UIView *pulse;
@property (nonatomic, readonly) CAShapeLayer *circleLayer;
@property (nonatomic) BOOL isAnimating;

/*!
 * Force the start of the animation. When an app is closed the animatin is stopped but `isAnimating` is still at `YES`.
 */
- (void)forceBeginRefreshing;

/*!
 * Start the animation if `isAnimating` is at `NO`
 */
- (void)beginRefreshing;

- (void)beginRefreshingWithFader;

/*!
 * Stop the animation
 */
- (void)endRefreshing;

@property (nonatomic, copy) void ((^blockComplete)(BOOL success));
@property (nonatomic, copy) void ((^restore)(BOOL isRestore));

@end
