//
//  NoticiaWebViewController.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 03/01/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NoticiaWebViewController : UIViewController <UIActionSheetDelegate>{
	UIWebView   *noticiaWebView;
	UIToolbar   *toolbar;
	NSString    *urlWeb;
}

@property(nonatomic,retain) IBOutlet UIWebView *noticiaWebView;
@property(nonatomic,retain) IBOutlet UIToolbar *toolbar;

- (IBAction) changeWebUrl:(NSString *)url;

@end
