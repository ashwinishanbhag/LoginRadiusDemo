//
//  ViewController.swift
//  LoginRadiusDemoSwift
//
//  Created by Anaaya Nayanesh Acharya on 12/04/17.
//  Copyright © 2017 Ashwini Acharya. All rights reserved.
//

import UIKit
import LoginRadiusSDK
import GoogleSignIn

let CONSUMER_KEY = "xoRzL7blZ2HKwdq3ZpcM1Q7Y1"
let CONSUMER_SECRET = "eWLoQuZ34L2oQ7XqgywSuKeYWudhKGAMaajlPsD7l6WCXv8zEC"


class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initializeGoogleSignIn()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     * Called when user tries to login using LoginRadius.
     */
    
    @IBAction func loginUsingLoginRadius(_ sender: Any) {
        
        UserDefaults.standard.setValue("Traditional", forKey: "LoginMethod")
        
        LoginRadiusRegistrationAction(action: "login")
    
    }
    
    /**
     * Called when user tries to initiate forgot password action using LoginRadius.
     */
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
        LoginRadiusRegistrationAction(action: "forgotpassword")

        
    }
    
    /**
     * Called when user tries to register using LoginRadius.
     */
    
     @IBAction func registerUserAction(_ sender: Any) {
        
        LoginRadiusRegistrationAction(action: "registration")

        
    }
    
   // Traditional Login and Registration methods using Login Radius
    func LoginRadiusRegistrationAction(action: String)
    {
        LoginRadiusRegistrationManager.sharedInstance().registration(withAction: action, in: self, completionHandler: {(success,error) in
            if(success)
            {
                print(" Task Succesful")
                if (action == "login")
                {
                    self.displayProfileViewIfLoggedIn()
                    
                }
                
                
            }
            else
            {
                
                print(error?.localizedDescription ?? "Error Occurred")
            }
        });

        
    }
    
    /**
     * Called when users use Facebook Login
     */
    
    @IBAction func loginUsingFacebook(_ sender: Any) {
        
        
        UserDefaults.standard.setValue("Facebook", forKey: "LoginMethod")
        
        LoginRadiusSocialLoginManager.sharedInstance().nativeFacebookLogin(withPermissions: ["fields":"first_name, last_name"], in: self, completionHandler: {
        (success,error) in
        if(success)
        {
            
            print("Facebook Login Successful");
            self.displayProfileViewIfLoggedIn()
        
        }else{
            print("Oops! Something went wrong")
            print(error!.localizedDescription)
            }});
    }
    
    
    /**
     * Called when users use Twitter Login
     */

    
    @IBAction func loginUsingTwitter(_ sender: Any) {
        
        UserDefaults.standard.setValue("Twitter", forKey: "LoginMethod")
        
        LoginRadiusSocialLoginManager.sharedInstance().nativeTwitter(withConsumerKey: CONSUMER_KEY, consumerSecret: CONSUMER_SECRET, in: self, completionHandler: {
            (success,error) in
            if(success)
            {
                print("Twitter Login Successful")
                self.displayProfileViewIfLoggedIn()
                
                
            }else{
                let errorMessage: String = (error?.localizedDescription)!
                self.alert(message:errorMessage)
            }
        });
    }
    
    
    /**
     * Called when users use Google Login
     */

    @IBAction func loginUsingGoogle(_ sender: Any) {
        
        UserDefaults.standard.setValue("Google", forKey: "LoginMethod")
        GIDSignIn.sharedInstance().signIn()
    }
    

    // Present a view that prompts the user to sign in with Google

    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    
    func sign(_ signIn: GIDSignIn!,
            dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Sign in delegate for Google Login
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            UserDefaults.standard.setValue(user.profile.givenName, forKey: "FirstName")
            UserDefaults.standard.setValue(user.profile.familyName, forKey: "LastName")
            UserDefaults.standard.setValue(user.profile.name, forKey: "FullName")
            self.openProfileViewController()
            
            /*********LoginRadiusSocialLoginManager.sharedInstance().nativeGoogleLogin(withAccessToken: idToken,completionHandler: {
                                            (success,error) in
                                            if(success)
                                            {
                                                print("Google Login Successful");
                                                
                
                                            }else{
                                                print("Oops! Something went wrong")
                                                print(error!.localizedDescription)
                                            }
                                        });**********/
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
        // ...
    }
    
    func initializeGoogleSignIn() {
        // Initialize sign-in for Google Login
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        GIDSignIn.sharedInstance().delegate = self as GIDSignInDelegate
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    
    func openProfileViewController () {
        self.performSegue(withIdentifier: "profileDisplaySegue", sender: self);
    }
    
    func displayProfileViewIfLoggedIn() {
        // Check if already login
        let defaults = UserDefaults.standard
        let user = defaults.integer(forKey: "isLoggedIn")
        if (user == 1) {
            self.openProfileViewController()
        }
    }

    
    
}

