//
//  FakeConversationsDataSource.swift
//  TinkoffChat
//
//  Created by s.zorin on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

final class FakeMessagesDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var messages: [MessageCellModel] = []
    private let trashGenerator = TrashGeneator()
    
    // MARK: - Initializers
    
    convenience init(numberOfMessages: Int) {
        self.init()
        generateMessages(numberOfMessages: numberOfMessages)
    }
    
    // MARK: - Implementation of UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageTableViewCell.self), for: indexPath) as! MessageTableViewCell
        let model = messages[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    // MARK: - Public Methods
    
    func generateMessages(numberOfMessages: Int) {
        for _ in 0..<numberOfMessages {
            messages.append(generateMessage())
        }
    }
    
    func generateMessage() -> MessageCellModel {
        MessageCellModel(text: trashGenerator.generateMessage(numberOfSentences: Int.random(in: 1...5)))
    }
}

final class FakeConversationsDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var onlineConversations: [ConversationCellModel] = []
    var historyConversations: [ConversationCellModel] = []
    private let trashGenerator = TrashGeneator()
    
    // MARK: - Initializers
    
    convenience init(numberOfOnlineConversations: Int, numberOfHistoryConversations: Int) {
        self.init()
        generateConversations(numberOfOnlineConversations: numberOfOnlineConversations, numberOfHistoryConversations: numberOfHistoryConversations)
    }
    
    // MARK: - Subscripts
    
    subscript(indexPath: IndexPath) -> ConversationCellModel? {
        get {
            switch indexPath.section {
            case 0:
                return onlineConversations[indexPath.row]
            case 1:
                return historyConversations[indexPath.row]
            default:
                return nil
            }
        }
    }
    
    // MARK: - Implementation of UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return onlineConversations.count
        case 1:
            return historyConversations.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationTableViewCell.self), for: indexPath) as! ConversationTableViewCell
        let model: ConversationCellModel? = {
            switch indexPath.section {
            case 0:
                return onlineConversations[indexPath.row]
            case 1:
                return historyConversations[indexPath.row]
            default:
                return nil
            }
        }()
        if let model = model {
            cell.configure(with: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return nil
        }
    }
    
    // MARK: - Public Methods
    
    func generateConversations(numberOfOnlineConversations: Int, numberOfHistoryConversations: Int) {
        onlineConversations.removeAll()
        historyConversations.removeAll()
        for _ in 0..<numberOfOnlineConversations {
            onlineConversations.append(generateConversation(isOnline: true))
        }
        for _ in 0..<numberOfHistoryConversations {
            historyConversations.append(generateConversation(isOnline: false))
        }
    }
    
    // MARK: - Private Methods
    
    private func generateConversation(isOnline: Bool) -> ConversationCellModel {
        let name = trashGenerator.generateString(length: Int.random(in: 2...10))
        let message = Int.random(in: 0...5) == 0 ? nil : trashGenerator.generateMessage(numberOfSentences: Int.random(in: 1...5))
        let date = trashGenerator.generateDate(addSeconds: Int.random(in: -60*60*48...0))
        let hasUnreadMessages = message == nil ? false : Int.random(in: 0...1) == 0
        return ConversationCellModel(name: name, message: message, date: date, isOnline: isOnline, hasUnreadMessages: hasUnreadMessages)
    }
}
