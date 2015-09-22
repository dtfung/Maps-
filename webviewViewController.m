//
//  webview.m
//  week5Maps
//
//  Created by Aditya Narayan on 7/9/15.
//  Copyright (c) 2015 Aditya Narayan. All rights reserved.
//

#import "webviewViewController.h"

@interface webviewViewController ()

@end

@implementation webviewViewController

@synthesize toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createToolbar];

    // Do any additional setup after loading the view from its nib.
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc]init];
    
    self.WKwebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    self.view = self.WKwebView;
    NSURL *url = [NSURL URLWithString:self.webPages];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.WKwebView loadRequest:request];
    
    //released these objects to address memory leaks.
    //[theConfiguration release];
}

- (void) createToolbar {
    UIBarButtonItem *toPreviousView = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goToPreviousView:)];
    self.navigationItem.leftBarButtonItem=toPreviousView;
}

- (IBAction)goToPreviousView:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [self.WKwebView release];
//    [super dealloc];
//}
@end
