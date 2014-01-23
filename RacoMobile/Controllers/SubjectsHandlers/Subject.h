//
//  Subject.h
//  iRaco
//
//  Created by Marcel Arbó on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - constants
#define kSubjectIdAssig     @"idAssig"
#define kSubjectCodiUPC     @"codi_upc"
#define kSubjectNom         @"nom"
#define kSubjectCredits     @"credits"
#define kSubjectProfessors  @"professors"
#define kSubjectDescripcio  @"descripcio"
#define kSubjectBibliografia  @"bibliografia"
#define kSubjectBibliografiaText  @"text"
#define kSubjectBibliografiaLink  @"url"
#define kSubjectBibliografiaComplementaria  @"bibliografiaComplementaria"

#pragma mark -


@interface Subject : NSObject {
    NSString        *idAssig;
    NSString        *codi_upc;
    NSString        *nom;
    NSString        *credits;
    NSDictionary    *professors;
    NSDictionary    *descripcio;
    NSDictionary    *bibliografia;
    NSDictionary    *bibliografiaComplementaria;
}

@property (nonatomic, retain) NSString *idAssig;
@property (nonatomic, retain) NSString *codi_upc;
@property (nonatomic, retain) NSString *nom;
@property (nonatomic, retain) NSString *credits;
@property (nonatomic, retain) NSDictionary *professors;
@property (nonatomic, retain) NSDictionary *descripcio;
@property (nonatomic, retain) NSDictionary *bibliografia;
@property (nonatomic, retain) NSDictionary *bibliografiaComplementaria;

- (id)initWithDictionary:(NSDictionary *)aDict;


@end
