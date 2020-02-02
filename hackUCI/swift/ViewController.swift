//
//  ViewController.swift
//  hackUCI
//
//  Created by Lorena Macias on 1/31/20.
//  Copyright © 2020 AWSStudent. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!

    var myAllergies = ["milk", "egg", "peanuts"]
    var newItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItem()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        //place button
        button()
        
        //everytime someone swipes, it calls the swipeAction function
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
    }

    @objc func touchBtn(sender: UIButton!){
        performSegue(withIdentifier: "item", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "item") {
            let dest = segue.destination as! addItem
            dest.vc = self
        }
    }
    
    @objc func doubleTapped(){
        print("double tapped")
    }
    
    func addItem(){
        if self.newItem != "" {
            myAllergies.append(newItem)
        }
    }
    
    func button(){
        //custom button that displays over the tableView
        var addItemBtn = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 + 95, y: self.view.frame.size.height - 120), size: CGSize(width: 70, height: 70)))
        addItemBtn.backgroundColor = UIColor.blue
        addItemBtn.addTarget(self, action: #selector(touchBtn), for: .touchUpInside)
        addItemBtn.setTitle("+", for: .normal)
        addItemBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        addItemBtn.layer.cornerRadius = 25
        addItemBtn.clipsToBounds = true
        //add the button
        self.view.addSubview(addItemBtn)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAllergies.count
        }

    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let item = myAllergies[indexPath.row]

            cell?.textLabel?.text = myAllergies[indexPath.row]
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCell.EditingStyle.delete {
//            myAllergies.remove(at: indexPath.row)
//            tableView.reloadData()
//        }
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
    }
}



