//
//  TitleViewCell.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 29/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

class TitleViewCell: UITableViewCell {
   
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .largeTitle2Bold1Light1LabelColor1LeftAligned
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
