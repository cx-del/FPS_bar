//
//  FPS_bar.h
//
//  Created on 15/12/24.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用法：在 appdelegate 入口方法
 *
 *  [[FPS_bar sharedInstance] setHidden:NO];
 *
 */
@interface FPS_bar : UIWindow

+ (instancetype)sharedInstance;

@end
