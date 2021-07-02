//
//  ViewController.swift
//  ihasura
//
//  Created by Ashok on 13/06/21.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loggedIn: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedIn.isHidden = true
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
   
    func apiCall(token :String){
        let params = Query.shared.termsOfUse()
        APIRequest.shared.postRequest(token: token, params: params,ofType: Social.self,onSuccess: { (result) in
            SVProgressHUD.dismiss()
            if result.data.socialMedia.count > 0{
                print(result.data.socialMedia.count)
                self.loggedIn.isHidden = false
                let socialMedia = (result.data.socialMedia.map{String($0.appName)}).joined(separator: ",")
                guard let name = self.currentUser?.displayName else {return}
                self.userLbl.text = """
                    Name : \(name)
                    
                    Social Media : \(socialMedia)
                    """
            }
        }) { (error) in
            
        }
    }
    
}

extension ViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.show()
        if let error = error {
            if error.localizedDescription == "The user canceled the sign-in flow."{
                Utilities.shared.showAlert(title: "Oops!", alertMessage: "The user cancelled the sign-in flow.", alertButton: "Okay", controller: self)
            }else{
                Utilities.shared.showAlert(title: "Oops!", alertMessage: error.localizedDescription, alertButton: "Okay", controller: self)
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
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
                self.apiCall(token: token)
            }
            
        }
    }
}


