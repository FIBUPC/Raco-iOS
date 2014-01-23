//
//  MVYASIImage.m
//  remoteImage
//
//  Created by Ivan on 05/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MVYImageView.h"
#import "ASIDownloadCache.h"
#import "UIImageExtras.h"
#import <QuartzCore/QuartzCore.h>

@interface MVYImageView()

-(NSInteger)myCachePolicy;
-(void)fadeImage;
-(void)callImageDownloadedDelegate;
-(void)loadImageFromURL:(NSURL*)aUrl loadingImage:(UIImage *)loadingImage;

@property(nonatomic, retain) NSURL *url;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) UIImage *myImage;
@property(nonatomic, retain) ASIHTTPRequest *myCurrentRequest;

@end

@implementation MVYImageView

@synthesize appearEffect,  useCache, updating, error, url, indicator, myImage, myCurrentRequest, myQueue;
@synthesize delegate;

#pragma -
#pragma init methods

-(void) dealloc{
    
    myCurrentRequest.delegate=nil;
    self.myCurrentRequest = nil;
    self.url = nil;
    self.indicator = nil;
    self.myImage = nil;
    [super dealloc];
    
}

- (void) initValues {
    
    myQueue=nil;
	updating=NO;
	error=NO;
	appearEffect=NO;
	useCache=YES;
	useThumbnails=YES;
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[indicator setHidesWhenStopped:YES];
	[indicator stopAnimating];
	[indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
	[self addSubview:indicator];
	[self setBackgroundColor:[UIColor clearColor]];
    
}

- (id) initWithFrame:(CGRect)frame {
    
	self = [super initWithFrame:frame];
	if (self!=nil){
		[self initValues];		
	}
	return self;
    
}

- (id) initWithImage:(UIImage *)image {
    
	self = [super initWithImage:image];
	if (self!=nil){
		[self initValues];
	}
	return self;
    
}

- (id) init {
    
	self = [super init];
	if (self!=nil){
		[self initValues];
	}
	return self;
    
}

- (void) awakeFromNib {
    
	[super awakeFromNib];
	[self initValues];
    
}

#pragma -
#pragma public methods

#define TIMEOUT 20.0
- (void)loadImageFromURL:(NSURL*)aUrl loadingImage:(UIImage *)loadingImage{
    [self loadImageFromURL:aUrl loadingImage:loadingImage hideActivity:NO];
    
}

- (void)loadImageFromURL:(NSURL*)aUrl loadingImage:(UIImage *)loadingImage hideActivity:(BOOL)_hideActivity {
	
	if ((aUrl!=nil) && (![aUrl isEqual:url])){
		//if there is a valid url and we are not loading it...
		
		//Stop previous conn if exists
		if (self.updating){
			[self cancelLoad];
		}
        
        if (!_hideActivity) {
            [indicator startAnimating];
        }
		updating=YES;
        self.url = aUrl;

		NSData *cachedImageData = [[ASIDownloadCache sharedCache] cachedResponseDataForURL:aUrl];
		
		//If there is a cached image we use it as loading image
		if (cachedImageData) {
			UIImage *cachedImage = [UIImage imageWithData:cachedImageData];
            
            if (self.contentMode == UIViewContentModeScaleAspectFit) {
                self.myImage = [cachedImage imageByScalingProportionallyToSize:self.frame.size];
            } else {
                self.myImage = cachedImage;
            }
			[self setImage:self.myImage];
		}else {
			[self setImage:loadingImage];
		}
		
		//Ok, let's check if remote image changed
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:aUrl];
        self.myCurrentRequest = request;
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
        [request setCachePolicy:[self myCachePolicy]];
        [request setShouldAttemptPersistentConnection:NO];
        [request setDelegate:self];
        [request setTimeOutSeconds:TIMEOUT];
        if (myQueue) {
            [myQueue addOperation:request];
        }else{
            [request startAsynchronous];
        }
        
        //indicator feedback
        CGFloat x = self.frame.size.width/2-indicator.frame.size.width/2;
        CGFloat y = self.frame.size.height/2-indicator.frame.size.height/2;
        CGFloat w = indicator.frame.size.width;
        CGFloat h = indicator.frame.size.height;
		indicator.frame = CGRectMake(x,y,w,h);

	}
    
}

