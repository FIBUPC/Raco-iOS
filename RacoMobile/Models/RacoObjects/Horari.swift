//
//  Horari.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 28/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit
import SpreadsheetView

struct HorariData {
    var aules: String       // "aules" : "A6001"
    var dia_setmana: Int    // "dia_setmana" : 1
    var horaInici: String   // "inici" : "08:00"
    var inici: Int
    var codi_assig: String  // "codi_assig" : "AC"
    var tipus: String       // "tipus" : "T"
    var durada: Int         // "durada" : 2
    var grup: String        // "grup" : "10"
    
    init() {
        self.aules =  ""
        self.dia_setmana = 0
        self.horaInici =  ""
        self.inici = 0
        self.codi_assig =  ""
        self.tipus =  ""
        self.durada = 0
        self.grup =  ""
    }
    
    init(aules: String, dia_setmana: Int, horaInici: String, codi_assig: String, tipus: String, durada: Int, grup: String) {
        self.aules =  aules
        self.dia_setmana = dia_setmana
        self.horaInici = horaInici
        self.codi_assig = codi_assig
        self.tipus =  tipus
        self.durada = durada
        self.grup = grup
        //-14+6
        switch horaInici {
        case "08:00":
            self.inici = 0
            break
        case "09:00":
            self.inici = 1
            break
        case "10:00":
            self.inici = 2
            break
        case "11:00":
            self.inici = 3
            break
        case "12:00":
            self.inici = 4
            break
        case "13:00":
            self.inici = 5
            break
        case "14:00":
            self.inici = 6
            break
        case "15:00":
            self.inici = 7
            break
        case "16:00":
            self.inici = 8
            break
        case "17:00":
            self.inici = 9
            break
        case "18:00":
            self.inici = 10
            break
        case "19:00":
            self.inici = 11
            break
        case "20:00":
            self.inici = 12
            break
        default:
            self.inici = 0
            break
        }
    }
    
}

extension HorariData: Equatable {
    static func == (lhs: HorariData, rhs: HorariData) -> Bool {
        return lhs.aules == rhs.aules &&
            lhs.dia_setmana == rhs.dia_setmana &&
            lhs.horaInici == rhs.horaInici &&
            lhs.codi_assig == rhs.codi_assig &&
            lhs.tipus == rhs.tipus &&
            lhs.durada == rhs.durada &&
            lhs.grup == rhs.grup
    }
}

class DateCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class DayTitleCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TimeTitleCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class TimeCell: Cell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.textAlignment = .right
        
        contentView.addSubview(label)
    }
    
    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 6, dy: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ScheduleCell: Cell {
    let label = UILabel()
    let aules = UILabel()
    let grup = UILabel()
    
    var color: UIColor = .clear {
        didSet {
            backgroundView?.backgroundColor = color
        }
    }
    
    override var frame: CGRect {
        didSet {
            label.frame = CGRect(x: 4, y: 2, width: 25, height: 15)
            label.sizeToFit()
            grup.frame = CGRect(x: 4, y: label.frame.maxY + 2, width: 25, height: 15)
            grup.sizeToFit()
            aules.frame = CGRect(x: 4, y: grup.frame.maxY + 2, width: 25, height: 15)
            aules.sizeToFit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = UIView()
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        
        grup.frame = bounds
        grup.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        grup.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        grup.textAlignment = .left
        
        aules.frame = bounds
        aules.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        aules.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        aules.textAlignment = .left
        
        contentView.addSubview(label)
        contentView.addSubview(grup)
        contentView.addSubview(aules)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
