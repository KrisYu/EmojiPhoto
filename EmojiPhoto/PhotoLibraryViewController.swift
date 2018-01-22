//
//  PhotoLibraryViewController.swift
//  EmojiPhoto
//
//  Created by Xue Yu on 1/21/18.
//  Copyright © 2018 XueYu. All rights reserved.
//

import UIKit

class PhotoLibraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func chooseFromPhotoLibrary(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "showEmojiView", sender: image)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showEmojiView" {
            if let destinationVC = segue.destination as? EmojiViewController, let image = sender as? UIImage {
                destinationVC.image = image
            }
        }
    }

}
