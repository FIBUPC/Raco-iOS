//
//  RacoMobileAppDelegate.m
//  RacoMobile
//
//  Created by Marcel Arbó Lack on 01/08/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "RacoMobileAppDelegate.h"
#import "RacoMobileAppDelegate+ActivityView.h"
#import "Defines.h"
#import "InitialViewController.h"
#import "FibViewController.h"
#import "RacoViewController.h"
#import "SettingsViewController.h"
#import "Reachability.h"
#import "Mail.h" 
#import "NewRss.h"
#import "Avis.h"
#import "Subject.h"
#import "IcalEvent.h"
#import "PersistenceController.h"

@interface RacoMobileAppDelegate ()
- (void)setDefaultLanguage;
- (void)controlUserLogin;
- (void)setInitialItemsPriority;
- (void)startCrashReportLogging;
- (void)dataServicesInitialization;

- (void)checkForInitialDataLoaded;
- (void)postNotificationForInitialDataLoaded;
- (void)checkForOtherDataLoaded;
- (void)postNotificationForOtherDataLoaded;
- (void)postNotificationForFibSubjectsDataLoaded;
@end

@implementation RacoMobileAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;
@synthesize isInitialDataLoaded, updateErrorAlertViewShown;
@synthesize queueConnectionsArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self setDefaultLanguage];
    
    [self controlUserLogin];
    
    [self setInitialItemsPriority];
    
    [self startCrashReportLogging];
    
    // Add the tabBar controller's view to the window and display.
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    //Set BOOL updateErrorAlertViewShown to FALSE
    updateErrorAlertViewShown = NO;
    
    [self showActivityViewer:NSLocalizableString(@"_loadingPersistentData")];
    //Show NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelector:@selector(dataServicesInitialization) withObject:nil afterDelay:0.1];    
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    //Save selected Language
    NSString *selectedLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguagePrefKey];
    [[NSUserDefaults standardUserDefaults] setObject:selectedLanguage forKey:kOldLanguagePrefKey];
    
    //Call to save info to plist files
    [PersistenceController savePersistenceData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    //Set the Localized title for each TabBarItem
    [self setLocalizedTitlesForTabBarItems];
    
    //Syncronize NSUserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Compare Actual Language with Old Selected Language
    if ([self languageHasChanged]) {
        //Set Localized Titles for TabBarItems
        [self setLocalizedTitlesForTabBarItems];
        
        //Set Localizeb Titles for selectedTabBar view controller
        [[[[[[self tabBarController] viewControllers] objectAtIndex:0] viewControllers] objectAtIndex:0] viewWillAppear:YES];
        [[[[[[self tabBarController] viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:0] viewWillAppear:YES];
        [[[[[[self tabBarController] viewControllers] objectAtIndex:2] viewControllers] objectAtIndex:0] viewWillAppear:YES];
        [[[[[[self tabBarController] viewControllers] objectAtIndex:3] viewControllers] objectAtIndex:0] viewWillAppear:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [self setQueueConnectionsArray:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"allFibSubjectsLoaded" object:nil];
    [super dealloc];
}

#pragma mark - didFinishLaunchingWithOptions Private Methods

- (void)setDefaultLanguage {    
    //Control if Default Laguage is selected at First Time
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLanguagePrefKey] == nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:kLanguagePrefKey];
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:kOldLanguagePrefKey];
        
        //Select the device locale language if exist, else, set to "en".
        NSString *deviceLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        BOOL langExist = ([deviceLanguage isEqualToString:@"en"] || [deviceLanguage isEqualToString:@"es"] || [deviceLanguage isEqualToString:@"ca"]);
        if (langExist) {
            //Set as devideLanguage as default app language
            [[NSUserDefaults standardUserDefaults] setObject:deviceLanguage forKey:kLanguagePrefKey];
            [[NSUserDefaults standardUserDefaults] setObject:deviceLanguage forKey:kOldLanguagePrefKey];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)controlUserLogin {
    //Control if logged on. " logged / not_logged "
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kisLoggedKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:kNotLoggedKey forKey:kisLoggedKey];
    }
}

- (void)setInitialItemsPriority {
    //Set InitialItems priority only first time ever
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isPriorized"] == nil) {
        
        //Set InitialItems default index for priority only first time ever
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kMailKey];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kNoticesKey];
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:kNewsKey];
        
        //Set InitialItems default object for section only first time ever
        [[NSUserDefaults standardUserDefaults] setObject:kMailKey    forKey:@"section0"];
        [[NSUserDefaults standardUserDefaults] setObject:kNoticesKey forKey:@"section1"];
        [[NSUserDefaults standardUserDefaults] setObject:kNewsKey    forKey:@"section2"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Priorized" forKey:@"isPriorized"];
    }
}

