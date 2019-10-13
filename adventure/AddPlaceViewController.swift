//
//  AddCountryViewController.swift
//  adventure
//
//  Created by Mike Budei on 8/6/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit
import CoreData

class AddPlaceViewController: UIViewController, TypeToStringProtocol {

    @IBOutlet weak var subtitleField: UITextField!
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    private lazy var imgPicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        return picker
    }()

    private var storage: NSManagedObjectContext?
    var placethumbnail: Data?
    var privateMOC = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    override func viewDidLoad() {
        super.viewDidLoad()
        imgPicker.delegate = self
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        privateMOC = context
    }

    @IBAction func savePlaces(_ sender: Any) {
        let isTitleValid = validateText(textfield: placeField)
        let isSubtitleValid = validateText(textfield: subtitleField)
        guard isTitleValid, isSubtitleValid, placethumbnail != nil else { return }

        storeNewPlace(title: placeField.text!, subtitle: subtitleField.text!, thumbnail: placethumbnail!)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addPic(_ sender: Any) {
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        present( imgPicker, animated: true, completion: nil )
    }

}

// MARK: - UIImagePickerControllerDelegate Methods
extension AddPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let img  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("Couldn't save img ")
            return
        }

        if let imageData = img.jpegData(compressionQuality: 0.7) {
            placethumbnail = imageData
            print(imageData)
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

}

// MARK: - Text Field Props
extension AddPlaceViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.9644854524, green: 0.3226449117, blue: 0, alpha: 0.8126690632)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 0
        if let text = textField.text?.trimmingCharacters(in: .whitespaces), text.isEmpty {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = #colorLiteral(red: 0.2830437087, green: 0.1914713017, blue: 0.9644854524, alpha: 0.8126690632)
            print("your field  is empty")
        } else {

        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 0
        textField.resignFirstResponder()
        return true
    }
}

extension AddPlaceViewController {
    private func storeNewPlace(title: String, subtitle: String, thumbnail: Data ) {
        let newPlace = Country(context: privateMOC)
        newPlace.id = UUID().description
        newPlace.title = title
        newPlace.subtitle = subtitle
        newPlace.thumbnail = thumbnail as NSData

        if privateMOC.hasChanges {
            do {
                try privateMOC.save()
            } catch {
                let error = error as NSError
                fatalError("Erorr \(error) has occured. \(error.userInfo)")
            }
        }
    }

    private func validateText(textfield: UITextField ) -> Bool {
        let text = textfield.text!
        let field = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !field.isEmpty else {
            print("field ")
            return false
        }
        return true
    }
}
