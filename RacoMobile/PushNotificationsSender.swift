//
//  PushNotificationsSender.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 02/03/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA0bajeh0:APA91bF1P6G-w9sM0B7LArbpxwopXFb6y0oHfl6aXauxiUHkYLziqzbiN2IAWjHrzY93CLzW9951zIoD5rWn7t-yZY0fPj5Yo7_ZIZ67zbmLnTLSqxWhY6SUqUUsbaheHzyJHpiqWApT", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