- (void)startCrashReportLogging {
    // Start crash report logging
    [MVYCrashReport reportCrashesUsingTitle:NSLocalizableString(@"_detected_crash") message:NSLocalizableString(@"_notify_developers") andSubject:kCRASH_REPORT_TITLE toRecipients:[NSArray arrayWithObject:kCRASH_REPORT_MAIL]];
    [[MVYCrashReport sharedInstance] startCrashLoggingWithDelegate:self];
    [[MVYCrashReport sharedInstance] checkPendingCrashReport];
}

- (void)dataServicesInitialization {
    //PreLoad persisted data
    DLog(@"call to loadPersitenceData");
    [PersistenceController loadPersistenceData];
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {	
        
        //Call to download services
        DLog(@"Call downloadInitialServices");
        [self downloadInitialServices];
        
	} else {
        //Show alert with not internet connection
        [self showConnectionErrorAlertView];
    }
}

#pragma mark - Public Methods

- (void)setLocalizedTitlesForTabBarItems {
    //Set the Localized title for each TabBarItem
    [[[[self tabBarController] viewControllers] objectAtIndex:0] setTitle:NSLocalizableString(@"_portada")];
    [[[[self tabBarController] viewControllers] objectAtIndex:1] setTitle:NSLocalizableString(@"_fib")];
    [[[[self tabBarController] viewControllers] objectAtIndex:2] setTitle:NSLocalizableString(@"_raco")];
    [[[[self tabBarController] viewControllers] objectAtIndex:3] setTitle:NSLocalizableString(@"_settings")];
}

- (BOOL)languageHasChanged {
    //Compare Actual Language with Old Selected Language
    NSString *oldLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kOldLanguagePrefKey];
    NSString *actualLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguagePrefKey];
    
    return ![oldLanguage isEqualToString:actualLanguage];
}

- (BOOL)userIsLogged {
    //Check if user is logged
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    DLog(@"isLogged IN is: %@: ",[userDefaults objectForKey:kisLoggedKey]);
    BOOL logged = [[[NSUserDefaults standardUserDefaults] objectForKey:kisLoggedKey] isEqualToString:kLoggedKey];
    
    return logged;
}

- (void)showConnectionErrorAlertView {
    UIAlertView *connectionErrorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizableString(@"_internetError_title") 
                                                                       message:NSLocalizableString(@"_internetError_message") 
                                                                      delegate:self cancelButtonTitle:NSLocalizableString(@"_ok") 
                                                             otherButtonTitles: nil];
    [connectionErrorAlertView show];
    [connectionErrorAlertView release];
    
    //HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
}

- (void)showUpdateDataErrorAlertViewWithError:(NSError *)error {
    
    if (!updateErrorAlertViewShown) {
        UIAlertView *updateDataErrorAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizableString(@"_errorTitle")      //[error localizedDescription] 
                                                                           message:NSLocalizableString(@"_errorMessage")    //[error localizedFailureReason] 
                                                                          delegate:self cancelButtonTitle:NSLocalizableString(@"_ok") 
                                                                 otherButtonTitles: nil];
        [updateDataErrorAlertView show];
        [updateDataErrorAlertView release];
        
        updateErrorAlertViewShown = YES;
        //HideActivityViewer
        RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate hideActivityViewer];
    }
}

#pragma mark - Services Methods

- (void)downloadInitialServices {
    DLog(@" downloadInitialServices called in Appdelegate");
    
    //Set BOOL updateErrorAlertViewShown to FALSE
    updateErrorAlertViewShown = NO;
    
    //Download All Services    
    //Initialize queueConnectionsArray
    queueConnectionsArray = [[NSMutableArray alloc] init];
    
    [self showActivityViewer];
    //Show NetworkActivityIndicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    bool logged = [self userIsLogged];
    
    //Launch connections with priority
    //Added objects to queue for Initial services control
    //Launch first InitialViewController info.
    [self refreshNewsData];
    
    if (logged) {
        [self refreshMailData];
        
        [self refreshAvisosData];
    }
}

- (void)downloadOtherServices {
    
    bool logged = [self userIsLogged];
    
    //Launch then other info    
    if (logged) {
        [self refreshRacoSubjectsData];
        
        [self refreshAgendaData];
        
        [self refreshScheduleData];
    }
    
    [self refreshOccupationData];
    
    [self refreshOccupationSubjectData];
    
    [self refreshFibSubjectsData];
}

