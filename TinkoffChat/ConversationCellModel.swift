//
//  ConversationCellModel.swift
//  TinkoffChat
//
//  Created by s.zorin on 01.03.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation

struct ConversationCellModel {
    let name: String
    let message: String?
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
