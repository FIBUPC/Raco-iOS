//
//  Assignatura.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 28/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Foundation

class Assignatura {
    /*
     "id": "IES",
     "url": "https://api.fib.upc.edu/v2/assignatures/IES/",
     "guia": "https://api.fib.upc.edu/v2/assignatures/IES/guia/",
     "grup": "22",
     "sigles": "IES",
     "codi_upc": 270015,
     "semestre": "S4",
     "credits": 6.0,
     "nom": "Introducción a la Ingeniería del Software"
     */
    
    var id: String
    var url: String
    var guia: String
    var grup: Int
    var sigles: String
    var codi_upc: Int
    var semestre: String
    var credits: Double
    var nom: String
    
    init() {
        self.id = ""
        self.url = ""
        self.guia = ""
        self.grup = 0
        self.sigles = ""
        self.codi_upc = 0
        self.semestre = ""
        self.credits = 0.0
        self.nom = ""
    }
    
    init(id: String, url: String, guia: String, grup: Int, sigles: String, codi_upc: Int, semestre: String, credits: Double, nom: String) {
        self.id = id
        self.url = url
        self.guia = guia
        self.grup = grup
        self.sigles = sigles
        self.codi_upc = codi_upc
        self.semestre = semestre
        self.credits = credits
        self.nom = nom
    }
}

extension Assignatura: Comparable {
	static func == (lhs: Assignatura, rhs: Assignatura) -> Bool {
		return lhs.sigles == rhs.sigles
	}
	
	static func < (lhs: Assignatura, rhs: Assignatura) -> Bool {
		return lhs.sigles < rhs.sigles
	}
	
	func sort(by: (Assignatura, Assignatura)) -> Bool {
		return by.0.sigles < by.1.sigles
	}
}