- (void)refreshMailData {
    [queueConnectionsArray addObject:@"mail"];
    
    MailHandler *mailHandler = [MailHandler sharedHandler];
    mailHandler.delegate = self;
    [mailHandler startProcess];
}

- (void)refreshNewsData {
    [queueConnectionsArray addObject:@"newRss"];
    
    NewsHandler *newsHandler = [NewsHandler sharedHandler];
	newsHandler.delegate = self;
	[newsHandler startProcess];
    
}

- (void)refreshAvisosData {
    [queueConnectionsArray addObject:@"avisos"];
    
    AvisosHandler *avisosHandler = [AvisosHandler sharedHandler];
    avisosHandler.delegate = self;
    [avisosHandler startProcess];
}

- (void)refreshFibSubjectsData {
    
    //Check if fibSubjectsArray is empty. We do this check because we only get this info at first time on App. 
    //Then the user can refresh manually in FibTab/FibSubjects/FibSubjectsViewController
    BOOL fibSubjectsExist = [[[FibSubjectsHandler sharedHandler] fibSubjects] count] > 0;
    if (!fibSubjectsExist) {
        [self refreshFibSubjectsDataAlways];
    }
}

- (void)refreshFibSubjectsDataAlways {
    //Regiter Notification for self
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFibSubjectDetailData) name:@"allFibSubjectsLoaded" object:nil];
    
    [queueConnectionsArray addObject:@"fibSubjects"];
    
    FibSubjectsHandler *fibSubjectsHandler = [FibSubjectsHandler sharedHandler];
    fibSubjectsHandler.delegate = self;
    [fibSubjectsHandler startProcess];
}

- (void)refreshFibSubjectDetailData {
    
    //Remove all FibSubjectDetail
    [[[FibSubjectDetailHandler sharedHandler] fibSubjectsDetail] removeAllObjects];
    
    NSMutableArray *tempFibSubects = [[NSMutableArray alloc] initWithArray:[[FibSubjectsHandler sharedHandler] fibSubjects]];
    NSString *aTag;
    
    int i = 1;
    int maxSubjects = [tempFibSubects count];
    for (Subject *aSubject in tempFibSubects) {
        
        //Not used because we can't control to remove one subject tag when it fail
        //[queueConnectionsArray addObject:[NSString stringWithFormat:@"fibSubjectDetail_%@",[aSubject idAssig]]];
        //DLog(@"adding %@", [NSString stringWithFormat:@"fibSubjectDetail_%@",[aSubject idAssig]]);
        
        aTag = [aSubject codi_upc];
        
        FibSubjectDetailHandler *fibSubjectDetailHandler = [FibSubjectDetailHandler sharedHandler];
        fibSubjectDetailHandler.delegate = self;
        [fibSubjectDetailHandler startProcessWithTag:aTag maxSubjects:maxSubjects];
        
        i++;
    }
    [tempFibSubects release];
}

- (void)refreshRacoSubjectsData {
    [queueConnectionsArray addObject:@"racoSubjects"];
    
    RacoSubjectsHandler *racoSubjectsHandler = [RacoSubjectsHandler sharedHandler];
    racoSubjectsHandler.delegate = self;
    [racoSubjectsHandler startProcess];
}

- (void)refreshOccupationData {
    [queueConnectionsArray addObject:@"occupation"];
    
    OccupationHandler *occupationHandler = [OccupationHandler sharedHandler];
	occupationHandler.delegate = self;
	[occupationHandler startProcess];
}

- (void)refreshOccupationSubjectData {
    //Check if occupationSubjectData is empty. We do this check because we only get this info at first time on App. 
    //Then the user can refresh manually in FibTab/Occupation/OccupationDetailViewController
    BOOL occupationSubjectExist = [[[OccupationSubjectHandler sharedHandler] placesSubject] count] > 0;
    if (!occupationSubjectExist) {
        [self refreshOccupationSubjectDataAlways];
    }
}

- (void)refreshOccupationSubjectDataAlways {
    [queueConnectionsArray addObject:@"occupationSubject"];
    
    OccupationSubjectHandler *occupationSubjectHandler = [OccupationSubjectHandler sharedHandler];
	occupationSubjectHandler.delegate = self;
	[occupationSubjectHandler startProcess];
}


- (void)refreshAgendaData {
    //Check if AgendaData is empty. We do this check because we only get this info at first time on App. 
    //Then the user can refresh manually in RacoTab/Agenda/AgendaViewController
    BOOL agendaExist = [[[AgendaIcsHandler sharedHandler] agenda] count] > 0;
    if (!agendaExist) {
        [self refreshAgendaDataAlways];
    }
}

