//
//  AvisosTableViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 06/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire
import SwiftyJSON
import UserNotifications

class AvisosTableViewController: UITableViewController, UNUserNotificationCenterDelegate {
	
	// MARK: - IBOutlets
	@IBOutlet weak var menuButton: UIBarButtonItem!
	@IBOutlet weak var filterSegControl: UISegmentedControl!
	
	// MARK: - Variables
	var avisos: [Avis] = []
	var selectedAvis: Avis = Avis()
	var showingArray: [Avis] = []
	var assigs: [String] = ["Tot"]
	var request: Alamofire.Request?
	var selectedSegment: Int = 0
	
	// MARK: - iOS Elements
	let refreshController = UIRefreshControl()
	let userNotificationCenter = UNUserNotificationCenter.current() // Notification center property
	
	// MARK: - View
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.userNotificationCenter.delegate = self
		self.requestNotificationAuthorization()
		//self.sendNotification(avis: Avis(id: 0, titol: "Proba", codi_assig: "", text: "Hola que tal", data_insercio: "", data_modificacio: "", data_caducitat: "", adjunts: [JSON]()))
		
		if self.revealViewController() != nil {
			menuButton.target = self.revealViewController()
			menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
			self.revealViewController().rearViewRevealWidth = 300
		}
		
