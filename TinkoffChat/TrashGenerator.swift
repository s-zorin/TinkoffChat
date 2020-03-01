//
//  TrashGenerator.swift
//  TinkoffChat
//
//  Created by s.zorin on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation

final class TrashGeneator {
    func generateString(length: Int, firstLetterCapitalized: Bool = true) -> String {
        let randomChars = stride(from: 0, to: length, by: 1).map { i -> Character in
            let randomChar = "abcdefghijklmnopqrstuvwxyz".randomElement()!
            return firstLetterCapitalized && i == 0 ? Character(randomChar.uppercased()) : randomChar
        }
        return String(randomChars)
    }
    
    func generateSentence(numberOfWords: Int) -> String {
        let words = stride(from: 0, to: numberOfWords, by: 1).map { i in
            generateString(length: Int.random(in: 1...12), firstLetterCapitalized: i == 0)
        }.joined(separator: " ")
        return "\(words)."
    }
    
    func generateMessage(numberOfSentences: Int) -> String {
        stride(from: 0, to: numberOfSentences, by: 1).map { _ in
            generateSentence(numberOfWords: Int.random(in: 2...6))
        }.joined(separator: " ")
    }
    
    func generateDate(addSeconds seconds: Int) -> Date {
        Calendar.current.date(byAdding: .second, value: seconds, to: Date()) ?? Date()
    }
}