- (void)refreshAgendaDataAlways {
    [queueConnectionsArray addObject:@"agenda"];
    
    AgendaIcsHandler *agendaIcsHandler = [AgendaIcsHandler sharedHandler];
    agendaIcsHandler.delegate = self;
    [agendaIcsHandler startProcess];
}

- (void)refreshScheduleData {
    //Check if ScheduleData is empty. We do this check because we only get this info at first time on App. 
    //Then the user can refresh manually in RacoTab/Schedule/ScheduleViewController
    BOOL scheduleExist = [[[ScheduleHandler sharedHandler] schedule] count] > 0;
    if (!scheduleExist) {
        [self refreshScheduleDataAlways];
    }
}

- (void)refreshScheduleDataAlways {
    [queueConnectionsArray addObject:@"schedule"];
    
    ScheduleHandler *scheduleHandler = [ScheduleHandler sharedHandler];
    scheduleHandler.delegate = self;
    [scheduleHandler startProcess];
}

#pragma mark - Private Methods

- (void)checkForInitialDataLoaded {
    DLog(@"initial queue count = %i", [queueConnectionsArray count]);
    if ([queueConnectionsArray count] == 0) {
        [self postNotificationForInitialDataLoaded];
    }
}

- (BOOL)isInitialDataLoaded {
    return isInitialDataLoaded;
}

- (void)postNotificationForInitialDataLoaded {
    
    isInitialDataLoaded = TRUE;
    
    DLog(@"post notification APPDelegate for allHeadLinesDataLoaded");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allHeadlinesDataLoaded" object:self];
    
    //Call to download Other Services (Not Initial)
    DLog(@"Call to downloadOtherServices");
    [self downloadOtherServices];
}

- (void)checkForOtherDataLoaded {
    DLog(@"other queue count = %i", [queueConnectionsArray count]);
    if ([queueConnectionsArray count] == 0) {
        [self postNotificationForOtherDataLoaded];
    }
}

- (void)postNotificationForOtherDataLoaded {
    
    DLog(@"post notification APPDelegate for otherDataLoaded");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"otherDataLoaded" object:self];
    
    //HideActivityViewer
    RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate hideActivityViewer];
}

- (void)postNotificationForFibSubjectsDataLoaded {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allFibSubjectsLoaded" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - DelegateMethods

#pragma mark - MVYCrashResport Delegate

- (void)displayMailComposer:(MFMailComposeViewController *)mailViewController {
    [mailViewController setMailComposeDelegate:self];
    int selected = [tabBarController selectedIndex];
    [[[[self tabBarController] viewControllers] objectAtIndex:selected] presentModalViewController:mailViewController animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	// Notifies users about errors associated with the interface
    NSString *message;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = NSLocalizableString(@"_email_canceled");
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizableString(@"_email_saved");
			break;
		case MFMailComposeResultSent:
			message = NSLocalizableString(@"_email_sent");
            [[MVYCrashReport sharedInstance] mailSentSuccessfully];
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizableString(@"_email_failed");
			break;
		default:
			message = NSLocalizableString(@"_email_not_sent");
			break;
	}
    
    int selected = [tabBarController selectedIndex];
	[[[[self tabBarController] viewControllers] objectAtIndex:selected] dismissModalViewControllerAnimated:YES];
    
    //Show alertView with result
    UIAlertView *mailResultAlert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                              message:message 
                                                             delegate:self 
                                                    cancelButtonTitle:NSLocalizableString(@"_ok") 
                                                    otherButtonTitles:nil];
    [mailResultAlert show];
    [mailResultAlert release];
}


#pragma mark MailDelegate

- (void)mailProcessCompleted:(NSMutableArray *)mails {	
	DLog(@"mailProcessCompleted!");
    
    [queueConnectionsArray removeObject:@"mail"];
    
    [self checkForInitialDataLoaded];
}

