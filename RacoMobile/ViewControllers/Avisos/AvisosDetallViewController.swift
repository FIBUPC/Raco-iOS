//
//  AvisosDetallViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 27/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class AvisosDetallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    let fitxersTable = UITableView()
    let textWebView = WKWebView()
    
    var titol: String = ""
    var text: String = ""
    var assig: String = ""
    var adjunts: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fitxersTable.delegate = self
        fitxersTable.dataSource = self
        
        let htmlText = "<head><meta name=" + "viewport" + " content=" + "width=device-width" + ", initial-scale=1.0" + "></head>" + "<style> body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; } @media (prefers-color-scheme: dark) {body { background-color: black; color: white;}} </style>" + text
		textWebView.loadHTMLString(htmlText, baseURL: nil)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if (adjunts.count == 0) {
			self.textWebView.frame = CGRect(x: 20, y: 160, width: (UIScreen.main.bounds.width - 40), height: (UIScreen.main.bounds.height - (fitxersTable.frame.height + 160)))
			self.view.addSubview(textWebView)
		} else {
			let tableHeight = CGFloat(Double(self.assig.count) * 43.5)
			self.fitxersTable.frame = CGRect(x: 0, y: 160, width: UIScreen.main.bounds.width, height: tableHeight)
			self.view.addSubview(fitxersTable)
			
			self.textWebView.frame = CGRect(x: 20, y: fitxersTable.frame.height + 160, width: (UIScreen.main.bounds.width - 40), height: (UIScreen.main.bounds.height - (fitxersTable.frame.height + 160)))
			self.view.addSubview(textWebView)
		}
		
		fitxersTable.register(UITableViewCell.self, forCellReuseIdentifier: "adjuntsCell")
		
		self.navigationItem.title = assig
		titleLabel.text = titol.htmlToString
		
		if (adjunts.count > 0) {
			self.fitxersTable.reloadData()
		}
	}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adjunts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adjuntsCell", for: indexPath)  as UITableViewCell?
        
        if (tableView == fitxersTable) {
            
            if (adjunts.count > 0) {
                let adjunt = adjunts[indexPath.row].dictionaryValue
                print(adjunt)
                cell?.textLabel?.text = adjunt["nom"]?.stringValue
                if (adjunt["tipus_mime"]!.stringValue == "application/pdf") {
                    cell?.imageView?.image = UIImage(systemName: "doc")
                } else {
                    cell?.imageView?.image = UIImage(systemName: "folder")
                }
                cell?.accessoryType = .disclosureIndicator
            } else {
                cell?.textLabel?.text = "No hi ha adjunts"
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = adjunts[indexPath.row].dictionaryValue["url"]?.stringValue
        if let url = URL(string: urlString!) {
            UIApplication.shared.open(url)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
