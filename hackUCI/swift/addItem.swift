//
//  addItem.swift
//  hackUCI
//
//  Created by Lorena Macias on 2/1/20.
//  Copyright © 2020 AWSStudent. All rights reserved.
//

import UIKit

class addItem: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {
    
    var vc: ViewController?
    
    var searchItem = [String]()
    var allergies = ["milk", "egg", "nuts", "peanuts", "shellfish", "wheat", "soy", "fish"]
    
    var searching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemsVC: UITableView!
    
    var itemName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.searchItem.delegate = self
        self.itemsVC.delegate = self
        self.itemsVC.dataSource = self
        self.itemsVC.reloadData()
        get()

    }
    
    func get(){
        let url = URL(string: "https://desolate-escarpment-39555.herokuapp.com/api/allergens")!
         let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
             if let error = error {
                 print("error: \(error)")
             } else {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchItem.count
        } else {
            return self.allergies.count
        }
    }

    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
           let cell = itemsVC.dequeueReusableCell(withIdentifier: "cell")
            let item = allergies[indexPath.row]

        if searching{
            cell?.textLabel?.text = searchItem[indexPath.row]
        } else{
            cell?.textLabel?.text = allergies[indexPath.row]
        }
//        cell?.textLabel.font=[UIFont systemFontOfSize: 20]
           return cell!
       }

     public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchItem = allergies.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        itemsVC.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        itemsVC.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            self.itemName = searchItem[indexPath.row]
            
            if vc!.myAllergies.contains(searchItem[indexPath.row]){
                navigationController?.popViewController(animated: true)
            }
            else{
                vc!.myAllergies.append(searchItem[indexPath.row])
                vc!.tableView.reloadData()
                navigationController?.popViewController(animated: true)
            }
           
        } else{
            self.itemName = allergies[indexPath.row]

            if vc!.myAllergies.contains(allergies[indexPath.row]){
                navigationController?.popViewController(animated: true)
            }
            else{
                vc!.myAllergies.append(allergies[indexPath.row])
                           vc!.tableView.reloadData()
                           navigationController?.popViewController(animated: true)
            }
        }
//        performSegue(withIdentifier: "segItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ViewController
        vc.newItem = self.itemName
    }
}

extension UIViewController{
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        switch swipe.direction.rawValue{
        //1 meaning user swiped right
        case 1:
            performSegue(withIdentifier: "swipeRight", sender: self)
        //2 meaning user swiped left
        case 2:
            performSegue(withIdentifier: "swipeLeft", sender: self)
        default:
            break
        }
    }
}
