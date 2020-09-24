//
//  AvisosTableViewCell.swift
//  RacoMobile
//
//  Created by Alvaro Ariño Cabau on 27/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import UIKit

class AvisosTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var assig: UILabel!
    @IBOutlet weak var resum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
