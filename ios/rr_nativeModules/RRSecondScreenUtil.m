//
//  RRSecondScreenUtil.m
//  rr_nativeModules
//
//  Created by Marcus Erlandsson on 2016-03-31.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RRSecondScreenUtil.h"


@implementation RRSecondScreenUtil

RCT_EXPORT_MODULE();

- (RRSecondScreenUtil *)init{
  if (self = [super init]) {
    [self checkForExistingScreenAndInitializeIfPresent];
    [self setUpScreenConnectionNotificationHandlers];
    if (self.secondWindow) {
      printf("External screen connected!");
    } else {
      printf("No external screen:/");
    }
  }
  return self;
}

- (NSDictionary *)constantsToExport {
  return @{@"greeting": @"Welcome to RR\nTest"};
}
RCT_EXPORT_METHOD(isSecondScreenConnected:(RCTResponseSenderBlock)callback) {
  bool is_connected = self.secondWindow != nil;
  callback(@[[NSNull null], [NSNumber numberWithBool:is_connected]]);
}

RCT_EXPORT_METHOD(squareMe:(int)number:(RCTResponseSenderBlock)callback) {
  callback(@[[NSNull null], [NSNumber numberWithInt:(number*number)]]);
}

RCT_EXPORT_METHOD(sendEventToSecondScreen:(NSString *)eventName:(NSDictionary *)properties:(RCTResponseSenderBlock)callback) {
  if (!self.secondWindow) {
    callback(@[[NSString stringWithFormat:@"NO_SCREEN_CONNECTED"]]);
    return;
  }
  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:properties options:0 error:&err];
  NSString * jsonProperties = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  
  // TODO: Send to screen if any
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *javascriptString = [NSString stringWithFormat:@"foo('%@', %@);", eventName, jsonProperties];
    [self.secondWebView stringByEvaluatingJavaScriptFromString:javascriptString];

  });
  callback(@[[NSNull null]]);
}

- (void)setUpScreenConnectionNotificationHandlers
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  
  [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                 name:UIScreenDidConnectNotification object:nil];
  [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                 name:UIScreenDidDisconnectNotification object:nil];
}

- (void)checkForExistingScreenAndInitializeIfPresent
{
  if ([[UIScreen screens] count] > 1)
  {
    // Associate the window with the second screen.
    // The main screen is always at index 0.
    UIScreen* secondScreen = [[UIScreen screens] objectAtIndex:1];
    [self setupSecondScreen:secondScreen];
    [self showSecondScreen];
  }
}

- (void)setupSecondScreen:(UIScreen *)secondScreen
{
  CGRect screenBounds = secondScreen.bounds;
  
  self.secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
  self.secondWindow.screen = secondScreen;
  
  UIView* screenView = [[UIView alloc] initWithFrame:screenBounds];
  screenView.backgroundColor = [UIColor whiteColor];
  [self.secondWindow addSubview:screenView];
  self.secondWindow.rootViewController = [[UIViewController alloc] init];
  
  self.secondWebView = [[UIWebView alloc]initWithFrame:screenBounds];
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"web/second-screen" withExtension:@"html"];
  if (url == nil) {
    printf("Unable to locate url!");
  }
  [self.secondWebView loadRequest:[NSURLRequest requestWithURL:url]];
  [screenView addSubview:self.secondWebView];
  [self.secondWebView setDelegate:self];
}

- (void)showSecondScreen
{
  self.secondWindow.hidden = NO;
}
- (void)hideSecondScreen
{
  self.secondWindow.hidden = YES;
}

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification
{
  UIScreen *newScreen = [aNotification object];
  [self setupSecondScreen:newScreen];
  if (!self.secondWindow)
  {
    // TODO: [self setupSecondScreen:newScreen];
  } else {
    // TODO: update size only here
  }
  [self showSecondScreen];
  printf("External screen connected!");
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification
{
  if (self.secondWindow)
  {
    // Hide and then delete the window.
    [self hideSecondScreen];
    self.secondWindow = nil;
    printf("External screen disconnected:(");
    
  }
  
}

@end
