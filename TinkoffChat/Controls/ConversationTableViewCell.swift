//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by s.zorin on 29.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = "My custom cell"
    }
}
