//
//  MVYASIImage.h
//  remoteImage
//
//  Created by Ivan on 05/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@protocol ImageDownloadedDelegate;

@interface MVYImageView : UIImageView {
    BOOL appearEffect;
    BOOL useCache;
    BOOL useThumbnails;
    BOOL updating;
    BOOL error;
    NSURL *url;
    UIActivityIndicatorView *indicator;
    UIImage *myImage;
    ASIHTTPRequest *myCurrentRequest;
    ASINetworkQueue *myQueue;
    
    id<ImageDownloadedDelegate> delegate;
}

//-----------------------
//Editable properties
//-----------------------
//Enable this flag to use fade effect. Default YES
@property BOOL appearEffect;

//Enable this flag to use cache. Default YES
@property BOOL useCache;

//Set this variable to use an existing network queue. Default NIL
@property(nonatomic, assign) ASINetworkQueue *myQueue;

//Protocol delegate
@property(nonatomic, assign) id<ImageDownloadedDelegate>    delegate;

//-----------------------
//Read-only properties
//-----------------------
//download status
@property (readonly) BOOL updating;
@property (readonly) BOOL error;

//-----------------------
//Methods 
//-----------------------
- (void)loadImageFromURL:(NSURL*)url loadingImage:(UIImage *)loadingImage;
- (void)loadImageFromURL:(NSURL*)aUrl loadingImage:(UIImage *)loadingImage hideActivity:(BOOL)_hideActivity;
- (void) cancelLoad;

@end

@protocol ImageDownloadedDelegate <NSObject>
@optional
-(void)imageFinishDownloading;
@end
