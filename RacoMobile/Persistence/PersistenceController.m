//
//  PersistenceController.m
//  iRaco
//
//  Created by Marcel Arbó Lack on 14/05/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import "PersistenceController.h"
#import "RacoMobileAppDelegate.h"
#import "MailHandler.h"
#import "NewsHandler.h"
#import "AvisosHandler.h"
#import "RacoSubjectsHandler.h"
#import "FibSubjectsHandler.h"
#import "OccupationHandler.h"
#import "OccupationSubjectHandler.h"
#import "ScheduleHandler.h"
#import "AgendaIcsHandler.h"
#import "Defines.h"

#pragma mark - Defines

#define kPersistencePlistFile   @"persistence.plist"

#define kMailsIndex             0
#define kNewsIndex              1
#define kAvisosIndex            2
#define kRacoSubjectsIndex      3
#define kFibSubjectsIndex       4
#define kFibSubjectsDetailIndex 5
#define kOccupationIndex        6
#define kOccupationSubjectIndex 7
#define kScheduleIndex          8
#define kAgendaIndex            9


@implementation PersistenceController

+ (void)loadPersistenceData {
    
    NSString *errorDesc = @"";
    NSPropertyListFormat format;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];	
	NSString *plistPath = [rootPath stringByAppendingPathComponent:kPersistencePlistFile];
    
    NSMutableArray *persistenceArray;
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    if (plistXML) {
        persistenceArray = [(NSMutableArray *)[NSPropertyListSerialization
                                               propertyListFromData:plistXML
                                               mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                               format:&format
                                               errorDescription:&errorDesc] retain];
        if (!persistenceArray) {
            DLog(@"Error reading plist: %@, format: %d", errorDesc, format);			
        }
    }
    else {
        DLog(@"The Persistence plist file doesn't exist.");
        persistenceArray = [[NSMutableArray alloc] init];
    }
    
    
    if ([persistenceArray count] > 0) {
        
        NSDictionary *mailsDict = [persistenceArray objectAtIndex:kMailsIndex];
        [[MailHandler sharedHandler] saveMailDict:mailsDict];
        [[MailHandler sharedHandler] saveMailsObjects:mailsDict];
        
        NSDictionary *newsDict = [persistenceArray objectAtIndex:kNewsIndex];
        [[NewsHandler sharedHandler] saveNewsDict:newsDict];
        [[NewsHandler sharedHandler] saveNewsObjects:newsDict];

        NSDictionary *avisosDict = [persistenceArray objectAtIndex:kAvisosIndex];
        [[AvisosHandler sharedHandler] saveAvisosDict:avisosDict];
        [[AvisosHandler sharedHandler] saveAvisosObjects:avisosDict];
        
        //Post Notification for Initial Data Loaded
        DLog(@"post notification Persistence for allHeadLinesDataLoaded");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allHeadlinesDataLoaded" object:self];
        //Set TRUE bool isInitialDataLoaded property from AppDelegate
        RacoMobileAppDelegate *delegate = (RacoMobileAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate setIsInitialDataLoaded:TRUE];
        
        NSDictionary *racoSubjectsDict = [persistenceArray objectAtIndex:kRacoSubjectsIndex];
        [[RacoSubjectsHandler sharedHandler] saveRacoSubjectsDict:racoSubjectsDict];
        [[RacoSubjectsHandler sharedHandler] saveRacoSubjectsObjects:racoSubjectsDict];
        
        NSDictionary *fibSubjectsDict = [persistenceArray objectAtIndex:kFibSubjectsIndex];
        [[FibSubjectsHandler sharedHandler] saveFibSubjectsDict:fibSubjectsDict];
        [[FibSubjectsHandler sharedHandler] saveFibSubjectsObjects:fibSubjectsDict];
        
        NSArray *fibSubjectDetailDict = [persistenceArray objectAtIndex:kFibSubjectsDetailIndex];
        [[FibSubjectDetailHandler sharedHandler] saveFibSubjectDetailDict:fibSubjectDetailDict];
        [[FibSubjectDetailHandler sharedHandler] saveFibSubjectDetailObject:fibSubjectDetailDict];
        
        NSDictionary *occupationDict = [persistenceArray objectAtIndex:kOccupationIndex];
        [[OccupationHandler sharedHandler] saveFreePlacesDict:occupationDict];
        [[OccupationHandler sharedHandler] saveFreePlacesObjects:occupationDict];
        
        NSDictionary *occupationSubjectDict = [persistenceArray objectAtIndex:kOccupationSubjectIndex];
        [[OccupationSubjectHandler sharedHandler] savePlacesSubjectDict:occupationSubjectDict];
        [[OccupationSubjectHandler sharedHandler] saveplacesSubjectObjects:occupationSubjectDict];
        
        NSDictionary *scheduleDict = [persistenceArray objectAtIndex:kScheduleIndex];
        [[ScheduleHandler sharedHandler] saveScheduleDict:scheduleDict];
        [[ScheduleHandler sharedHandler] saveScheduleObjects:scheduleDict];
        
        NSDictionary *agendaDict = [persistenceArray objectAtIndex:kAgendaIndex];
        [[AgendaIcsHandler sharedHandler] saveAgendaDict:agendaDict];
        [[AgendaIcsHandler sharedHandler] saveAgendaObjects:agendaDict];
        
    }
    [persistenceArray release];
}


