//
//  WLBWebViewController.m
//  Wellbeing App
//
//  Created by Xilin Liu on 3/4/15.
//  Copyright (c) 2015 Student Association. All rights reserved.
//

#import "WLBWebViewController.h"

@interface WLBWebViewController () <UIWebViewDelegate>

@end

@implementation WLBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self loadRequestFromString:@"http://localhost:19125/login"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] isEqual: @"http://localhost:19125/after_login"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
