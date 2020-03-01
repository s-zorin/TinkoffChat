//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by s.zorin on 28.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate {

    
    
    // MARK: - Properties
    
    let dataSource = FakeConversationsDataSource(onlineConversationsCount: 5, historyConversationsCount: 10)
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Overrides
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Tinkoff Chat"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationTableViewCell.self))
        tableView.dataSource = dataSource
    }
}
