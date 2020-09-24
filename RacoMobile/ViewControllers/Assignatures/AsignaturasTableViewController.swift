//
//  AsignaturasTableViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 06/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import Alamofire_SwiftyJSON

class AsignaturasViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var assigs: [Assignatura] = []
	var selectedAssig = Assignatura()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 300
        }
        
        obtenirAssignatures()
        self.tableView.rowHeight = 130
    }
    
    func obtenirAssignatures() {
        let url = "https://api.fib.upc.edu/v2/jo/assignatures/"
        let reqParameters: Parameters = ["format": "json", "lang": NSLocalizedString("SELECTED_LANGUAGE", comment: "ca")]
        let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
        
        Alamofire.request(url, method: .get, parameters: reqParameters, encoding: URLEncoding.default, headers: reqHeaders).responseSwiftyJSON { (response) in
            if let value = response.result.value {
                let result = value["results"]
                for data in result.arrayValue {
                    let assig = Assignatura(id: data["id"].stringValue,
                                            url: data["url"].stringValue,
                                            guia: data["guia"].stringValue,
                                            grup: data["grup"].intValue,
                                            sigles: data["sigles"].stringValue,
                                            codi_upc: data["codi_upc"].intValue,
                                            semestre: data["semestre"].stringValue,
                                            credits: data["credits"].doubleValue,
                                            nom: data["nom"].stringValue)
                    
                    self.assigs.append(assig)
                    
                    DispatchQueue.main.async {
						self.assigs.sort()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assigs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assigCell", for: indexPath) as! AssignaturaTableViewCell
        
        cell.nomLabel.text = assigs[indexPath.row].nom
        cell.inicialsLabel.text = assigs[indexPath.row].sigles
        cell.grupLabel.text = NSLocalizedString("GRUP_TEXT", comment: "Grup") + ": \(assigs[indexPath.row].grup)"
        cell.creaditsLabel.text = "Credits: \(assigs[indexPath.row].credits)"
        
        return cell
    }
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedAssig = assigs[indexPath.row]
		
		self.performSegue(withIdentifier: "detailedAssig", sender: nil)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if (segue.identifier == "detallAvis") {
			let detailed = segue.destination as! AssignaturaDetailedViewController
			detailed.selectedAssig = self.selectedAssig
		}
		
	}
    
    
}

