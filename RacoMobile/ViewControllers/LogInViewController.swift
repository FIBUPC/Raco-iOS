//
//  LogInViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 26/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SafariServices
import Alamofire
import AuthenticationServices
import SWRevealViewController

typealias AuthHandlerCompletion = (URL?, Error?) -> Void

class LogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logInButton(_ sender: Any) {
        getAuthTokenWithWebLogin()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "logInSegue") {
            let detailed = AvisosTableViewController()
            detailed.obtenirAvisos()
        }
    }
    
    // MARK: - OAuth flow
    
    var webAuthSession: ASWebAuthenticationSession?
    
    func getAuthTokenWithWebLogin() {        
        let authURL = URL(string: "https://api.fib.upc.edu/v2/o/authorize/?client_id=PWsF7FtU2eeLBYRMaRJUrKpDzbZFLkMCDFvvcvc3&redirect_uri=apifib://raco&response_type=code&state=\(manager.state)")
        let callbackUrlScheme = "apifib://raco"
        
        self.webAuthSession = ASWebAuthenticationSession(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            
            let parameters = successURL.queryParameters
            let oauthToken = parameters!["code"]
            
            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
            if (oauthToken != nil) {
                self.createToken(code: oauthToken!)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
        self.webAuthSession?.presentationContextProvider = self
        
        // Kick it off
        self.webAuthSession?.start()
    }
    
    func createToken(code: String) {
        let reqParameters: Parameters = ["grant_type" : "authorization_code",
                                         "redirect_uri" : manager.redirectUri,
                                         "code" : code,
                                         "client_id" : manager.clientID,
                                         "client_secret" : manager.clientSecret]
        
        Alamofire.request(tokenURL, method: .post, parameters: reqParameters, encoding: URLEncoding.default).responseJSON { (response) in
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
                    print("Requested successful")
                    
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                }
            } else {
                print("Token Request not success")
            }
        }
    }
    
}

extension LogInViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
