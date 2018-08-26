//
//  MaskImagePicker.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/26.
//

import Foundation


public class MaskImagePicker: NSObject, UIDocumentInteractionControllerDelegate {
    
    open var pickerImage = UIImage()
    
    public func photeSegue(vc: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pic = UIImagePickerController()
            pic.allowsEditing = true
            pic.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            vc.present(pic, animated: true)
        }
    }
}