+ (void)savePersistenceData {
    
    //Persistence Array
    NSMutableArray *persistenceArray = [[NSMutableArray alloc] init];
        
    //Get Data from Handlers
    NSDictionary *mailsDict = [[MailHandler sharedHandler] mailsDict];
    if (!mailsDict) mailsDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:mailsDict];
    
    NSDictionary *newsDict = [[NewsHandler sharedHandler] newsDict];
    if (!newsDict) newsDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:newsDict];
    
    NSDictionary *avisosDict = [[AvisosHandler sharedHandler] avisosDict];
    if (!avisosDict) avisosDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:avisosDict];
    
    NSDictionary *racoSubjectsDict = [[RacoSubjectsHandler sharedHandler] racoSubjectsDict];
    if (!racoSubjectsDict) racoSubjectsDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:racoSubjectsDict];
    
    NSDictionary *fibSubjectsDict = [[FibSubjectsHandler sharedHandler] fibSubjectsDict];
    if (!fibSubjectsDict) fibSubjectsDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:fibSubjectsDict];
    
    NSArray *fibSubjectDetailDict = [[FibSubjectDetailHandler sharedHandler] fibSubjectsDetailDict];
    if (!fibSubjectDetailDict) fibSubjectDetailDict = [[[NSArray alloc] init] autorelease];
    [persistenceArray addObject:fibSubjectDetailDict];
    
    NSDictionary *occupationDict = [[OccupationHandler sharedHandler] freePlacesArrayDict];
    if (!occupationDict) occupationDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:occupationDict];
    
    NSDictionary *occupationSubjectDict = [[OccupationSubjectHandler sharedHandler] placesSubjectDict];
    if (!occupationSubjectDict) occupationSubjectDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:occupationSubjectDict];
   
    NSDictionary *scheduleDict = [[ScheduleHandler sharedHandler] scheduleDict];
    if (!scheduleDict) scheduleDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:scheduleDict];
    
    NSDictionary *agendaDict = [[AgendaIcsHandler sharedHandler] agendaDict];
    if (!agendaDict) agendaDict = [[[NSDictionary alloc] init] autorelease];
    [persistenceArray addObject:agendaDict];
    
	//Save Data to .plist
	NSString *error;	
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:persistenceArray
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
	
	if (plistData) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0) {
			DLog(@"Found a path");
			NSString *userDirectoryPath = [paths objectAtIndex:0];			
			BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:userDirectoryPath];
			if (!exists) {
                BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:userDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil];
				//BOOL create = [[NSFileManager defaultManager] createDirectoryAtPath:userDirectoryPath attributes:nil];
				if (!create) {
					DLog(@"Can't create file '%@'!",userDirectoryPath);
				}
			}
			NSString *plistPath = [userDirectoryPath stringByAppendingPathComponent:kPersistencePlistFile];						
			BOOL plistSaveSuccesful = [persistenceArray writeToFile:plistPath atomically:YES];
			if (plistSaveSuccesful) {
				DLog(@"Info: The plist was saved in %@ :)", plistPath);
			} else {
				DLog(@"Error: The plist was NOT saved! :(");
			}
		} else {
			//something went really wrong
		}	
	} else {
		DLog(@"error: %@",error);
		[error release];
	}
    [persistenceArray release];
}

@end
