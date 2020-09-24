//
//  AssignaturaDetailedViewController.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 03/03/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit

class AssignaturaDetailedViewController: UIViewController {
	var selectedAssig: Assignatura?
	
	@IBOutlet weak var siglesLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		siglesLabel.text = selectedAssig?.sigles
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
