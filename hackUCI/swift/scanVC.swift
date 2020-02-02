//
//  scanVC.swift
//  hackUCI
//
//  Created by Lorena Macias on 2/1/20.
//  Copyright © 2020 AWSStudent. All rights reserved.
//

import UIKit

class scanVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    //if user clicks on button then camera is activated
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        
//        present(imagePicker, animated: true, completion: nil)
        post()
        //everytime someone sqipes, it calls the swipeAction function
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        //display the image on screen
        imageView.image = info[.originalImage] as? UIImage
    }
    
     func post(){
           let url = URL(string: "https://desolate-escarpment-39555.herokuapp.com/api/allergens")!
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("error: \(error)")
               } else {
                  
                let image : UIImage = UIImage(named:"trash")!
                let imageData:NSData = image.pngData()! as NSData
                let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                    print("more \(strBase64)")
                
                   let str = "Hello World"
    //               print("hello \(imageData.toBase64())")
                   
                   if let response = response as? HTTPURLResponse {
                       print("statusCode: \(response.statusCode)")
                   }
                   if let data = data, let dataString = String(data: data, encoding: .utf8) {
                       print("data: \(dataString)")
                   }
               }
           }
           task.resume()
       }
    

    
}


extension String {
        func fromBase64() -> String? {
                guard let data = Data(base64Encoded: self) else {
                        return nil
                }
                return String(data: data, encoding: .utf8)
        }
        func toBase64() -> String {
                return Data(self.utf8).base64EncodedString()
        }
}
