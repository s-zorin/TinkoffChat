//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by s.zorin on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = MessageCellModel
    
    // MARK: - Properties
    
    private var configurationModel: ConfigurationModel?
    
    // MARK: - Outlets
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var bubbleView: UIView!
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //applyConfiguration()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //applyConfiguration()
    }
    
    // MARK: - Implementation of ConfigurableViewProtocol
    
    func configure(with model: MessageCellModel) {
        configurationModel = model
        applyConfiguration()
    }
    
    // MARK: - Private Methods
    
    func applyConfiguration() {
        messageLabel?.text = configurationModel?.text
        let isIncoming = Int.random(in: 0...1) == 0
        if isIncoming {
            trailingConstraint.priority = UILayoutPriority(999)
            leadingConstraint.priority = UILayoutPriority(1000)
            messageLabel.backgroundColor = UIColor.systemBlue
        } else {
            leadingConstraint.priority = UILayoutPriority(999)
            trailingConstraint.priority = UILayoutPriority(1000)
            messageLabel.backgroundColor = UIColor.systemGreen
        }
    }
}
