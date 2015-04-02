////
////  CameraService.swift
////  聚会游戏
////
////  Created by lane on 15/3/26.
////  Copyright (c) 2015年 lane. All rights reserved.
////
//
//import UIKit
//
//class CameraService: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    func camera(){
//        var c = UIImagePickerController()
//        c.delegate = self
//        //从相机获取新照片
//        c.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        self.presentViewController(c, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        var image:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
//        var imageView = UIImageView(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
//        self.view.addSubview(imageView)
//        imageView.image = image
//        
//        picker.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//
//}
