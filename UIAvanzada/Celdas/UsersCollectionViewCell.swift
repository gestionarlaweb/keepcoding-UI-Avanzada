//
//  UsersCollectionViewCell.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 26/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var usersImageView: UIImageView!
    @IBOutlet weak var usersNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usersNameLabel.font = .avatar
        
        // Redondear la imagen
        usersImageView.layer.cornerRadius = 40
    }

}
