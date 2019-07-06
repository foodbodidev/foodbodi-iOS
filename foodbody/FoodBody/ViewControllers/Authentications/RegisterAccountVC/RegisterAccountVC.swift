
//
//  RegisterAccountVC.swift
//  FoodBody
//
//  Created by Toan Tran on 6/21/19.
//  Copyright © 2019 KPT. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class RegisterAccountVC: BaseVC, GIDSignInUIDelegate{
    
    @IBOutlet weak var btnGoogleSignin: UIButton!
    @IBOutlet weak var btnEmail:UIButton!
    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    
    
    
    var userInfor: UserRequest = UserRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        configureLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func configureLayout() {
        emailView.layer.cornerRadius = 27
        emailView.clipsToBounds = true
        emailView.layer.borderWidth = 1
        
        facebookView.layer.cornerRadius = 27
        facebookView.clipsToBounds = true
        btnGoogleSignin.layer.cornerRadius = 27
        btnGoogleSignin.clipsToBounds = true
        
        emailView.layer.borderColor = UIColor(red: 25, green: 62, blue: 82).cgColor
        emailView.layer.borderWidth = 1
        
        
    }
    
    //MARK: action.
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
    @IBAction func actionCancel(_ sender: Any?){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionGoogleSignin(_ sender: Any?){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func actionEmail(_ sender: Any?) {
        let loginVC = getViewController(className: LoginVC.className, storyboard: FbConstants.AuthenticationSB)
        self.navigationController?.pushViewController(loginVC, animated: true);
    }
	
	@IBAction func actionLoginWithFacebook() {
        LoginManager.init().logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            guard  result != nil else { return }
			
            GraphRequest.init(graphPath: "me",
                              parameters: ["fields": "first_name, last_name, name, picture.width(150).height(150), email, birthday, id, gender"])
                .start(completionHandler: { (connection, account, error) in
                if let accountInfo = account as? [String: AnyObject] {
                    self.userInfor.lastName = accountInfo["last_name"] as? String
                    self.userInfor.firstName = accountInfo["first_name"] as? String
                    self.userInfor.userId = accountInfo["id"] as? String
                    self.userInfor.facebook_access_token = AccessToken.current?.tokenString
                }
                
                self.loginWithFaceBook()
            })
            
		}
	}
    
    
    private func loginWithFaceBook() {
        self.showLoading()
        
        RequestManager.faceBookSignIn(request: userInfor) { (result, error) in
            
            self.hideLoading()
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            
            if let result = result {
                if result.isSuccess {
                     FBAppDelegate.user = result
                     self.getUserProfile()
                } else {
                    self.alertMessage(message: result.message)
                }
            }
        }
    }
    
    private func getUserProfile() {
        self.showLoading()
        
        RequestManager.getProfile() { (result, error) in
            
            self.hideLoading()
            if let error = error {
                self.alertMessage(message: error.localizedDescription)
            }
            
            guard let result = result else { return }
            
            if result.isSuccess {
                if self.shouldUpdateProfile(user: result) {
                    // this means user dose not update user detail
                    let selectGenderVC = getViewController(className: SelectGenderVC.className, storyboard: FbConstants.AuthenticationSB)
                    self.navigationController?.pushViewController(selectGenderVC, animated: true)
                } else {
                    FBAppDelegate.gotoMainTab()
                }
            } else {
                self.alertMessage(message: result.message)
            }
        }
    }
    
    private func shouldUpdateProfile(user: User) -> Bool {
        return user.height == 0
    }
    
}
extension RegisterAccountVC:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            self.showLoading()
            let idToken:String = user.authentication.idToken // Safe to send to the server
            print("token", (idToken))
            RequestManager.googleSignInWithToken(request: idToken) { [weak self] (result, error) in
                self?.hideLoading()
                if let error = error {
                    print("error" + error.localizedDescription)
                }
                if let error = error {
                    self!.alertMessage(message: error.localizedDescription)
                }
                
                if let result = result {
                    if result.isSuccess {
                        FBAppDelegate.user = result;
                        self!.getUserProfile()
                    } else {
                        self!.alertMessage(message: result.message)
                    }
                }
                
                
            }
        }
    }
}
