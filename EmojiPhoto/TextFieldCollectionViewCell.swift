//
//  TextFieldCollectionViewCell.swift
//  EmojiPhoto
//
//  Created by Xue Yu on 1/16/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    // closure, we set this in collection view controller, a nice trick way
    var resignationHanlder: (() -> Void)?
    
    // when it finishes editing, hit the return button, this function callsed
    func textFieldDidEndEditing(_ textField: UITextField) {
        // call this function when text field resigns
        resignationHanlder?()
    }
    
    
    // hide keyboard when hit return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
