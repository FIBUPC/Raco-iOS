//
//  Defines.h
//  iRaco
//
//  Created by Marcel Arbó on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#pragma mark - Macros

// Only print Log in debug Mode (note: activate -DDEBUG in "other C flags")
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#pragma mark - LocalizedSrings

//Defines for LocalizedStrings
#define SELECTED_LANGUAGE [[NSUserDefaults standardUserDefaults] objectForKey:kLanguagePrefKey]
#define NSLocalizableString(key) [[NSBundle mainBundle] localizedStringForKey:key value:key table:SELECTED_LANGUAGE]

#pragma mark - MyConstants

//Defines for Constants

//COnstants for CrashReport
#define kCRASH_REPORT_MAIL      @"inlab@fib.upc.edu"
#define kCRASH_REPORT_TITLE     @"[CRASH] RacoMobile iOS Crash Report"

//Constants for InitialViewController
#define KMaxNumberItems @"5"

//Constats for UserKeys
#define kIcalPortadaIcsKey          @"icalPortadaIcsKey"
#define kIcalHorariIcsKey           @"icalHorariIcsKey"
#define kRssAvisosAssignaturesKey   @"rssAvisosAssignaturesKey"
#define kRacoSubjectsKey            @"racoSubjectsKey"

//Constants for User Keys Text
#define kIcalPortadaIcs         @"/ical/portada.ics"
#define kIcalHorariIcs          @"/ical/horari.ics"
#define KRssAvisosAssignatures  @"/extern/rss_avisos.jsp"
#define kRacoSubjects           @"/api/assigList"
#define kIcalPortadaRss         @"/ical/portada.rss"                    //Not used
#define kForumRecentTopics      @"/forum/rss/recentTopics.page.key"     //Not used (forums)
#define kClauMestre             @"/extern/raco.webservices.KeyList"     //Not used

#pragma mark -
#pragma mark ViewControllers

#pragma mark - User Constats

#define kLanguagePrefKey    @"languagePref"
#define kOldLanguagePrefKey @"oldLanguagePref"

#define kLoggedKey      @"logged"
#define kNotLoggedKey   @"not_logged"
#define kisLoggedKey    @"isLogged"


#pragma mark - Initial & InitialSettings

#define kMailKey    @"Mail"
#define kNoticesKey @"Notices"
#define kNewsKey    @"News"

 
#pragma mark - FIBTab

//Constants for NewRssParser
#define kNewRssParserUrl    @"http://www.fib.upc.edu/fib/rss.rss"
#define kNewRssXMLTag       @"item"

//Constants for OccupationViewController
#define kA5PNGUrl   @"http://www.fib.upc.edu/mapa.php?mod=a5"
#define KA5Tag      @"a5"
#define kB5PNGUrl   @"http://www.fib.upc.edu/mapa.php?mod=b5"
#define KB5Tag      @"b5"
#define kC6PNGUrl   @"http://www.fib.upc.edu/mapa.php?mod=c6"
#define KC6Tag      @"c6"

//Constants for FibSubjectsViewController
#define kFibSubjectsUrl @"https://raco.fib.upc.edu/api/assigListFIB?KEY=public"

//Constants for FibSubjectDetailViewController
#define kFibSubjectDetailUrl @"https://raco.fib.upc.edu/api/InfoAssigFIB?KEY=public&"

//Constants for FibViewController
#define kBibliotecaUrl @"http://m.bibliotecnica.upc.edu/BRGF"


#pragma mark - RacoTab

//Constants for RacoSubjectsViewController
#define kRacoSubjectsUrl @"https://raco.fib.upc.edu/api/assigList?KEY="

//Constants for AvisosRacoSubjects
#define kAvisosRacoSubjectsUrl @"https://raco.fib.upc.edu/extern/rss_avisos.jsp?KEY="
#define kAvisosXMLTag @"item"


//Costants for AgendaIcsParser
#define kAgendaIcsParserUrl     @"https://raco.fib.upc.edu/ical/portada.ics?KEY="   
#define kAgendaIcsSyncronizeUrl @"webcal://raco.fib.upc.edu/ical/portada.ics?KEY="

//Costants for ScheduleParser
#define kScheduleParserUrl      @"https://raco.fib.upc.edu/ical/horari.ics?KEY="
#define kScheduleSyncronizeUrl  @"webcal://raco.fib.upc.edu/ical/horari.ics?KEY="

//Constants de temps (UMT)
#define kTimeZoneName @"Europe/Paris"
#define kLocaleIdentifier @"es_ES"

//Constants for MailParser
#define kMailParserUrl          @"https://webmail.fib.upc.edu/horde/imp/check_mail/resum_mail_json.php"
#define kMailParserMaxEmails    @"10"


#pragma mark - SettingsTab

//Constants for LoginViewController
#define kLoginViewControllerUrl @"https://raco.fib.upc.edu/cas/login?service=https://raco.fib.upc.edu/servlet/raco.webservices.KeyList&loginDirecte=true&"

//Constants for WifiProfileURL
#define kWifiProfileURL @"https://raco.fib.upc.edu/iphone/perfil-wifi?username="


#pragma mark - Parsers

//Constants for OccupationParser
#define kOccupationParserUrl @"https://raco.fib.upc.edu/api/aules/places-lliures.json"

//Constants for OccupationSubjectParser
#define kOccupationSubjectParserUrl @"https://raco.fib.upc.edu/ReservesWebApp/icsAvui.ics"


#pragma mark - Connections

//Constatnt for connections
#define kGetMethod  @"GET"
#define kPostMethod @"POST"

