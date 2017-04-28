//
//  resetPasswordVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        emailTxt.frame = CGRect(x: 10, y: self.view.frame.size.height / 2 - 30, width: self.view.frame.size.width - 20, height: 30)
        emailTxt.placeholder = email_str
        
        resetBtn.frame = CGRect(x: 10, y: self.view.frame.size.height - 50, width: self.view.frame.size.width - 20, height: 40)
        resetBtn.layer.cornerRadius = resetBtn.frame.size.width / 50
        resetBtn.setTitle(set_str, for: .normal)
        customizeButton(button: resetBtn)
        
        cancelBtn.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width - 20, height: 30)
        cancelBtn.setTitle(back_str, for: .normal)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        bg.addBlurEffect(blurEffect: .regular)
        self.view.addSubview(bg)
    }
    
    // Hide keyboard if tap
    func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }

    // Click to reset button
    @IBAction func restBtn_click(_ sender: AnyObject) {
        
        // Hide keyboard
        self.view.endEditing(true)
        
        // if email addess field is empty
        if emailTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "Chyba", message: "Vyplňte políčko s email adresou.", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        // Request for resetting password
        PFUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success: Bool, error: Error?) -> Void in
            if success {
                
                // show alert message
                let alert = UIAlertController(title: "Informace", message: "Na adresu '\(self.emailTxt.text!)' vám byly odeslány instrukce k nastavení hesla.", preferredStyle: UIAlertControllerStyle.alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    // Click to cancel button
    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
