//
//  OnboardingViewController.swift
//  Vane
//
//  Created by Andrey Antosha on 22/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OnboardingViewController: UIViewController {
    
    private var containerView: OnboardingView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "OnboardingView", bundle: nil)
        let manager = DefaultsManager()
        
        if manager.isNewUser() == false {
            finishSignIn()
        }
        
        containerView = nib.instantiate(withOwner: self, options: nil).first as? OnboardingView
        
        containerView.scrollView = scrollView
        containerView.onLoggedIn = {
            self.finishSignIn()
            manager.setIsNotNewUser()
        }
        containerView.onSkipLoginTapped = {
            self.finishSignIn()
            manager.setIsNotNewUser()
        }
        
        scrollView.addSubview(containerView)
        
        containerView.height(to: view)
        containerView.leftToSuperview()
        containerView.top(to: view)
        containerView.width(to: view, multiplier: 3)
        
        scrollView.contentSize = CGSize(width: view.bounds.width * 3, height: 1)
    }
    
    func finishSignIn() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarViewController") as! UITabBarController
        self.view.window?.rootViewController = controller
    }
}

class DefaultsManager {
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
        UserDefaults.standard.synchronize()
    }
}
