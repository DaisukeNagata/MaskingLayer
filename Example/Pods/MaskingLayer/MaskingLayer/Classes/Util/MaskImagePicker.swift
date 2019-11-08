//
//  MaskImagePicker.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/08/26.
//

import Foundation
import MobileCoreServices


class MaskImagePicker: NSObject, UIDocumentInteractionControllerDelegate {

    func photoSegue(vc: UIViewController, mo: MaskingLayerViewModel,bool: Bool) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pic = UIImagePickerController()
            if bool == true { pic.mediaTypes = [kUTTypeMovie as String] }
            pic.allowsEditing = true
            pic.delegate = mo 
            vc.present(pic, animated: true)
        }
    }
}
