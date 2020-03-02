//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by s.zorin on 20.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ConfigurableViewProtocol {
    
    typealias ConfigurationModel = ConversationCellModel
    
    // MARK: - Properties
    
    private var configurationModel: ConfigurationModel?

    // MARK: - Outlets
    
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var pickImageButton: UIButton!
    @IBOutlet private var nameLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction private func pickImage(_ sender: UIButton) {
        print("Pick profile image.")
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Установить из галереи", style: .default) { [weak self] _ in
            self?.pickImage(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] (_) in
            self?.pickImage(sourceType: .camera)
        }
        controller.addAction(photoLibraryAction)
        controller.addAction(cameraAction)
        present(controller, animated: true)
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 48
        pickImageButton.layer.cornerRadius = 48
        applyConfiguration()
    }
    
    // MARK: - Implementation of UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        profileImage.image = info[.originalImage] as? UIImage
    }
    
    // MARK: - Implementation of ConfigurableViewProtocol
    
    func configure(with model: ConversationCellModel) {
        configurationModel = model
        applyConfiguration()
    }
    
    // MARK: - Private Methods
    
    private func pickImage(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true)
        }
    }
    
    private func applyConfiguration() {
        nameLabel?.text = configurationModel?.name
    }
}
