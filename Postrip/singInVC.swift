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
import ParseTwitterUtils

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
    
    var viewsToAnimate: [UIView?]!
    var viewsFinalYPosition : [CGFloat]!
    
    private let twitterAPIUserDetailsURL = "https://api.twitter.com/1.1/users/show.json?screen_name="
    
    // default function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Font of label
        label.font = UIFont(name: "Pacifico", size: 40)
        label.sizeToFit()
        
        // alignement
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20, height: 70)
        usernameTxt.frame = CGRect(x: 0, y: label.frame.origin.y + 100, width: self.view.frame.size.width, height: 30)
        usernameTxt.layer.borderColor = UIColor.lightText.cgColor
        usernameTxt.layer.borderWidth = 1.0
        usernameTxt.placeholder = user_name_str

        passwordTxt.frame = CGRect(x: 0, y: usernameTxt.frame.origin.y + 30, width: self.view.frame.size.width, height: 30)
        passwordTxt.layer.borderColor = UIColor.lightText.cgColor
        passwordTxt.layer.borderWidth = 1.0
        passwordTxt.placeholder = password_str
        
        signInBtn.frame = CGRect(x: 0, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width, height: 40)
        signInBtn.setTitle(sign_in_str, for: .normal)
        signInBtn?.setBackgroundImage(nil, for: .normal)
        signInBtn?.backgroundColor = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)
        
        forgotBtn.frame = CGRect(x: 10, y: signInBtn.frame.origin.y + 50, width: self.view.frame.size.width - 20, height: 40)
        forgotBtn.setTitle(forgotten_password_str, for: .normal)
        
        facebookBtn.layer.cornerRadius = facebookBtn.frame.size.width / 30
        facebookBtn.frame = CGRect(x: 10, y: self.view.frame.size.height - 100, width: self.view.frame.size.width / 2 - 20, height: 40)
        facebookBtn.setTitle(facebook_str, for: .normal)
        
        twitterBtn.layer.cornerRadius = twitterBtn.frame.size.width / 30
        twitterBtn.frame = CGRect(x: self.view.frame.size.width - facebookBtn.frame.size.width - 20, y: self.view.frame.size.height - 100, width: self.view.frame.size.width / 2 - 10, height: 40)
        twitterBtn.setTitle(twitter_str, for: .normal)
        
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 50
        signUpBtn.frame = CGRect(x: 10, y: facebookBtn.frame.origin.y + 50, width: self.view.frame.size.width - 20, height: 40)
        signUpBtn.setTitle(sign_up_str, for: .normal)

        // customize the look of buttons
        if let facebookImage = UIImage(named: "facebook_logo.png") {
            let newFacebookImg = resizeImage(facebookImage, targetSize: CGSize(width: 30, height: 30))
            facebookBtn.setTitle("Facebook", for: UIControlState.normal)
            facebookBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            let tintedFacebookImage = newFacebookImg.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            
            facebookBtn.setImage(tintedFacebookImage, for: .normal)
            facebookBtn.tintColor = .white
            facebookBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        if let twitterImage = UIImage(named: "twitter_logo.png") {
            let newTwitterImg = resizeImage(twitterImage, targetSize: CGSize(width: 25, height: 25))
            twitterBtn.setTitle("Twitter", for: UIControlState.normal)
            twitterBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            let tintedTwitterImage = newTwitterImg.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            twitterBtn.setImage(tintedTwitterImage, for: .normal)
            twitterBtn.tintColor = .white
            twitterBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        customizeButton(button: facebookBtn)
        customizeButton(button: twitterBtn)
        customizeButton(button: signUpBtn)
        
        viewsToAnimate = [usernameTxt, passwordTxt, signInBtn, forgotBtn, facebookBtn, twitterBtn, signUpBtn, label]

        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpeg")
        bg.layer.zPosition = -1
        bg.addBlurEffect(blurEffect: .regular)
        self.view.addSubview(bg)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        // backgroundImage.frame = CGRectMake( 0,  0,  logInView!.frame.width,  logInView!.frame.height)
        
        // position logo at top with larger frame
        // logInView!.logo!.sizeToFit()
        // let logoFrame = logInView!.logo!.frame
        // logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
        
        // We to position all the views off the bottom of the screen
        // and then make them rise back to where they should be
        // so we track their final position in an array
        // but change their frame so they are shifted downwards off the screen
//        viewsFinalYPosition = [CGFloat]()
//        for viewToAnimate in viewsToAnimate {
//            let currentFrame = viewToAnimate?.frame
//            viewsFinalYPosition.append((currentFrame?.origin.y)!)
//            viewToAnimate?.frame = CGRect(x: (currentFrame?.origin.x)!, y: self.view.frame.height + (currentFrame?.origin.y)!, width: (currentFrame?.width)!, height: (currentFrame?.height)!)
//        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        
        // Now we'll animate all our views back into view
        // and, using the final position we stored, we'll
        // reset them to where they should be
//        if viewsFinalYPosition.count == self.viewsToAnimate.count {
//            UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseInOut,  animations: { () -> Void in
//                for viewToAnimate in self.viewsToAnimate {
//                    let currentFrame = viewToAnimate?.frame
//                    viewToAnimate?.frame = CGRect(x: (currentFrame?.origin.x)!, y: self.viewsFinalYPosition.remove(at: 0), width: (currentFrame?.width)!, height: (currentFrame?.height)!)
//                }
//            }, completion: nil)
//        }
    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
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
        //if PFUser.current() == nil {
            PFTwitterUtils.logIn { (user: PFUser?, error: Error?) in
                if let user = user {
                    if user.isNew {
                        // process user object
                        self.processTwitterUser()
                    } else {
                        // process user object
                        self.processTwitterUser()
                    }
                    
                } else {
                    print("The user cancelled Twitter login.")
                }
            }
       // }
    }
    
    func processTwitterUser() {
        let spinningActivity = MBProgressHUD.showAdded(to: view, animated: true)
        spinningActivity.label.text = loading_str
        spinningActivity.detailsLabel.text = please_wait_str + "..."
        
        let pfTwitter = PFTwitterUtils.twitter()
        let twitterUserName = pfTwitter?.screenName
        let userDetailsURL = twitterAPIUserDetailsURL + twitterUserName!
        
        let myURL = NSURL(string: userDetailsURL)
        let request = NSMutableURLRequest(url: myURL! as URL)
        request.httpMethod = "GET"
        
        pfTwitter!.sign(request)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil {
                spinningActivity.hide(animated: true)
                
                let alert = PopupDialog(title: error_str, message: error!.localizedDescription)
                let ok = DefaultButton(title: ok_str, action: nil)
                alert.addButtons([ok])
                self.present(alert, animated: true, completion: nil)
            
                PFUser.logOut()
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    if let profileImageURL = parseJSON["profile_image_url"] as? String {
                        let profilePictureData = NSData(contentsOf: NSURL(string: profileImageURL)! as URL)
                        if profilePictureData != nil {
                            //let profileFileObject = PFFile(data: profilePictureData! as Data)
                            let avaImage = UIImage(data: profilePictureData! as Data)
                            let avaData = UIImageJPEGRepresentation(avaImage!, 0.5)
                            let avaFile = PFFile(name: "ava.jpg", data: avaData!)
                            PFUser.current()?.setObject(avaFile!, forKey: "ava")
                            //PFUser.current()?.setObject(profileFileObject!, forKey: "ava")
                        }
                        
                        let fullname = parseJSON["name"]!
                        PFUser.current()?.username = twitterUserName
                        PFUser.current()?.setObject(twitterUserName!, forKey: "username")
                        PFUser.current()?.setObject(fullname, forKey: "fullname")
                        
                        let currencyCode = getValidCurrencyCode()
                        PFUser.current()?.setObject(currencyCode, forKey: "currencyBase")
                        PFUser.current()?.setObject("male", forKey: "gender")
                    
                        PFUser.current()?.saveInBackground(block: { (success, error) in
                            
                            if error != nil {
                                spinningActivity.hide(animated: true)

                                let alert = PopupDialog(title: error_str, message: error!.localizedDescription)
                                let ok = DefaultButton(title: ok_str, action: nil)
                                alert.addButtons([ok])
                                self.present(alert, animated: true, completion: nil)
                                PFUser.logOut()
                                
                                return
                            } else {
                                
                                // remeber user or save in memory did the user login or not
                                UserDefaults.standard.set(twitterUserName, forKey: "username")
                                UserDefaults.standard.synchronize()
                                
                                spinningActivity.hide(animated: true)
                                // perform login
                                DispatchQueue.global(qos: .userInitiated).async {
                                    // call login function from AppDelegate.swift class
                                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.login()
                                }
                            }
                        })
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}

