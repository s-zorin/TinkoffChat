//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by s.zorin on 29.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

final class ConversationTableViewCell: UITableViewCell, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = ConversationCellModel
    
    // MARK: - Properties
    
    private let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    private let shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter
    }()
    private var configurationModel: ConfigurationModel?
    var startConversation: ((_ model: ConfigurationModel?) -> Void)?
    
    // MARK: - Outlets
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func startConversation(_ sender: UIButton) {
        startConversation?(configurationModel)
    }
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyConfiguration()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        applyConfiguration()
    }
    
    // MARK: - Implementation of ConfigrableViewProtocol
    
    func configure(with model: ConversationCellModel) {
        configurationModel = model
        applyConfiguration()
    }
    
    private func applyConfiguration() {
        backgroundColor = configurationModel?.isOnline ?? false ? UIColor.systemYellow : nil
        nameLabel?.text = configurationModel?.name
        messageLabel?.text = configurationModel?.message ?? "No messages yet."
        messageLabel?.textColor = configurationModel?.message == nil ? UIColor.systemGray : nil
        messageLabel?.font = configurationModel?.hasUnreadMessages ?? false ? UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize) : UIFont.systemFont(ofSize: messageLabel.font.pointSize)
        if let date = configurationModel?.date {
            let components = Calendar.current.dateComponents([.day], from: date, to: Date())
            let formatter = components.day ?? 0 > 0 ? shortDateFormatter : timeFormatter
            dateLabel?.text = formatter.string(from: date)
        }
    }
}
