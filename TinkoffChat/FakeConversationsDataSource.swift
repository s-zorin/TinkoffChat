//
//  FakeConversationsDataSource.swift
//  TinkoffChat
//
//  Created by s.zorin on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

 final class FakeConversationsDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var onlineConversations: [ConversationCellModel] = []
    var historyConversations: [ConversationCellModel] = []
    let dayDifference = [-5, -4, -3, -2, -1, 0]
    let dateFormatter = DateFormatter()
    let chars = "abcdefghijklmnopqrstuvwxyz"
    
    // MARK: - Initializers
    
    convenience init(onlineConversationsCount: Int, historyConversationsCount: Int) {
        self.init()
        generateConversations(onlineConversationsCount: onlineConversationsCount, historyConversationsCount: historyConversationsCount)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "Offline"
        default:
            return nil
        }
    }
    
    // MARK: - Public Methods
    
    func generateConversations(onlineConversationsCount: Int, historyConversationsCount: Int){
        onlineConversations.removeAll()
        historyConversations.removeAll()
        for _ in 0..<onlineConversationsCount {
            onlineConversations.append(generateConversation(isOnline: true))
        }
        for _ in 0..<historyConversationsCount {
            historyConversations.append(generateConversation(isOnline: false))
        }
    }
    
    // MARK: - Private Methods
    
    private func generateConversation(isOnline: Bool) -> ConversationCellModel {
        let name = generateString(length: 10)
        let message = generateString(length: 30)
        let date = Date()
        let hasUnreadMessages = true
        return ConversationCellModel(name: name, message: message, date: date, isOnline: isOnline, hasUnreadMessages: hasUnreadMessages)
    }
    
    private func generateString(length: Int) -> String {
        let randomChars = stride(from: 0, to: length, by: 1).map { i -> Character in
            let randomChar = chars.randomElement()!
            return i == 0 ? Character(randomChar.uppercased()) : randomChar
        }
        return String(randomChars)
    }
}
