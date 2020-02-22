//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by s.zorin on 20.02.2020.
//  Copyright © 2020 Tinkoff Bank. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var pickImageButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction private func navigateBack(_ sender: UIButton) {
        navigationController?.navigateBack()
    }
    
    @IBAction private func pickImage(_ sender: UIButton) {
        print("Pick profile image.")
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Установить из галереи",
                                               style: .default,
                                               handler: {[weak self] (_) in self?.pickImage(sourceType: .photoLibrary)})
        let cameraAction = UIAlertAction(title: "Сделать фото",
                                         style: .default,
                                         handler: {[weak self] (_) in self?.pickImage(sourceType: .camera)})
        controller.addAction(photoLibraryAction)
        controller.addAction(cameraAction)
        present(controller, animated: true)
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 48
        pickImageButton.layer.cornerRadius = 48
    }
    
    // MARK: - Implementation of UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        profileImage.image = info[.originalImage] as? UIImage
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
}
