//
//  TokenResponse.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 26/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire
import Alamofire_SwiftyJSON

class TokenResponse: NSObject {
    
    var accessToken: String = "access_token"
    var tokenType: String = "token_type"
    var expiresIn: Int = -1
    var refreshToken: String = "refresh_token"
    var scope: String = "scope"
    var isValid: Bool = false
    static var expiration: Date = Date()
    
    override init() {
    }
    
    init(access_token: String, token_type: String, expires_in: Int, refresh_token: String, scope: String) {
        self.accessToken = access_token
        self.tokenType = token_type
        self.expiresIn = expires_in
        self.refreshToken = refresh_token
        self.scope = scope
        TokenResponse.expiration = Date().addingTimeInterval(TimeInterval(expires_in))
        
        if (self.accessToken != "access_token") {
            self.isValid = true
        }
        
        KeychainWrapper.standard.set(self.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(self.tokenType, forKey: "tokenType")
        KeychainWrapper.standard.set(self.expiresIn, forKey: "expiresIn")
        KeychainWrapper.standard.set(self.refreshToken, forKey: "refreshToken")
        KeychainWrapper.standard.set(self.scope, forKey: "scope")
        KeychainWrapper.standard.set(self.isValid, forKey: "isValid")
    }
    
    static func isExpired() -> Bool {
        return (expiration >= Date())
    }
    
    static var request: Alamofire.Request?
    
    static func refreshOAuthToken(withCompletionHandler completionHandler: @escaping () -> Void) {
        let refreshParameters: Parameters = ["grant_type" : "refresh_token",
                                             "refresh_token": userToken.refreshToken,
                                             "client_id" : manager.clientID,
                                             "client_secret" : manager.clientSecret]
        if (userToken.isValid) {
            request = Alamofire.request(tokenURL, method: .post, parameters: refreshParameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                if (response.result.isSuccess) {
                    if let result = response.result.value {
                        let data = result as! NSDictionary
                        let userTokenData = TokenResponse(
                            access_token: data.object(forKey: "access_token") as! String,
                            token_type: data.object(forKey: "token_type") as! String,
                            expires_in: data.object(forKey: "expires_in") as! Int,
                            refresh_token: data.object(forKey: "refresh_token") as! String,
                            scope: data.object(forKey: "scope") as! String)
                        userToken = userTokenData
                        print("Updated successful")
                    }
                } else {
                    print("Token Request not success")
                }
            }
        }
        
        completionHandler()
    }
}
