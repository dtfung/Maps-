//
//  AppDelegate.h
//  week5Maps
//
//  Created by Aditya Narayan on 7/7/15.
//  Copyright (c) 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webviewViewController.h"

@class MapsViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MapsViewController *viewController;
@property (strong, nonatomic) webviewViewController *web;
@end

