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
        containerView = nib.instantiate(withOwner: self, options: nil).first as? OnboardingView
        
        containerView.scrollView = scrollView
        containerView.onLoggedIn = {
            self.finishSignIn()
        }
        containerView.onSkipLoginTapped = {
            self.finishSignIn()
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