- (void)mailProcessHasErrors:(NSError *)error{
    DLog(@"mailProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"mail"];
    
    [self checkForInitialDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark NewsDelegate

- (void)newRssProcessCompleted:(NSMutableArray *)news {
    DLog(@"newRssProcessCompleted!");
    
    [queueConnectionsArray removeObject:@"newRss"];
    
    [self checkForInitialDataLoaded];
}

- (void)newRssProcessHasErrors:(NSError *)error{
    
    DLog(@"newRssProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"newRss"];
    
    [self checkForInitialDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark AvisosDelegate

- (void)avisosProcessCompleted:(NSMutableArray *)avisos {
    DLog(@"avisosProcessCompleted!");
    
    [queueConnectionsArray removeObject:@"avisos"];
    
    [self checkForInitialDataLoaded];
}

- (void)avisosProcessHasErrors:(NSError *)error{
    
    DLog(@"avisosProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"avisos"];
    
    [self checkForInitialDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark FibSubjectsDelegate

- (void)FibSubjectsProcessCompleted:(NSMutableArray *)fibSubjects {
    DLog(@"FibSubjectsProcessCompleted!");
    
    [queueConnectionsArray removeObject:@"fibSubjects"];
    
    //Dont call to checkForOtherDataLoaded because it will call a while for each detail now
    
    [self postNotificationForFibSubjectsDataLoaded];
}

- (void)FibSubjectsProcessHasErrors:(NSError *)error {
    DLog(@"FibSubjectsProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"fibSubjects"];
    
    [self checkForOtherDataLoaded];
    
    [self postNotificationForFibSubjectsDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark FibSubjectDetailDelegate

- (void)FibSubjectDetailProcessCompleted:(Subject *)aSubject {
    DLog(@"FibSubjectDetailProcessCompleted!");
    
    //Not used because we can't remove one subject tag when it fail
    //[queueConnectionsArray removeObject:[NSString stringWithFormat:@"fibSubjectDetail_%@",[aSubject idAssig]]];
    
    [self checkForOtherDataLoaded];
}

- (void)FibSubjectDetailProcessHasErrors:(NSError *)error {
    DLog(@"FibSubjectDetailProcessHasErrors!");
    
    [self checkForOtherDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark RacoSubjectsDelegate

- (void)RacoSubjectsProcessCompleted:(NSMutableArray *)racoSubjects {
    DLog(@"RacoSubjectsProcessCompleted!");
    
    [queueConnectionsArray removeObject:@"racoSubjects"];
    
    [self checkForOtherDataLoaded];
}

- (void)RacoSubjectsProcessHasErrors:(NSError *)error {
    DLog(@"RacoSubjectsProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"racoSubjects"];
    
    [self checkForOtherDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark OccupationDelegate

- (void)OccupationProcessCompleted:(NSMutableArray *)freePlacesArray {
    DLog(@"OccupationProcessCompleted!");
    
    [queueConnectionsArray removeObject:@"occupation"];
    
    [self checkForOtherDataLoaded];
}

- (void)OccupationProcessHasErrors:(NSError *)error {
    DLog(@"OccupationProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"occupation"];
    
    [self checkForOtherDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark OccupationSubjectDelegate

- (void)OccupationSubjectProcessCompleted:(NSMutableArray *)placesSubjectArray{
    DLog(@"OccupationSubjectProcessCompleted!");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"occupationSubjectDataLoaded" object:self];
    
    [queueConnectionsArray removeObject:@"occupationSubject"];
    
    [self checkForOtherDataLoaded];
    
    //Save  actual OccupationUpdatedDate to user defaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"OccupationUpdatedDate"];
}
- (void)OccupationSubjectProcessHasErrors:(NSError *)error{
    DLog(@"OccupationSubjectProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"occupationSubject"];
    
    [self checkForOtherDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark AgendaDelegate

-(void)agendaProcessCompleted:(NSMutableArray *)agendaEvents {
    DLog(@"agendaProcessCompleted!");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"agendaDataLoaded" object:self];
    
    [queueConnectionsArray removeObject:@"agenda"];
    
    [self checkForOtherDataLoaded];
    
    //Save  actual AgendaUpdatedDate to user defaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"AgendaUpdatedDate"];
}
-(void)agendaProcessHasErrors:(NSError *)error {
    DLog(@"agendaProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"agenda"];
    
    [self checkForOtherDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}

#pragma mark ScheduleDelegate

-(void)scheduleProcessCompleted:(NSMutableArray *)scheduleEvents {
    DLog(@"scheduleProcessCompleted!");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scheduleDataLoaded" object:self];
    
    [queueConnectionsArray removeObject:@"schedule"];
    
    [self checkForOtherDataLoaded];
    
    //Save  actual ScheduleUpdatedDate to user defaults
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"ScheduleUpdatedDate"];
}
-(void)scheduleProcessHasErrors:(NSError *)error {
    DLog(@"scheduleProcessHasErrors!");
    
    [queueConnectionsArray removeObject:@"schedule"];
    
    [self checkForOtherDataLoaded];
    
    [self showUpdateDataErrorAlertViewWithError:error];
}


@end
