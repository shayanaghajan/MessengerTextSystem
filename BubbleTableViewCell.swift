//
//  BubbleTableViewCell.swift
//  SampleTextBox
//
//  Created by Shayan Aghajan on 2/16/20.
//  Copyright © 2020 Shayan Aghajan. All rights reserved.
//

import UIKit

class BubbleTableViewCell: UITableViewCell {

    @IBOutlet weak var cellText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
