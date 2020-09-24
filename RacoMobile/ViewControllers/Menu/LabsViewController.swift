//
//  LabsViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 07/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire

class LabsViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var labSelector: UISegmentedControl!
    @IBOutlet weak var labImageView: UIImageView!
    
    let labsURL = "https://api.fib.upc.edu/v2/laboratoris/imatges/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        obtainImage(selectedLab: "A5.png")
    }
    
    func obtainImage(selectedLab lab: String) {
        print(labsURL + lab)
        
        let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
        Alamofire.request(labsURL + lab, method: .get, headers: reqHeaders).responseData { response in
            if case .success(let image) = response.result {
                print(lab)
                print("image downloaded: \(image)")
                self.labImageView.image = UIImage(data: image)
            }
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch labSelector.selectedSegmentIndex {
        case 0:
            obtainImage(selectedLab: "A5.png")
            break
        case 1:
            obtainImage(selectedLab: "C6.png")
        case 2:
            obtainImage(selectedLab: "B5.png")
        default:
            break
        }
    }
    
}

extension UIImageView {
    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        dowloadFromServer(url: url, contentMode: mode)
    }
}
