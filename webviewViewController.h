//
//  webview.h
//  week5Maps
//
//  Created by Aditya Narayan on 7/9/15.
//  Copyright (c) 2015 Aditya Narayan. All rights reserved.
//

 #import <WebKit/WebKit.h>

@interface webviewViewController : UIViewController

@property (nonatomic, retain) WKWebView * WKwebView;
@property (nonatomic, retain) NSString *webPages;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;




@end
