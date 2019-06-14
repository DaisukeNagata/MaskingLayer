//
//  MaskImagePicker.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/26.
//

import Foundation
import MobileCoreServices

public class MaskImagePicker: NSObject, UIDocumentInteractionControllerDelegate {

    public func photoSegue(vc: UIViewController,bool: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pic = UIImagePickerController()
            if bool == true { pic.mediaTypes = [kUTTypeMovie as String] }
            pic.allowsEditing = true
            pic.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            vc.present(pic, animated: true)
        }
    }
}
