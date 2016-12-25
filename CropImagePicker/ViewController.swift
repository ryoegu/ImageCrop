//
//  ViewController.swift
//  CropImagePicker
//
//  Created by Ryo Eguchi on 2016/12/24.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imageView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    
        var imageCropVC : RSKImageCropViewController!
        imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        self.navigationController?.pushViewController(imageCropVC, animated: true)
        picker.dismiss(animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        //キャンセルボタンが押されたときの処理
        NSLog("cancel")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //トリミング前に呼び出される
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        //ここの「croppedImage」は、切り取られたあとの画像
        self.imageView.image = croppedImage
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //トリミングしたい領域を描画
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        
        let rect: CGRect = controller.maskRect
        
        
        let width = 343
        let height = 255
        
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: 0, y: height)
        let point3 = CGPoint(x: width, y: height)
        let point4 = CGPoint(x: width, y: 0)
        
        
        
        let square: UIBezierPath = UIBezierPath()
        square.move(to: point1)
        square.addLine(to: point2)
        square.addLine(to: point3)
        square.addLine(to: point4)
        square.close()
        
        return square
        
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
 
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var width, height: CGFloat!
        
        width = self.view.frame.width
        
        // 縦横比 = 1 : 2でトリミングしたい場合
        height = self.view.frame.width / 2
        
        // 正方形でトリミングしたい場合
        height = self.view.frame.width
        
        
        maskSize = CGSize(width: self.view.frame.width, height: height)
        
        
        
        let viewWidth = controller.view.frame.width
        let viewHeight = controller.view.frame.height
        
        
        
        //let maskRect = CGRect(x: viewWidth - maskSize.width) * 0.5, y:
        
        let maskRect = CGRect(x: (viewWidth-maskSize.width)*0.5, y: (viewHeight-maskSize.height)*0.5, width: maskSize.width, height: maskSize.height)
        
        
        return maskRect
    }
 

}

