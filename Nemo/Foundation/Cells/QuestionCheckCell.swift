//
//  QuestionCheckCell.swift
//  Nemo
//
//  Created by 박영호 on 2020/08/11.
//  Copyright © 2020 Park young ho. All rights reserved.
//

import UIKit

class QuestionCheckCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var OX: UIImageView!
    @IBOutlet weak var Qnum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
