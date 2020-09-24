//
//  Avis.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 27/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Foundation
import SwiftyJSON

class Avis {
    let id: Int                     // "id": 104922,
    let titol: String               // "titol": "TEO: Classe 3."
    let codi_assig: String          // "codi_assig": "IDI"
    let text: String                // "text": ""
    let data_insercio: String       // "data_insercio": "2020-02-27T00:00:00"
    let data_modificacio: String    // "data_modificacio": "2020-02-26T16:51:07"
    let data_caducitat: String      // "data_caducitat": "2020-07-17T00:00:00"
    let adjunts: [JSON]             /* "adjunts": [...]*/
    
    init() {
        self.id = 0
        self.titol = ""
        self.codi_assig = ""
        self.text = ""
        self.data_insercio = ""
        self.data_modificacio = ""
        self.data_caducitat = ""
        self.adjunts = []
    }
    
    init(id: Int, titol: String, codi_assig: String, text: String, data_insercio: String, data_modificacio: String, data_caducitat: String, adjunts: [JSON]) {
        self.id = id
        self.titol = titol
        self.codi_assig = codi_assig
        self.text = text
        self.data_insercio = data_insercio
        self.data_modificacio = data_modificacio
        self.data_caducitat = data_caducitat
        self.adjunts = adjunts
    }
}
