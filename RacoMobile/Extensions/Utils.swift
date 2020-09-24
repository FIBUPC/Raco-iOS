//
//  Utils.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 26/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Foundation
import Reachability

class Utils: NSObject {
    class func date(_ date: Date?, isBetweenDate beginDate: Date?, andDate endDate: Date?) -> Bool {
        if let beginDate = beginDate {
            if date?.compare(beginDate) == .orderedAscending {
                return false
            }
        }
        
        if let endDate = endDate {
            if date?.compare(endDate) == .orderedDescending {
                return false
            }
        }
        
        return true
    }
    
    class func convertDateFormat(_ oldStringDate: String?) -> String? {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US_POSIX")
        dateFormat.dateFormat = "EEE, dd MMM y HH:mm:ss zzzzz" //"Wed, 06 Apr 2011 13:15:34 +0200"
        dateFormat.timeZone = .current
        
        let LargePubDate = dateFormat.date(from: oldStringDate ?? "")
        dateFormat.dateFormat = "dd/MM/YYYY HH:mm:ss" //"06/04/2011 13:15:34"
        var newStringDateDate: String? = nil
        if let LargePubDate = LargePubDate {
            newStringDateDate = dateFormat.string(from: LargePubDate)
        }
        
        return newStringDateDate
    }
    
    class func string(from _date: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateString: String? = nil
        if let _date = _date {
            dateString = dateFormatter.string(from: _date)
        }
        
        return dateString
    }
    
    class func stringWithHour(from _date: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        var dateString: String? = nil
        if let _date = _date {
            dateString = dateFormatter.string(from: _date)
        }
        
        return dateString
    }
    
    class func getDateFrom(_ stringDate: String?) -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US_POSIX")
        dateFormat.dateFormat = "dd'/'MM'/'y' 'HH:mm:ss" //"12/03/2011 10:00:00"
        dateFormat.timeZone = .current
        
        let globalDate = dateFormat.date(from: stringDate ?? "")
        return globalDate
    }
    
    class func flattenHTML(_ html: String?, trimWhiteSpace trim: Bool) -> String? {
        var html = html
        
        var theScanner: Scanner?
        var text: String? = nil
        
        theScanner = Scanner(string: html ?? "")
        
        while theScanner?.isAtEnd == false {
            
            // find start of tag
            let _: String = theScanner?.scanUpToString("<") ?? ""
            
            // find end of tag
            let endTag: String = theScanner?.scanUpToString(">") ?? ""
            
            text = endTag
            // replace the found tag with a space
            //(you can filter multi-spaces out later if you wish)
            html = html?.replacingOccurrences(of: "\(text ?? "")>", with: " ")
        }
        // trim off whitespace
        return trim ? html?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) : html
    }
}
