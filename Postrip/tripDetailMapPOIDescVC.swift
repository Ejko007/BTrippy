//
//  tripDetailMapPOIDescVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

var descriptionuuid = String()

class tripDetailMapPOIDescVC: UIViewController {

    @IBOutlet weak var tripDetailDescLabel: UILabel!
    @IBOutlet weak var tripDetailTxtView: UITextView!
    @IBOutlet weak var tripDetailDescSaveBtn: UIButton!

    var isOwner:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // POI belongs to current user
        if username4post.lowercased() == PFUser.current()?.username?.lowercased() {
            isOwner = true
        } else {
            isOwner = false
        }

        // navigation bar title
        self.navigationItem.title = poi_desc_str.uppercased()
        
        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // set textview parameters
        tripDetailTxtView.backgroundColor = UIColor(colorLiteralRed: 242.0 / 255, green: 242.0 / 255, blue: 242.0 / 255, alpha: 1)
        tripDetailTxtView.layer.cornerRadius = 5.0
        tripDetailTxtView.clipsToBounds = true
        
        // disable save btn by default
        tripDetailDescSaveBtn.isEnabled = false
        tripDetailDescSaveBtn.backgroundColor = .lightGray
        tripDetailDescSaveBtn.setTitle(save_str, for: .normal)
        tripDetailDescSaveBtn.tintColor = .white
        
        // localization of labels
        tripDetailDescLabel.text = description_str
        
        // add constraints        
        tripDetailDescLabel.translatesAutoresizingMaskIntoConstraints = false
        tripDetailTxtView.translatesAutoresizingMaskIntoConstraints = false
        tripDetailDescSaveBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // height of navigationbar
        let width = self.view.frame.size.width
        let tabbarheight = (self.tabBarController?.tabBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(\(tabbarheight + 10))-[desclbl]-10-[desctxtview]-10-[savebtn(\(width / 8))]-|",
            options: [],
            metrics: nil, views: ["desclbl":tripDetailDescLabel,"desctxtview":tripDetailTxtView, "savebtn":tripDetailDescSaveBtn]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[desclbl]-10-|",
            options: [],
            metrics: nil, views: ["desclbl":tripDetailDescLabel]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[desctxtview]-10-|",
            options: [],
            metrics: nil, views: ["desctxtview":tripDetailTxtView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[savebtn]-0-|",
            options: [],
            metrics: nil, views: ["savebtn":tripDetailDescSaveBtn]))
        
        // load data
        tripDetailTxtView.text = descriptionuuid
    }

    // go back function
    func back(sender: UIBarButtonItem) {
        
        //push back
        if !descriptionuuid.isEmpty {
            descriptionuuid = ""
        }

        self.dismiss(animated: true, completion: nil)
    }

    // hide keyboard func
    func hideKeyboardTap () {
        self.view.endEditing(true)
    }
    
    @IBAction func tripDetailDescButtonTapped(_ sender: Any) {
        
        descriptionuuid = tripDetailTxtView.text
        print(descriptionuuid)
        // go back to previous view controller
        _ = navigationController?.popViewController(animated: true)
    }
}
