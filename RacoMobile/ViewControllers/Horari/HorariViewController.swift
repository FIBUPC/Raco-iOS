//
//  HorariViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 07/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SWRevealViewController
import SpreadsheetView
import Alamofire
import Alamofire_SwiftyJSON

class HorariViewController: UIViewController, SpreadsheetViewDataSource, SpreadsheetViewDelegate {
	
	@IBOutlet weak var menuButton: UIBarButtonItem!
	@IBOutlet weak var spreadsheetView: SpreadsheetView!
	
	let days = [NSLocalizedString("LUNES_TEXT", comment: "LUNES"),
				NSLocalizedString("MARTES_TEXT", comment: "MARTES"),
				NSLocalizedString("MIERCOLES_TEXT", comment: "MIERCOLES"),
				NSLocalizedString("JUEVES_TEXT", comment: "JUEVES"),
				NSLocalizedString("VIERNES_TEXT", comment: "VIERNES")]
	
	let dayColors = [UIColor(named: "Lunes")!,
					 UIColor(named: "Martes")!,
					 UIColor(named: "Miercoles")!,
					 UIColor(named: "Jueves")!,
					 UIColor(named: "Viernes")!]
	
	let hours = ["8:00", "9:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00"]
	let evenRowColor = UIColor(named: "Even row")
	let oddRowColor = UIColor(named: "Odd row")
	
	var data: [[HorariData]] = Array(repeating: Array(repeating: HorariData(), count: 13), count: 13)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if self.revealViewController() != nil {
			menuButton.target = self.revealViewController()
			menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
			self.revealViewController().rearViewRevealWidth = 300
		}
		
		spreadsheetView.dataSource = self
		spreadsheetView.delegate = self
		
		spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
		
		spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
		spreadsheetView.gridStyle = .none
		
		spreadsheetView.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
		spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
		spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
		spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
		spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		spreadsheetView.flashScrollIndicators()
		obtenirHorari()
	}
	
	func obtenirHorari() {
		let horariURL = "https://api.fib.upc.edu/v2/jo/classes/"
		let reqParameters: Parameters = ["format": "json", "lang": NSLocalizedString("SELECTED_LANGUAGE", comment: "ca")]
		let reqHeaders: HTTPHeaders = ["Authorization": ("Bearer " + userToken.accessToken)]
		
		Alamofire.request(horariURL, method: .get, parameters: reqParameters, encoding: URLEncoding.default, headers: reqHeaders).responseSwiftyJSON { (response) in
			if let value = response.result.value {
				let result = value["results"]
				for data in result.arrayValue {
					let assig = HorariData(aules: data["aules"].stringValue,
										   dia_setmana: data["dia_setmana"].intValue,
										   horaInici: data["inici"].stringValue,
										   codi_assig: data["codi_assig"].stringValue,
										   tipus: data["tipus"].stringValue,
										   durada: data["durada"].intValue,
										   grup: data["grup"].stringValue)
					
					if (assig.durada > 1) {
						for i in 0...assig.durada-1 {
							self.data[assig.dia_setmana][assig.inici + i] = assig
						}
					} else {
						self.data[assig.dia_setmana][assig.inici] = assig
					}
					DispatchQueue.main.async {
						self.spreadsheetView.reloadData()
					}
				}
			}
		}
	}
	
	// MARK: - DataSource
	
	func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
		return 1 + days.count
	}
	
	func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
		return 1 + hours.count
	}
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
		if case 0 = column {
			return 70
		} else {
			return 120
		}
	}
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
		if case 0 = row {
			return 32
		} else {
			return 50
		}
	}
	
	func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
		return 1
	}
	
	func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
		return 1
	}
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
		if case (1...(days.count + 1), 0) = (indexPath.column, indexPath.row) {
			/* WEEK DAYS */
			let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
			cell.label.text = days[indexPath.column - 1]
			cell.label.textColor = dayColors[indexPath.column - 1]
			cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
			return cell
			
		} else if case (0, 0) = (indexPath.column, indexPath.row) {
			/* TIME TITLE */
			let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
			cell.label.text = NSLocalizedString("HORARI_TIME_TITLE", comment: "TIME")
			cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
			return cell
			
		} else if case (0, 1...(hours.count + 1)) = (indexPath.column, indexPath.row) {
			/* HOURS */
			let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
			cell.label.text = hours[indexPath.row - 1]
			cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
			return cell
			
		} else if case (1...(days.count + 1), 1...(hours.count + 1)) = (indexPath.column, indexPath.row) {
			/* OTHER */
			let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
			let text = data[indexPath.column][indexPath.row - 1].codi_assig
			let aules = data[indexPath.column][indexPath.row - 1].aules
			let grup = data[indexPath.column][indexPath.row - 1].grup
			let tipus = data[indexPath.column][indexPath.row - 1].tipus
			
			if !text.isEmpty {
				cell.label.text = text + " (\(tipus))"
				cell.aules.text = aules
				cell.grup.text = grup
				
				let color = dayColors[indexPath.column - 1]
				cell.label.textColor = color
				cell.grup.textColor = color
				cell.aules.textColor = color
				
				cell.color = color.withAlphaComponent(0.2)
				cell.backgroundColor = .clear
				
				cell.borders.top = .solid(width: 2, color: color)
				cell.borders.bottom = .solid(width: 2, color: color)
			} else {
				cell.label.text = nil
				cell.aules.text = nil
				cell.grup.text = nil
				
				cell.color = (indexPath.row % 2 == 0 ? evenRowColor : oddRowColor)!
				cell.borders.top = .none
				cell.borders.bottom = .none
			}
			return cell
		}
		return nil
	}
	
	// MARK: - SpreadsheetView Delegate
	
	func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
		print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
	}
}
