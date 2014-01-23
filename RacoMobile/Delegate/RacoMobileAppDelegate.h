//
//  RacoMobileAppDelegate.h
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 01/08/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailHandler.h"
#import "NewsHandler.h"
#import "FibSubjectsHandler.h"
#import "FibSubjectDetailHandler.h"
#import "RacoSubjectsHandler.h"
#import "OccupationHandler.h"
#import "OccupationSubjectHandler.h"
#import "AvisosHandler.h"
#import "AgendaIcsHandler.h"
#import "ScheduleHandler.h"
#import "MVYCrashReport.h"
#import <MessageUI/MessageUI.h>

@interface RacoMobileAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, CrashReportDelegate, MFMailComposeViewControllerDelegate, MailHandlerDelegate, NewsHandlerDelegate, FibSubjectsHandlerDelegate, FibSubjectDetailHandlerDelegate,  RacoSubjectsHandlerDelegate, OccupationHandlerDelegate, OccupationSubjectHandlerDelegate, AvisosHandlerDelegate, AgendaIcsHandlerDelegate, ScheduleHandlerDelegate> {
    
    UIWindow                *_window;
    UITabBarController      *tabBarController;
    
    UIView                  *dummyView;
    UIView                  *activityView;
    
    BOOL                    isInitialDataLoaded;
    BOOL                    updateErrorAlertViewShown;
    
    NSMutableArray          *queueConnectionsArray;
}

@property (nonatomic, retain) IBOutlet UIWindow             *window;
@property (nonatomic, retain) IBOutlet UITabBarController   *tabBarController;

@property (nonatomic, readwrite) BOOL                       isInitialDataLoaded;
@property (nonatomic, readwrite) BOOL                       updateErrorAlertViewShown;

@property (nonatomic, retain) NSMutableArray                *queueConnectionsArray;

- (void)setLocalizedTitlesForTabBarItems;
- (BOOL)languageHasChanged;
- (BOOL)userIsLogged;
- (void)showConnectionErrorAlertView;
- (void)showUpdateDataErrorAlertViewWithError:(NSError *)error;

//Public refresh methods
- (void)refreshMailData;
- (void)refreshNewsData;
- (void)refreshAvisosData;
- (void)refreshFibSubjectsData;
- (void)refreshFibSubjectsDataAlways;
- (void)refreshRacoSubjectsData;
- (void)refreshOccupationSubjectDataAlways;
- (void)refreshOccupationData;
- (void)refreshOccupationSubjectData;
- (void)refreshAgendaData;
- (void)refreshAgendaDataAlways;
- (void)refreshScheduleData;
- (void)refreshScheduleDataAlways;

//Services methods
- (void)downloadInitialServices;
- (void)postNotificationForInitialDataLoaded;
- (BOOL)isInitialDataLoaded;


@end
