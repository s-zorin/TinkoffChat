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
    
    private var currentIndexPath: IndexPath?
    private lazy var dataSource: FakeConversationsDataSource! = {
        let dataSource = FakeConversationsDataSource(numberOfOnlineConversations: 10, numberOfHistoryConversations: 10)
        dataSource.startConversation = { [weak self] model in
            let conversationViewController = ConversationViewController()
            if let model = model {
                conversationViewController.configure(with: model)
            }
            self?.navigationController?.pushViewController(conversationViewController, animated: true)
        }
        return dataSource
    }()
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statusLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func openProfile(_ sender: UIButton) {
        let profileViewController = ProfileViewController()
        if let indexPath = currentIndexPath, let model = dataSource[indexPath] {
            profileViewController.configure(with: model)
        }
        present(profileViewController, animated: true, completion: nil)
    }
    
    // MARK: - Overrides
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Tinkoff Chat"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: ConversationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationTableViewCell.self))
        tableView.dataSource = dataSource
        tableView.delegate = self
        currentIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: currentIndexPath, animated: false, scrollPosition: .top)
        displayConversationStatus(at: currentIndexPath)
    }
    
    // MARK: - Implementation of UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndexPath = indexPath
        displayConversationStatus(at: currentIndexPath)
    }
    
    // MARK: - Private Methods
    
    func displayConversationStatus(at indexPath: IndexPath?) {
        if let indexPath = indexPath, let model = dataSource[indexPath] {
            let name = model.name
            let status = model.isOnline ? "Online" : "Offline"
            statusLabel.text = "\(name) is \(status)"
        }
    }
}
