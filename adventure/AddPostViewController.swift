//
//  AddPostViewController.swift
//  adventure
//
//  Created by Mike Budei on 10/8/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit
import CoreData

class AddPostViewController: UIViewController {

    @IBOutlet weak var articleTitleField: UITextField!
    @IBOutlet weak var articleSubtitleField: UITextField!
    @IBOutlet weak var articleTextField: UITextField!
    private var managedContextObject: NSManagedObjectContext?
    private var country: Country?
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addArticle(_ sender: Any) {
        let isTitleValid = validateText(textfield: articleTitleField)
        let isSubtitleValid = validateText(textfield: articleSubtitleField)
        let isTextValid = validateText(textfield: articleTextField)
        let date = NSDate() as Date
        guard isTitleValid, isSubtitleValid, isTextValid != false else {return }
        addNewArticle(title: articleTitleField.text!, subtitle: articleSubtitleField.text!, post: articleTextField.text!, date: date)
        navigationController?.popViewController(animated: true)
    }

    func setupController(context: NSManagedObjectContext?, country: Country?) {
        self.managedContextObject = context
        self.country = country
    }
}

extension AddPostViewController: UITextFieldDelegate {
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         textField.layer.borderWidth = 1
         textField.layer.borderColor = #colorLiteral(red: 0.9644854524, green: 0.3226449117, blue: 0, alpha: 0.8126690632)
         return true
     }

     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         textField.layer.borderWidth = 0
         if let text = textField.text?.trimmingCharacters(in: .whitespaces), text.isEmpty {
             textField.layer.borderWidth = 1
                textField.layer.borderColor = #colorLiteral(red: 1, green: 0.05602073549, blue: 0.1113501106, alpha: 1)
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

// MARK: - Add New Article
extension AddPostViewController {
    private func addNewArticle(title: String, subtitle: String, post: String, date: Date) {
        guard let context = managedContextObject else { return }
          let newArticle = Article(context: context)
          newArticle.id = UUID().description
          newArticle.title = title
          newArticle.subtitle = subtitle
          newArticle.post = post
          newArticle.country = country!
        newArticle.date = date
        if context.hasChanges {
              do {
                  try context.save()
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
              print("field")
              return false
          }
          return true
      }
}
