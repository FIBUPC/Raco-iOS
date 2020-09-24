//
//  AssignaturaTableViewCell.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 28/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit

class AssignaturaTableViewCell: UITableViewCell {

    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var inicialsLabel: UILabel!
    @IBOutlet weak var grupLabel: UILabel!
    @IBOutlet weak var creaditsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
