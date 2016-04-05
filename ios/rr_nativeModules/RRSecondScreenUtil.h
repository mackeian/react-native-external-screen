//
//  RRSecondScreenUtil.h
//  rr_nativeModules
//
//  Created by Marcus Erlandsson on 2016-03-31.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"

#import <UIKit/UIKit.h>

@interface RRSecondScreenUtil : NSObject<RCTBridgeModule, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *secondWebView;
@property (strong, nonatomic) UIWindow *secondWindow;

@end
