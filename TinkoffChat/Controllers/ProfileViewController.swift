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
    
    private let gcdProfileWriter = GCDProfileWriter()
    private let operationProfileWriter = OperationProfileWriter()
    private var configurationModel: ConfigurationModel?
    
    // MARK: - Outlets
    
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var pickImageButton: UIButton!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var bioTextField: UITextField!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var saveGCDButton: UIButton!
    @IBOutlet private var saveOperationButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
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
    
    @IBAction func nameChanged(_ sender: UITextField) {
        let isEnabled = nameTextField.text != configurationModel?.name || bioTextField.text != configurationModel?.bio
        saveGCDButton.isEnabled = isEnabled
        saveOperationButton.isEnabled = isEnabled
    }
    
    @IBAction func bioChanged(_ sender: UITextField) {
        let isEnabled = nameTextField.text != configurationModel?.name || bioTextField.text != configurationModel?.bio
        saveGCDButton.isEnabled = isEnabled
        saveOperationButton.isEnabled = isEnabled
    }
    
    @IBAction func edit(_ sender: UIButton) {
        beginEditing()
    }
    
    @IBAction func saveGCD(_ sender: UIButton) {
        saveProfile(using: gcdProfileWriter)
    }
    
    @IBAction func saveOperation(_ sender: UIButton) {
        saveProfile(using: operationProfileWriter)
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 48
        pickImageButton.layer.cornerRadius = 48
        applyConfiguration()
        loadProfile(usingReader: ProfileReader())
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
        bioLabel?.text = configurationModel?.bio
    }
    
    private func saveProfile(using writer: ProfileWriter) {
        guard let configurationModel = configurationModel else {
            return
        }
        let semaphore = DispatchSemaphore(value: 0)
        let name = nameTextField.text != configurationModel.name ? nameTextField.text : nil
        let bio = bioTextField.text != configurationModel.bio ? bioTextField.text : nil
        let profileDTO = ProfileDTO(id: configurationModel.id, name: name, bio: bio, image: profileImage.image)
        var retry = false
        endEditing()
        DispatchQueue.global().async { [weak self] in
            repeat {
                DispatchQueue.main.async {
                    self?.activityIndicator.isHidden = false
                }
                writer.save(profile: profileDTO) { [weak self] success in
                    DispatchQueue.main.sync { [weak self] in
                        let message = success ? "Сохранено" : "Не удалось сохранить изменения"
                        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { action in
                            alertController.dismiss(animated: true, completion: nil)
                            retry = false
                            semaphore.signal()
                            self?.loadProfile(usingReader: ProfileReader())
                        }
                        let retryAction = UIAlertAction(title: "Повторить", style: .default) { action in
                            alertController.dismiss(animated: true, completion: nil)
                            retry = true
                            semaphore.signal()
                        }
                        if success {
                            alertController.addAction(okAction)
                        } else {
                            alertController.addAction(okAction)
                            alertController.addAction(retryAction)
                        }
                        self?.activityIndicator.isHidden = true
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
                semaphore.wait()
            } while retry
        }
    }
    
    private func loadProfile(usingReader reader: ProfileReader) {
        if let configurationModel = configurationModel {
            reader.load(profileWithId: configurationModel.id) { profileDTO in
                DispatchQueue.main.async { [weak self] in
                    if profileDTO == nil {
                        return
                    }
                    self?.configurationModel = ConfigurationModel(
                        id: configurationModel.id,
                        name: profileDTO?.name ?? "",
                        bio: profileDTO?.bio ?? "",
                        message: configurationModel.message,
                        date: configurationModel.date,
                        isOnline: configurationModel.isOnline,
                        hasUnreadMessages: configurationModel.hasUnreadMessages)
                    self?.applyConfiguration()
                    self?.profileImage.image = profileDTO?.image
                }
            }
        }
    }
    
    private func beginEditing() {
        saveGCDButton.isEnabled = false
        saveOperationButton.isEnabled = false
        nameTextField.text = configurationModel?.name
        bioTextField.text = configurationModel?.bio
        nameLabel.isHidden = true
        bioLabel.isHidden = true
        nameTextField.isHidden = false
        bioTextField.isHidden = false
        saveGCDButton.isHidden = false
        saveOperationButton.isHidden = false
    }
    
    private func endEditing() {
        nameLabel.isHidden = false
        bioLabel.isHidden = false
        nameTextField.isHidden = true
        bioTextField.isHidden = true
        saveGCDButton.isHidden = true
        saveOperationButton.isHidden = true
    }
}

struct ProfileDTO {
    let id: String
    let name: String?
    let bio: String?
    let image: UIImage?
}

protocol ProfileWriter {
    typealias ProfileWriterCompletion = ((_ success: Bool) -> Void)?
    
    func save(profile: ProfileDTO, completion: ProfileWriterCompletion)
}

class ProfileReader {
    typealias ProfileReaderCompletion = ((_ profileDTO: ProfileDTO?) -> Void)?
    
    func load(profileWithId id: String, completion: ProfileReaderCompletion) {
        print("Loading profile with id \(id)")
        DispatchQueue.global().async {
            let paths = ProfileFilePathsHelper.getPaths(profileID: id)
            let nameData = try? Data(contentsOf: paths.nameFile)
            let bioData = try? Data(contentsOf: paths.bioFile)
            let imageData = try? Data(contentsOf: paths.imageFile)
            if nameData == nil && bioData == nil && imageData == nil {
                completion?(nil)
                return
            }
            let name = nameData == nil ? nil : String(data: nameData!, encoding: .utf8)
            let bio = bioData == nil ? nil : String(data: bioData!, encoding: .utf8)
            var image: UIImage?
            DispatchQueue.main.sync {
                image = imageData == nil ? nil : UIImage(data: imageData!)
            }
            let profileDTO = ProfileDTO(id: id, name: name, bio: bio, image: image)
            completion?(profileDTO)
        }
    }
}

class GCDProfileWriter: ProfileWriter {
    func save(profile: ProfileDTO, completion: ProfileWriterCompletion) {
        DispatchQueue.global().async {
            var success = true
            defer {
                completion?(success)
            }
            let paths = ProfileFilePathsHelper.getPaths(profileID: profile.id)
            do {
                try profile.name?.data(using: .utf8)?.write(to: paths.nameFile)
                try profile.bio?.data(using: .utf8)?.write(to: paths.bioFile)
                try profile.image?.pngData()?.write(to: paths.imageFile)
            }
            catch {
                success = false
            }
        }
    }
}

final class ProfileFilePathsHelper {
    struct ProfileFilePaths {
        let nameFile: URL
        let bioFile: URL
        let imageFile: URL
    }
    
    private static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static func getPaths(profileID id: String) -> ProfileFilePaths {
        ProfileFilePaths(
            nameFile: documentsDirectory.appendingPathComponent("\(id)0.txt"),
            bioFile: documentsDirectory.appendingPathComponent("\(id)1.txt"),
            imageFile: documentsDirectory.appendingPathComponent("\(id)2.png"))
    }
}

class OperationProfileWriter: ProfileWriter {
    class WriteOperation: Operation {
        private let profile: ProfileDTO
        private let completion: ProfileWriterCompletion
        
        init(profile: ProfileDTO, completion: ProfileWriterCompletion) {
            self.profile = profile
            self.completion = completion
        }
        
        override func main() {
            print("Saving profile with id \(profile.id)")
            var success = true
            defer {
                completion?(success)
            }
            let paths = ProfileFilePathsHelper.getPaths(profileID: profile.id)
            do {
                try profile.name?.data(using: .utf8)?.write(to: paths.nameFile)
                try profile.bio?.data(using: .utf8)?.write(to: paths.bioFile)
                try profile.image?.pngData()?.write(to: paths.imageFile)
            }
            catch {
                success = false
            }
        }
    }
    
    private static let operationQueue = OperationQueue()
    
    func save(profile: ProfileDTO, completion: ProfileWriterCompletion) {
        let writeOperation = WriteOperation(profile: profile, completion: completion)
        OperationProfileWriter.operationQueue.addOperation(writeOperation)
    }
}
