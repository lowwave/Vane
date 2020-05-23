//
//  OnboardingView.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OnboardingView: UIView {
    
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    @IBOutlet weak var nextButtonOne: UIButton!
    @IBOutlet weak var nextButtonTwo: UIButton!
    
    weak var scrollView: UIScrollView!
    
    var onSkipLoginTapped: () -> () = {}
    var onLoggedIn: () -> () = {}
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        fbLoginButton.delegate = self
        nextButtonOne.layer.cornerRadius = 5
        nextButtonTwo.layer.cornerRadius = 5
    }
    
    @IBAction func nextButtonTaped(_ sender: Any) {
        let tag = CGFloat((sender as? UIButton)?.tag ?? 0)
        var targetRect = scrollView.bounds
        targetRect.origin.x = scrollView.bounds.width * tag
        scrollView.scrollRectToVisible(targetRect, animated: true)
    }
    
    @IBAction func skipLoginTapped(_ sender: Any) {
        onSkipLoginTapped()
    }
}

extension OnboardingView: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("completed login")
        fetchProfile()
    }
    
    func fetchProfile() {
        print("fetch profile")
        let parameters = ["fields" : "email, first_name, last_name"]
        GraphRequest(graphPath: "me", parameters: parameters).start {
            (connection, result, error) -> Void in
            
            if error != nil {
                print("error : ", error!)
                return
            }
            
            let data = result as! [String: Any]
            
//            let fbFirstName = data["first_name"] as! String
//            let fbLastName = data["last_name"] as! String
//            let fbId = data["id"] as! String
//            let fbEmail = data["email"] as? String
            
            print(data)
            
            self.onLoggedIn()
        }
    }
}
