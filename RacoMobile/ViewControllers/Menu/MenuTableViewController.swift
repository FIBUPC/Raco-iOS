//
//  MenuTableViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 07/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        nameLabel.text = (user.getNom() + " " + user.getCognoms())
        usernameLabel.text = user.getUsername()
        
        let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
        
        Alamofire.request("https://api.fib.upc.edu/v2/jo/foto.jpg", method: .get, parameters: nil, encoding: URLEncoding.default, headers: reqHeaders).responseData { (response) in
            if (response.result.isSuccess) {
                self.profileImageView.image = UIImage(data: response.data!)
            }
        }
    }
    
    
}

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}
