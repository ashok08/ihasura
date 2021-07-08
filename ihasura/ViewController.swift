//
//  ViewController.swift
//  ihasura
//
//  Created by Ashok on 13/06/21.
//

import UIKit
import Firebase
import GoogleSignIn
import NVActivityIndicatorView

class ViewController: UIViewController {
    @IBOutlet weak var loader: NVActivityIndicatorView!

    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        self.loader.type = .ballRotateChase
    }
    
    func insertUserDetails(token :String){
        
        guard let name = self.currentUser?.displayName else {return}
        guard let image = self.currentUser?.photoURL else {return}
        guard let auth_id = self.currentUser?.uid else {return}
        
        let params = Query.shared.checkUser(authID: auth_id)
        APIRequest.shared.postRequest(token: token, params: params,ofType: Users.self,onSuccess: { (result) in
            self.loader.isHidden = true
            if result.data.checkdata.count > 0{
                self.loader.stopAnimating()
                Utilities.shared.showAlert(title: "Oops!", alertMessage: "User already has been created!", alertButton: "Okay", controller: self)
                
            }else{
                let params = Query.shared.inserUserDetails(name: name, authID: auth_id, image: image.absoluteString)
                APIRequest.shared.postRequest(token: token, params: params,ofType: Users.self,onSuccess: { (result) in
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                    if result.data.insertdata.affectedRows > 0{
                        print("User has been inserted!")
                        Utilities.shared.showAlert(title: "Yay!", alertMessage: "User creation successfull!", alertButton: "Okay", controller: self)
                    }
                }) { (error) in
                    
              }
            }
        }) { (error) in
            
        }
    }
    
    @IBAction func signinBtnTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:break
        case 1:GIDSignIn.sharedInstance().signIn()
        case 2:break
        default: break
        }
    }
}

extension ViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.loader.startAnimating()
        if let error = error {
            if error.localizedDescription == "The user canceled the sign-in flow."{
                self.loader.stopAnimating()
                Utilities.shared.showAlert(title: "Oops!", alertMessage: "The user cancelled the sign-in flow.", alertButton: "Okay", controller: self)
            }else{
                self.loader.stopAnimating()
                Utilities.shared.showAlert(title: "Oops!", alertMessage: error.localizedDescription, alertButton: "Okay", controller: self)
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                self.loader.stopAnimating()
                Utilities.shared.showAlert(title: "Oops!", alertMessage: error.localizedDescription, alertButton: "Okay", controller: self)
                return
            }
            
            if let token = GIDSignIn.sharedInstance().currentUser.authentication.accessToken{
                if let email = authResult?.user.email, let userName =  authResult?.user.displayName{
                    if let emailVerified = authResult?.user.isEmailVerified,emailVerified == true{
                        print(token + email + userName)
                        self.getCurrentUserIdToken()
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func getCurrentUserIdToken(){
        currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                Utilities.shared.showAlert(title: "Oops!", alertMessage: error.localizedDescription, alertButton: "Okay", controller: self )
                return
            }
            if let token = idToken{
                self.insertUserDetails(token: token)
            }
            
        }
    }
}


