//
//  WelcomViewCell.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 29/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

class WelcomViewCell: UITableViewCell {

    @IBOutlet weak var viewWelcom: UIView!
    @IBOutlet weak var textTopicLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewWelcom.layer.cornerRadius = 6
        textTopicLabel.font = .style27
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
