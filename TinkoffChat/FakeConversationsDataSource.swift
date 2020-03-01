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
        let name = generateString(length: Int.random(in: 2...10))
        let message = Int.random(in: 0...5) == 0 ? nil : generateMessage(numberOfSentences: Int.random(in: 1...5))
        let date = generateDate(addSeconds: Int.random(in: -60*60*48...0))
        let hasUnreadMessages = message == nil ? false : Int.random(in: 0...1) == 0
        return ConversationCellModel(name: name, message: message, date: date, isOnline: isOnline, hasUnreadMessages: hasUnreadMessages)
    }
    
    private func generateString(length: Int, firstLetterCapitalized: Bool = true) -> String {
        let randomChars = stride(from: 0, to: length, by: 1).map { i -> Character in
            let randomChar = chars.randomElement()!
            return firstLetterCapitalized && i == 0 ? Character(randomChar.uppercased()) : randomChar
        }
        return String(randomChars)
    }
    
    private func generateSentence(numberOfWords: Int) -> String {
        let words = stride(from: 0, to: numberOfWords, by: 1).map { i in
            generateString(length: Int.random(in: 1...12), firstLetterCapitalized: i == 0)
        }.joined(separator: " ")
        return "\(words)."
    }
    
    private func generateMessage(numberOfSentences: Int) -> String {
        stride(from: 0, to: numberOfSentences, by: 1).map { _ in
            generateSentence(numberOfWords: Int.random(in: 2...6))
        }.joined(separator: " ")
    }
    
    private func generateDate(addSeconds seconds: Int) -> Date {
        Calendar.current.date(byAdding: .second, value: seconds, to: Date()) ?? Date()
    }
}
