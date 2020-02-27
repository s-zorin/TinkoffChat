//
//  RoundedButton.swift
//  TinkoffChat
//
//  Created by s.zorin on 21.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        layer.cornerRadius = 12
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        setTitleColor(UIColor.black, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
}
