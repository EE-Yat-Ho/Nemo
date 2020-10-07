//
//  QuestionCell.swift
//  BrainSupporter2
//
//  Created by 박영호 on 2020/07/07.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var questionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
