//
//  ProfileViewController.swift
//  Vane
//
//  Created by Andrew on 14/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    @IBAction func logout(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "facebookViewController") as! UIViewController
        
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
}
