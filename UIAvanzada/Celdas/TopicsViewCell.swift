//
//  TopicsViewCell.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 24/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

class TopicsViewCell: UITableViewCell {

    @IBOutlet weak var avatarUserTopic: UIImageView!
    @IBOutlet weak var textUserTopic: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var postersCountLabel: UILabel!
    @IBOutlet weak var lastPostedAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textUserTopic.font = .style27
        postsCountLabel.font = .textoPequeO
        postersCountLabel.font = .textoPequeO
        lastPostedAtLabel.font = .textoPequeO
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
