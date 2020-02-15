//
//  LifecycleEventLogger.swift
//  TinkoffChat
//
//  Created by s.zorin on 15.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import Foundation

class LifecycleEventLogger {
    private var currentStateName: String?
    
    func logEvent(_ stateName: String) {
        if currentStateName == nil {
            print("Application moved to \(stateName)")
        } else {
            print("Application moved from \(currentStateName!) to \(stateName)")
        }
        currentStateName = stateName
    }
}
