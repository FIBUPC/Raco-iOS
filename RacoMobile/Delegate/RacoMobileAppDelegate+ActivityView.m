//
//  RacoMobileAppDelegate+ActivityView.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 03/08/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "RacoMobileAppDelegate+ActivityView.h"
#import <QuartzCore/QuartzCore.h>
#import "Defines.h"


@implementation RacoMobileAppDelegate (ActivityView)

#pragma mark -
#pragma mark Activity indicator

#define LOADING_FRAME_WIDTH     222
#define LOADING_FRAME_HEIGHT    186
#define ACTIVITY_WHEEL_W        24
#define ACTIVITY_WHEEL_H        24
#define ACTIVITY_TOP_PADDING    28
#define TEXT_HORIZONTAL_PADDING 20
#define TEXT_TOP_PADDING        30
#define TEXT_LABEL_HEIGHT       44

- (void)hideActivityViewer {
    //Hide NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (dummyView && [[dummyView subviews] count] > 0) {
        [[[activityView subviews] objectAtIndex:0] stopAnimating];
        [dummyView removeFromSuperview];
        dummyView = nil;
    }	
}

- (void)showActivityViewer:(NSString*)aTexto {
    //Show NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self hideActivityViewer];
    
    //DummyView
    dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _window.bounds.size.width, _window.bounds.size.height)];
    UIImageView *dummyBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _window.bounds.size.width, _window.bounds.size.height)];
    dummyBackground.backgroundColor = [UIColor blackColor];
    dummyBackground.alpha = 0.6;
    [dummyView addSubview:dummyBackground];
    [dummyBackground release];

	//Activity View
	activityView = [[UIView alloc] initWithFrame: CGRectMake((_window.bounds.size.width - LOADING_FRAME_WIDTH)/2, (_window.bounds.size.height - LOADING_FRAME_HEIGHT)/2, LOADING_FRAME_WIDTH, LOADING_FRAME_HEIGHT)];
	activityView.backgroundColor = [UIColor clearColor];    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comun_timer.png"]];
    [activityView addSubview:backgroundImage];
    [backgroundImage release];
    
    //Activity Indicator
	UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(LOADING_FRAME_WIDTH / 2 - ACTIVITY_WHEEL_W/2, (LOADING_FRAME_HEIGHT / 2 - ACTIVITY_WHEEL_H/2) + ACTIVITY_TOP_PADDING, ACTIVITY_WHEEL_W, ACTIVITY_WHEEL_H)];
	activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;	
	[activityView addSubview:activityWheel];	
	[activityWheel release];
	
    //Label Text
	UILabel *lTexto = [[UILabel alloc] initWithFrame:CGRectMake(TEXT_HORIZONTAL_PADDING/2,LOADING_FRAME_HEIGHT/2+TEXT_TOP_PADDING,LOADING_FRAME_WIDTH-TEXT_HORIZONTAL_PADDING,TEXT_LABEL_HEIGHT)];
	lTexto.textAlignment = UITextAlignmentCenter;
	lTexto.text = aTexto;
	lTexto.backgroundColor = [UIColor clearColor];
	lTexto.textColor = [UIColor darkGrayColor];
	[activityView addSubview:lTexto];
	[lTexto release];
	lTexto = nil;
	
    [dummyView addSubview:activityView];
    [_window addSubview:dummyView];
    
    [dummyView release];
	
	[[[activityView subviews] objectAtIndex:1] startAnimating];
}

- (void)showActivityViewer {
	[self showActivityViewer:NSLocalizableString(@"_updatingData")];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}

@end
