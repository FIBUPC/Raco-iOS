//
//  SalasBRGFViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 07/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import WebKit
import SafariServices

class SalasBRGFViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        //let url = "https://apps.bibliotecnica.upc.edu/reserva_sales/comunes/disponibilidad.php?Id_centro=1"
        let url = "https://apps.bibliotecnica.upc.edu/reserva_sales/"
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
}
