//
//  References.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 27/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire
import CoreData

let manager: RacoAPIManager = RacoAPIManager()

let baseURL = "https://api.fib.upc.edu/v2/"
let authURL = "https://api.fib.upc.edu/v2/o/authorize"
let tokenURL = "https://api.fib.upc.edu/v2/o/token"
let tokenRevokeURL = "https://api.fib.upc.edu/v2/o/revoke_token/"

let feedURL = "https://www.fib.upc.edu/ca/noticies/rss.rss"

var userToken: TokenResponse = TokenResponse(
    access_token: KeychainWrapper.standard.string(forKey: "accessToken") ?? "access_token",
    token_type: KeychainWrapper.standard.string(forKey: "tokenType") ?? "token_type",
    expires_in: KeychainWrapper.standard.integer(forKey: "expiresIn") ?? -1,
    refresh_token: KeychainWrapper.standard.string(forKey: "refreshToken") ?? "refresh_token",
    scope: KeychainWrapper.standard.string(forKey: "scope") ?? "scope")

var user: User = User()

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

let startEntity = NSEntityDescription.entity(forEntityName: "Start", in: context)
let newStartSetting = NSManagedObject(entity: startEntity!, insertInto: context)
let startRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Start")
