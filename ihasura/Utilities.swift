//
//  Utilities.swift
//  ihasura
//
//  Created by Ashok on 25/06/21.
//

import Foundation
import UIKit

class Utilities: NSObject {
    
    static let shared = Utilities()
    
    //MARK: -UIAlertView
    func showAlert(title alertTitle :String, alertMessage :String, alertButton :String?, controller: UIViewController){
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: alertButton, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        alertController.view.tintColor = UIColor.black
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
