//
//  ConfiguracionTableViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 07/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftKeychainWrapper
import SafariServices
import MessageUI

class ConfiguracionTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var versionCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        versionCell.detailTextLabel!.text = "v. \(appVersion!) (\(build!))"
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "logOut") {
            logOut()
        }
    }
    
    func logOut() {
        let revokeParameters: Parameters = ["token": userToken.accessToken,
                                            "client_id" : manager.clientID]
        Alamofire.request(tokenRevokeURL, method: .post, parameters: revokeParameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            userToken.isValid = false
            print("Login Out...")
            KeychainWrapper.standard.removeObject(forKey: "accessToken")
            KeychainWrapper.standard.removeObject(forKey: "tokenType")
            KeychainWrapper.standard.removeObject(forKey: "expiresIn")
            KeychainWrapper.standard.removeObject(forKey: "refreshToken")
            KeychainWrapper.standard.removeObject(forKey: "scope")
            KeychainWrapper.standard.removeObject(forKey: "isValid")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            openURLString("http://suport.fib.upc.edu/")
            tableView.deselectRow(at: indexPath, animated: true)
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            let urlString = "http://twitter.com/alvaroarino"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        } else if (indexPath.section == 3 && indexPath.row == 0) {
            // Politica de privacitat
            openURLString("http://")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func openURLString(_ url: String) {
        if let url = URL(string: url) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self as? SFSafariViewControllerDelegate
            
            present(vc, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
