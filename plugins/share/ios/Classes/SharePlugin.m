// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "SharePlugin.h"

static NSString *const PLATFORM_CHANNEL = @"plugins.flutter.io/share";

@interface SharePlugin ()<UINavigationControllerDelegate>
@end

@implementation SharePlugin 

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *shareChannel =
      [FlutterMethodChannel methodChannelWithName:PLATFORM_CHANNEL
                                  binaryMessenger:registrar.messenger];
  UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  [shareChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    if ([@"share" isEqualToString:call.method]) {
      [self share:call.arguments
            withController:viewController];
      result(nil);
    }
    else if ([@"shareImage" isEqualToString:call.method]) {
      [self shareImage:call.arguments
        withController:viewController];
      result(nil);
    } else {
      result([FlutterError errorWithCode:@"UNKNOWN_METHOD"
                                 message:@"Unknown share method called"
                                 details:nil]);
    }
  }];
}

+ (void)share:(id)sharedItems withController:(UIViewController *)controller {
  UIActivityViewController *activityViewController =
      [[UIActivityViewController alloc] initWithActivityItems:@[ sharedItems ]
                                        applicationActivities:nil];
  [controller presentViewController:activityViewController 
                           animated:YES 
                         completion:nil];
}

+ (void)shareImage:(id)sharedItems withController:(UIViewController *)controller {
  NSURL *imageUrl = [NSURL fileURLWithPath:sharedItems];
  //  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
  UIActivityViewController *activityViewController =
      [[UIActivityViewController alloc] initWithActivityItems:@[imageUrl]
                                        applicationActivities:nil];
  [controller presentViewController:activityViewController 
                           animated:YES 
                         completion:nil];
}



@end
