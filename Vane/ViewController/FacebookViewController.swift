// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import FBSDKLoginKit
import UIKit


// Add this to the body
class FacebookViewController: UIViewController, LoginButtonDelegate, UIViewControllerTransitioningDelegate {
    
    let loginButton: FBLoginButton = {
        let button = FBLoginButton()
        return button
    }()
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("completed login")
        fetchProfile()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if AccessToken.current != nil {
            fetchProfile()
        } else {
            loginButton.delegate = self
            loginButton.center = view.center
            view.addSubview(loginButton)
        }
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
            
            let fbId = data["id"] as! String
            let fbFirstName = data["first_name"] as! String
            let fbLastName = data["last_name"] as! String
            let fbEmail = data["email"] as? String
        
            let defaults = UserDefaults.standard
            defaults.set(fbId, forKey: "fbId")
            defaults.set(fbFirstName, forKey: "fbFirstName")
            defaults.set(fbLastName, forKey: "fbLastName")
            defaults.set(fbEmail, forKey: "fbEmail")
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "tabBarViewController") as! UITabBarController
            
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
            
            print(data)
//            print(fbFirstName, fbLastName, fbId)
            
        }
    }
}