		obtenirAssignatures()
		obtenirAvisos()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		tableView.addSubview(refreshController)
		refreshController.attributedTitle = NSAttributedString(string: "Obtenint nous avisos...", attributes: nil)
		refreshController.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
		self.filterSegControl.selectedSegmentIndex = selectedSegment
	}
	
	// MARK: - Notifications management
	func requestNotificationAuthorization() {
		// Auth options
		let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
		
		self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
			if let error = error {
				print("Error: ", error)
			}
		}
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		completionHandler()
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .badge, .sound])
	}
	
	func sendNotification(avis: Avis) {
		let notificationContent = UNMutableNotificationContent()
		notificationContent.title = avis.titol
		notificationContent.body = avis.text
		notificationContent.badge = NSNumber(value: 1)
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
														repeats: false)
		let request = UNNotificationRequest(identifier: "avisNotification",
											content: notificationContent,
											trigger: trigger)
		
		userNotificationCenter.add(request) { (error) in
			if let error = error {
				print("Notification Error: ", error)
			}
		}
	}
	
	func sendNotification() {
		let notificationContent = UNMutableNotificationContent()
		notificationContent.title = NSLocalizedString("NEW_AVISO_TITLE", comment: "Title")
		notificationContent.body = NSLocalizedString("NEW_AVISO_TEXT", comment: "Text")
		notificationContent.badge = NSNumber(value: 1)
		
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
														repeats: false)
		let request = UNNotificationRequest(identifier: "avisNotification",
											content: notificationContent,
											trigger: trigger)
		
		userNotificationCenter.add(request) { (error) in
			if let error = error {
				print("Notification Error: ", error)
			}
		}
	}
	
	// MARK: - Avisos management
	func obtenirAvisos() {
		let url = "https://api.fib.upc.edu/v2/jo/avisos/"
		let reqParameters: Parameters = ["format": "json", "lang": NSLocalizedString("SELECTED_LANGUAGE", comment: "ca")]
		let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
		
		request = Alamofire.request(url, method: .get, parameters: reqParameters, encoding: URLEncoding.default, headers: reqHeaders).responseSwiftyJSON { (response) in
			if let value = response.result.value {
				let result = value["results"]
				for data in result.arrayValue {
					let avis = Avis(id: data["id"].intValue, titol: data["titol"].stringValue, codi_assig: data["codi_assig"].stringValue, text: data["text"].stringValue, data_insercio: data["data_insercio"].stringValue, data_modificacio: data["data_modificacio"].stringValue, data_caducitat: data["data_caducitat"].stringValue, adjunts: data["adjunts"].arrayValue)
					self.avisos.append(avis)
					
					if (self.assigs.count > 1) {
						let selectedAssig = self.assigs[self.filterSegControl.selectedSegmentIndex]
						if (self.filterSegControl.selectedSegmentIndex != 0) {
							self.showingArray.removeAll()
							for avis in self.avisos {
								if avis.codi_assig == selectedAssig {
									self.showingArray.append(avis)
								}
							}
						}
					}
					
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			}
		}
		
		self.refreshController.endRefreshing()
	}
	
	func obtenirAvisosHandler(withCompletionHandler completionHandler: @escaping (_ ultimAvis: Avis, _ oldCount: Int) -> Void) {
		let oldCount = self.avisos.count
		
		let url = "https://api.fib.upc.edu/v2/jo/avisos/"
		let reqParameters: Parameters = ["format": "json", "lang": NSLocalizedString("SELECTED_LANGUAGE", comment: "ca")]
		let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
		
		request = Alamofire.request(url, method: .get, parameters: reqParameters, encoding: URLEncoding.default, headers: reqHeaders).responseSwiftyJSON { (response) in
			if let value = response.result.value {
				let result = value["results"]
				for data in result.arrayValue {
					let avis = Avis(id: data["id"].intValue, titol: data["titol"].stringValue, codi_assig: data["codi_assig"].stringValue, text: data["text"].stringValue, data_insercio: data["data_insercio"].stringValue, data_modificacio: data["data_modificacio"].stringValue, data_caducitat: data["data_caducitat"].stringValue, adjunts: data["adjunts"].arrayValue)
					self.avisos.append(avis)
					
					if (self.assigs.count > 1) {
						let selectedAssig = self.assigs[self.filterSegControl.selectedSegmentIndex]
						if (self.filterSegControl.selectedSegmentIndex != 0) {
							self.showingArray.removeAll()
							for avis in self.avisos {
								if avis.codi_assig == selectedAssig {
									self.showingArray.append(avis)
								}
							}
						}
					}
					
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			}
		}
		
		completionHandler(self.avisos.last!, oldCount)
	}
	
	// MARK: - Assignatures management
	func obtenirAssignatures() {
		let url = "https://api.fib.upc.edu/v2/jo/assignatures/"
		let reqParameters: Parameters = ["format": "json", "lang": NSLocalizedString("SELECTED_LANGUAGE", comment: "ca")]
		let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
		
		Alamofire.request(url, method: .get, parameters: reqParameters, encoding: URLEncoding.default, headers: reqHeaders).responseSwiftyJSON { (response) in
			if let value = response.result.value {
				//let count = value["count"]
				let result = value["results"]
				self.filterSegControl.removeAllSegments()
				
				var i = 0
				self.filterSegControl.insertSegment(withTitle: "Tot", at: i, animated: true)
				self.filterSegControl.selectedSegmentIndex = 0
				i += 1
				for data in result.arrayValue {
					
					self.assigs.append(data["sigles"].stringValue)
					self.filterSegControl.insertSegment(withTitle: self.assigs[i], at: i, animated: true)
					i += 1
				}
				
			}
		}
	}
	
	@objc private func refreshData(_ sender: Any) {
		self.refreshController.beginRefreshing()
		obtenirAssignatures()
		obtenirAvisos()
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let index = selectedSegment
		switch index {
		case 0:
			return avisos.count
		default:
			return showingArray.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "avisCell", for: indexPath) as! AvisosTableViewCell
		
		switch filterSegControl.selectedSegmentIndex {
		case 0:
			cell.title.text = avisos[indexPath.row].titol.htmlToString
			cell.assig.text = avisos[indexPath.row].codi_assig
			
			let text = avisos[indexPath.row].text.htmlToString
			cell.resum.text = text
		default:
			cell.title.text = showingArray[indexPath.row].titol.htmlToString
			cell.assig.text = showingArray[indexPath.row].codi_assig
			
			let text = showingArray[indexPath.row].text.htmlToString
			cell.resum.text = text
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch filterSegControl.selectedSegmentIndex {
		case 0:
			selectedAvis = avisos[indexPath.row]
		default:
			selectedAvis = showingArray[indexPath.row]
		}
		
		self.performSegue(withIdentifier: "detallAvis", sender: nil)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destination.
		// Pass the selected object to the new view controller.
		if (segue.identifier == "detallAvis") {
			let detailed = segue.destination as! AvisosDetallViewController
			detailed.titol = selectedAvis.titol
			detailed.text = selectedAvis.text
			detailed.assig = selectedAvis.codi_assig
			detailed.adjunts = selectedAvis.adjunts
			selectedSegment = filterSegControl.selectedSegmentIndex
		}
		
	}
	
	// MARK: - Segmented Control
	@IBAction func indexChanged(_ sender: Any) {
		let selectedAssig = assigs[filterSegControl.selectedSegmentIndex]
		if (filterSegControl.selectedSegmentIndex != 0) {
			self.showingArray.removeAll()
			for avis in avisos {
				if avis.codi_assig == selectedAssig {
					self.showingArray.append(avis)
				}
			}
		}
		self.tableView.reloadData()
	}
	
}
