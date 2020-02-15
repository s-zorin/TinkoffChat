//
//  LifecycleEventLogger.swift
//  TinkoffChat
//
//  Created by s.zorin on 15.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation

class LifecycleEventLogger {
    private var entityName: String
    private var currentStateName: String?
    
    init(entityName: String) {
        self.entityName = entityName
    }
    
    func logEvent(_ stateName: String) {
        if currentStateName == nil {
            print("\(entityName) moved to \(stateName)")
        } else {
            print("\(entityName) moved from \(currentStateName!) to \(stateName)")
        }
        currentStateName = stateName
    }
}
