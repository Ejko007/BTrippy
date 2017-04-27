//
//  singInVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog
import ParseFacebookUtilsV4

class singInVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    // Text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    // Buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var otherLbl: UILabel!
    @IBOutlet weak var otherLoginOptionsView: UIView!
    @IBOutlet weak var signincocialImg: UIImageView!
    
    // default function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Font of label
        label.font = UIFont(name: "Pacifico", size: 25)
        
        
        // alignement
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20, height: 50)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width / 3, height: 30)
        signInBtn.layer.cornerRadius = signInBtn.frame.size.width / 20
        signUpBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 3 - 20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width / 3, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        
        otherLoginOptionsView.layer.borderWidth = 1
        otherLoginOptionsView.layer.borderColor = UIColor.white.cgColor
        otherLoginOptionsView.layer.cornerRadius = otherLoginOptionsView.frame.size.width / 50
        otherLoginOptionsView.frame = CGRect(x: 10, y: signInBtn.frame.origin.y + 100, width: self.view.frame.size.width - 20, height: 100)
        otherLoginOptionsView.backgroundColor = UIColor.clear
        
        facebookBtn.layer.cornerRadius = facebookBtn.frame.size.width / 20
        facebookBtn.frame = CGRect(x: 10, y: 60, width: self.view.frame.size.width / 3, height: 30)
        
        twitterBtn.layer.cornerRadius = twitterBtn.frame.size.width / 20
        twitterBtn.frame = CGRect(x: otherLoginOptionsView.frame.size.width - otherLoginOptionsView.frame.size.width / 3 - 20, y: 60, width: self.view.frame.size.width / 3, height: 30)
 
        signincocialImg.frame = CGRect(x: self.view.frame.size.width / 2 - 60, y: -50, width: 100, height: 100)
        signincocialImg.layer.cornerRadius = signincocialImg.frame.height / 2
        signincocialImg.clipsToBounds = true
        _ = signincocialImg.image?.imageWithColor(tintColor: UIColor.red.withAlphaComponent(0.3))
        
        otherLbl.textColor = UIColor.white
        otherLbl.text = or_use_str
        otherLbl.frame = CGRect(x: 0, y: 0, width: 120, height: 20)
 
        otherLoginOptionsView.addSubview(signincocialImg)
        otherLoginOptionsView.addSubview(facebookBtn)
        otherLoginOptionsView.addSubview(twitterBtn)
    
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
    }
    
    // hide keyboard
    func hideKeyboard (recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    
    @IBAction func signInBtn_click(_ sender: AnyObject) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if text field are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty) {
            
            // Show alert mesage
            
            let alert = PopupDialog(title: error_str, message: no_login_and_password_error_str)
            let ok = DefaultButton(title: ok_str, action: nil)
            alert.addButtons([ok])
            self.present(alert, animated: true, completion: nil)
            
        }
        
        // login function
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:Error?) in
            
            if error == nil {
                
                // remeber user or save in memory did the user login or not
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                // call login function from AppDelegate.swoft class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            } else {
                
                // Show alert mesage
                let alert = PopupDialog(title: error_str, message: error!.localizedDescription)
                let ok = DefaultButton(title: ok_str, action: nil)
                alert.addButtons([ok])
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func facebookBtn_tapped(_ sender: UIButton) {
        
        PFFacebookUtils.logInInBackground(withReadPermissions: ["public_profile","email"]) { (user: PFUser?, error: Error?) in
            
            if(error != nil) {
                //Display an alert message
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                
                myAlert.addAction(okAction);
                self.present(myAlert, animated:true, completion:nil);
                
                return
            }
            
            print(user!)
            print("Current user token=\(FBSDKAccessToken.current().tokenString)")
            print("Current user id \(FBSDKAccessToken.current().userID)")
            
            // --------------------------
            
            // facebook login management
            let requestParameters = ["fields": "id, email, first_name, last_name, gender, name, picture.type(large)"]
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
            graphRequest.start(completionHandler: { (connection, result, error: Error?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if result != nil {
                    
                    print("result \(String(describing: result))!")
                
                    guard let result = result as? NSDictionary,
                        let email = result["email"] as? String!,
                        let user_name = result["name"] as? String!,
                        let first_name = result["first_name"] as? String!,
                        let last_name = result["last_name"] as? String!,
                        let user_gender = result["gender"] as? String!,
                        let user_id_fb = result["id"] as? String!
                        else {
                            return
                    }
                    
                    print(email)
                    print(user_name)
                    print(first_name)
                    print(last_name)
                    print(user_gender)
                    print(user_id_fb)
                    
                    let myUser:PFUser = PFUser.current()!
                    
                    // Save first name
                    if first_name != nil {
                        myUser.setObject(first_name, forKey: "first_name")
                        myUser.setObject(first_name, forKey: "username")
                    }
                    
                    // Save last name
                    if last_name != nil {
                        myUser.setObject(last_name, forKey: "last_name")
                        if (myUser.username?.isEmpty)! {
                            myUser.setObject(last_name, forKey: "username")
                        }
                    }
                    
                    // Save email address
                    if email != nil {
                        myUser.setObject(email, forKey: "email")
                    }
                    
                    // Save gender
                    if user_gender != nil {
                        myUser.setObject(user_gender, forKey: "gender")
                    }
                    
                    // Save fullname
                    if (first_name != nil) && (last_name != nil) {
                        myUser.setObject(first_name.lowercased() + " " + last_name.lowercased(), forKey: "fullname")
                    }
                    
                    // get the localized country name (in my case, it's US English)
                    let currencyCode = getValidCurrencyCode()
                    myUser.setObject(currencyCode, forKey: "currencyBase")
                                        
                    DispatchQueue.global(qos: .userInitiated).async {

                        // Get Facebook profile picture
                        let userProfile = "https://graph.facebook.com/" + user_id_fb + "/picture?type=large"
                        let userProfilePictureURL = URL(string: userProfile)
                        let userProfilePictureData = NSData(contentsOf: userProfilePictureURL!)
                        if userProfilePictureData != nil {
                            let avaImage = UIImage(data: userProfilePictureData! as Data)
                            let avaData = UIImageJPEGRepresentation(avaImage!, 0.5)
                            let avaFile = PFFile(name: "ava.jpg", data: avaData!)
                            myUser.setObject(avaFile!, forKey: "ava")
                        }
                        
                        myUser.saveInBackground(block: { (success: Bool, error: Error?) in
                            if error == nil {
                                
                                // User details are updated from Facebook
                                if success {
                                    // remeber user or save in memory did the user login or not
                                    UserDefaults.standard.set(user!.username, forKey: "username")
                                    UserDefaults.standard.synchronize()
                                    
                                    // call login function from AppDelegate.swoft class
                                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.login()
                                } else {
                                    
                                    // Show alert mesage
                                    let alert = PopupDialog(title: error_str, message: error!.localizedDescription)
                                    let ok = DefaultButton(title: ok_str, action: nil)
                                    alert.addButtons([ok])
                                    self.present(alert, animated: true, completion: nil)
                                }
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                }
           })

            
            
            
            
            
            // --------------------------
            
            if(FBSDKAccessToken.current() != nil) {
                let protectedPage = self.storyboard?.instantiateViewController(withIdentifier: "ProtectedPageViewController") as! navVC
                
                let protectedPageNav = UINavigationController(rootViewController: protectedPage)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = protectedPageNav
                
            }
        }
    }
    
    @IBAction func twitterBtn_tapped(_ sender: UIButton) {
        
        
    }
    
    
}

