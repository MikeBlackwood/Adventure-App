//
//  AddPostViewController.swift
//  adventure
//
//  Created by Mike Budei on 10/8/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postSubtitle: UITextField!
    @IBOutlet weak var postText: UITextField!
    @IBOutlet weak var savePostBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

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
