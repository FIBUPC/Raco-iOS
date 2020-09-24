//
//  RacoAPIManager.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 26/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import AuthenticationServices

class RacoAPIManager {
    public let baseURL: String = "https://api.fib.upc.edu/v2/"
    public let clientID: String = "PWsF7FtU2eeLBYRMaRJUrKpDzbZFLkMCDFvvcvc3"
    public let clientSecret: String = "uD7zOJlJhxIKCvMVLE58yH3Qq8ui4uzH0LcLZRsAObzfcgd43o6JTz3jwCAmFR6J1uvg1WPXiHA7k0wz2wfxfBbMMMDonk3fV9EBcurNa7BTvpJHU15kj5NpFdFkTQh9"
    public let redirectUri: String = "apifib://raco"
    public let responseType: String = "code"
    public let scope: String = "read"
    public let approval_prompt: String = "auto"
    public var state: String = ""
    
    public func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let saltStr: String = String((0..<16).map{ _ in letters.randomElement()! })
        state = saltStr;
        return saltStr;
    }
    
    init() {
        self.state = randomString()
    }
}
