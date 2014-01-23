//
//  PersistenceController.h
//  iRaco
//
//  Created by Marcel Arbó Lack on 14/05/11.
//  Copyright 2011 FIB-Fàcultat d'informàtica de Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersistenceController : NSObject {
    
}

//Method to load Persistence Data stored in property list files
+ (void)loadPersistenceData;

//Method to save Persistence Data to property list files
+ (void)savePersistenceData;

@end
