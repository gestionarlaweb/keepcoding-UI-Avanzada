//
//  WelViewCell.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 29/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

class WelViewCell: UITableViewCell {

    @IBOutlet weak var contenidoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.layer.cornerRadius = 6
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