- (void) cancelLoad{
    
    if (myCurrentRequest) {
        [myCurrentRequest clearDelegatesAndCancel];
    }
    
}

#pragma -
#pragma private methods

-(void)stopMyIndicator{ 
    
	[indicator stopAnimating];
	[indicator setNeedsLayout];
}

- (void)callImageDownloadedDelegate {
    
    [(id)[self delegate] performSelectorOnMainThread:@selector(imageFinishDownloading)
                                          withObject:nil
                                       waitUntilDone:NO];
}

#define kShadowTime 0.15
#define kShowTime 0.75

-(NSInteger)myCachePolicy{
    
    NSInteger res = 0;
    if (useCache) {
        res = ASIUseDefaultCachePolicy;
    }else{
        res = ASIDoNotWriteToCacheCachePolicy|ASIDoNotReadFromCacheCachePolicy;
    }
    return res;
    
}

NSInteger fadeImageTag;
NSInteger unfadeImageTag;

- (void) fadeImage {
    
    fadeImageTag = 10;
    unfadeImageTag = 11;
    
    UIImageView *fadeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    UIImageView *unfadeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [fadeImage setBackgroundColor:[UIColor clearColor]];
    [fadeImage setContentMode:self.contentMode];
    [unfadeImage setContentMode:self.contentMode];
    [fadeImage setImage:[self image]];
    [unfadeImage setImage:[self myImage]];
    [fadeImage setTag:fadeImageTag];
    [unfadeImage setTag:unfadeImageTag];
    [unfadeImage setAlpha:0];
    [fadeImage setAlpha:1];
    [self addSubview:unfadeImage];
    [self addSubview:fadeImage];
    [self sendSubviewToBack:unfadeImage];
    [self sendSubviewToBack:fadeImage];
    
    
    [fadeImage release];
    [unfadeImage release];
    
    [super setImage:nil];
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDidStopSelector:@selector(fadeComplete)];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDuration: 0.75];
    [fadeImage setAlpha:0];
    [unfadeImage setAlpha:1];
	[UIView commitAnimations];
    
}

- (void) fadeComplete {
    [super setImage:myImage];
    [[self viewWithTag:fadeImageTag] removeFromSuperview];
    [[self viewWithTag:unfadeImageTag] removeFromSuperview];
    
    
    updating = NO;
}

#pragma -
#pragma ASIHttpRequest delegate methods

- (void)requestFinished:(ASIHTTPRequest *)request{
    
	BOOL requestFromCache = [request didUseCachedResponse];	
	//DLog(@"request from cache:%d url:%@",requestFromCache, [request.url absoluteString]);	
	[self stopMyIndicator];
    [self callImageDownloadedDelegate];
    self.myCurrentRequest = nil;
        
	if (!requestFromCache) {
		//not cached result
		UIImage *newImage = [UIImage imageWithData:[request responseData]];
        if (self.contentMode == UIViewContentModeScaleAspectFit) {
            self.myImage = [newImage imageByScalingProportionallyToSize:self.frame.size];
        } else {
            self.myImage = newImage;
        }
		if (appearEffect) {
			[self fadeImage];
		}else{
			[super setImage:myImage];
			updating = NO;
			[[self superview] setNeedsLayout];
		}		
	}else {
		//result from cache
		//It's important to set cached image here, think about concurrent requests
		UIImage *newImage = [UIImage imageWithData:[request responseData]];
        if (self.contentMode == UIViewContentModeScaleAspectFit) {
            self.myImage = [newImage imageByScalingProportionallyToSize:self.frame.size];
        } else {
            self.myImage = newImage;
        }
		[super setImage:myImage];
		updating = NO;
		[[self superview] setNeedsLayout];
	}

}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
	//DLog(@"request FAIL url:%@", [request.url absoluteString]);
	[self stopMyIndicator];
    [self callImageDownloadedDelegate];
    self.myCurrentRequest = nil;
    updating = NO;
    
}

@end
