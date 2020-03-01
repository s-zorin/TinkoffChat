//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by s.zorin on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

final class ConversationViewController: UIViewController, UITableViewDelegate, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = ConversationCellModel
    
    // MARK: - Properties
    
    private var configurationModel: ConversationCellModel?
    private let dataSource = FakeMessagesDataSource(numberOfMessages: 50)
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: MessageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MessageTableViewCell.self))
        tableView.dataSource = dataSource
        tableView.delegate = self
        applyConfiguration()
    }
    
    // MARK: - Implementation of ConfigurableViewProtocol
    
    func configure(with model: ConversationCellModel) {
        configurationModel = model
        applyConfiguration()
    }
    
    // MARK: - Private Methods
    
    private func applyConfiguration() {
        title = configurationModel?.name
    }
}
