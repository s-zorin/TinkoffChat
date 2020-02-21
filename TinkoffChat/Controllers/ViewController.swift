//
//  ViewController.swift
//  TinkoffChat
//
//  Created by s.zorin on 15.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Actions
    
    @IBAction func navigateToProfile(_ sender: UIButton) {
        navigationController?.navigate(to: .ProfileViewController)
    }
    
    // MARK: - Lifecycle Events
    
    lazy var logger = LifecycleEventLogger(entityName: "View")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logger.logEvent(#function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logger.logEvent(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.logEvent(#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logger.logEvent(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logger.logEvent(#function)
    }
}

