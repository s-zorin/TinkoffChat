//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by s.zorin on 20.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var selectImageButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction private func navigateBack(_ sender: UIButton) {
        navigationController?.navigateBack()
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 48
        selectImageButton.layer.cornerRadius = 48
    }
}
