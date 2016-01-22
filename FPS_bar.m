//
//  FPS_bar.m
//  常用Category
//
//  Created by Ming on 15/12/24.
//  Copyright © 2015年 戴晨惜. All rights reserved.
//

#import "FPS_bar.h"

@interface FPS_bar(){
    
    CATextLayer     *_FPSTextLayer; /**<- FPS 显示 layer*/
    
    CADisplayLink   *_displayLink;
    
    NSTimeInterval  _displayLinkTickLastTime;
}
@property (nonatomic) NSTimeInterval updateInterval; /**<- 更新间隔*/

@end

@implementation FPS_bar

+ (instancetype)sharedInstance{
    static FPS_bar *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FPS_bar alloc] init];
        
        if (!sharedInstance.rootViewController && [[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            sharedInstance.rootViewController = [UIViewController new];
        }
        [sharedInstance makeKeyAndVisible];
    });
    return sharedInstance;
}

- (instancetype)init{
    
    self = [super initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
    
    [self setWindowLevel:UIWindowLevelStatusBar - 1];
    
    [self initDisplayLink];
    
    [self initTextLayer];
    

    return self;
}

- (void)initDisplayLink {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink setPaused:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)initTextLayer {
    _FPSTextLayer = [CATextLayer layer];
    [_FPSTextLayer setFrame:CGRectMake(55., self.bounds.size.height - 17., 80., 16.)];
    [_FPSTextLayer setFontSize: 13.];
    [_FPSTextLayer setForegroundColor: [UIColor redColor].CGColor];
    [self.layer addSublayer:_FPSTextLayer];
    
    if( [_FPSTextLayer respondsToSelector:@selector(setDrawsAsynchronously:)] ){
        [_FPSTextLayer setDrawsAsynchronously:YES];
    }
}

static NSInteger _count = 0;
- (void)displayLinkTick:(CADisplayLink *)link {
    if (_displayLinkTickLastTime == 0) {
        _displayLinkTickLastTime = link.timestamp;
        return;
    }
    _count++;
    NSTimeInterval delta = link.timestamp - _displayLinkTickLastTime;
    if (delta < 1) return;
    _displayLinkTickLastTime = link.timestamp;
    float FPS = _count / delta;
    _count = 0;
    
    [_FPSTextLayer setString:[NSString stringWithFormat:@"FPS: %ld",(long)FPS]];
}


-(void)dealloc {
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink invalidate];
}

- (void)applicationDidBecomeActiveNotification {
    [_displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification {
    [_displayLink setPaused:YES];
}
@end
