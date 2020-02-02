//
//  scanVC.swift
//  hackUCI
//
//  Created by Lorena Macias on 2/1/20.
//  Copyright © 2020 AWSStudent. All rights reserved.
//

import UIKit
import Foundation

class scanVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var textLable: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    //if user clicks on button then camera is activated
    
    var imagePicker: UIImagePickerController!
    
    var allergies: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isHidden = true
    
        view.backgroundColor = UIColor.green
        textLable.sizeToFit()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
//        post()
        //everytime someone sqipes, it calls the swipeAction function
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        //display the image on screen
        imageView.image = info[.originalImage] as? UIImage
        
        post()
    }
    
     func post(){
           let url = URL(string: "https://desolate-escarpment-39555.herokuapp.com/api/allergens")!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
        
//        let image : UIImage = UIImage(named:"trash")!
        

        let ima: UIImage = imageView.image!
        let image : UIImage = ima

        let imageData:NSData = image.jpegData(compressionQuality: 1.0)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
//            print("more \(strBase64)")
        
        var items: [AnyObject] = []
        var img: [String : AnyObject] = [:]
        var allergens: [String : AnyObject] = [:]
        img["img"] = strBase64 as AnyObject
        items.append(img as AnyObject)
        
        print(allergies!)
        
        
        allergens["allergies"] = allergies as AnyObject
        items.append(allergens as AnyObject)
        
        
        let jsonData = try! JSONSerialization.data(withJSONObject: items)
        print(jsonData)
//        let jsonString = JSONStringify(value: items as AnyObject)
//        print(jsonString)
        
        
        request.httpBody = jsonData
        request.setValue("applciation/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonString
        
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   print("error: \(error)")
               } else {

                
                   let str = "Hello World"
    //               print("hello \(imageData.toBase64())")
                   
                   if let response = response as? HTTPURLResponse {
                       print("statusCode: \(response.statusCode)")
                    let responseString = String(data: data!, encoding: .utf8)
                    
                    print("the response is: \(responseString)")
                    
                    let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let changeLater = json as? [String: Any] {
                        if let ingredients = changeLater["reactions"] as? String {
                                print("ingredients: \(ingredients)")
                            
                            
                            var ingredient = ingredients.components(separatedBy: ",")
                            print(ingredient)
                            
                            //if allergens are found in ingredients
                            if ingredient.count > 0 && ingredient[0] != "" {
                               
                                DispatchQueue.main.async {
                                    print("not safe")
                                 self.view.backgroundColor = UIColor.red
                                self.textLable.text = "Sorry, you cannot eat this"
                                    self.textLable.isHidden = false
                                }
                            }
                            //else, no alergens found
                            else{
                                DispatchQueue.main.async{
                                print("safe to eat")
                                self.textLable.text = "Safe to eat!"
                                    self.textLable.isHidden = false

                                    
                            }
                        }
                    }
                    
                   }
                   if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                       print("data: \(dataString)")
                   }
                }
               }
           }
           task.resume()
       }
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
       
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! scanVC
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
