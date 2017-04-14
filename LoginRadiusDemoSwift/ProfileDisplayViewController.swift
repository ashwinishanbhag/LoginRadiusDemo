//
//  ProfileDisplayViewController.swift
//  LoginRadiusDemoSwift
//
//  Created by Anaaya Nayanesh Acharya on 12/04/17.
//  Copyright © 2017 Ashwini Acharya. All rights reserved.
//

import UIKit
import LoginRadiusSDK

class ProfileDisplayViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    
    @IBOutlet weak var LastNameTextField: UITextField!
    
    
    @IBOutlet weak var additionalDataTextField: UITextField!
    
    
    @IBOutlet weak var editButton: UIButton!
   
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let title:String = UserDefaults.standard.value(forKey: "LoginMethod") as! String
        titleLabel.text =  " \(title) Login"
        
        // Setting the delegates for textfields
        
        firstNameTextField.delegate = self
        LastNameTextField.delegate = self
        additionalDataTextField.delegate = self
        
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Disable the textfields until in Edit Mode
        
        firstNameTextField.isEnabled = false
        LastNameTextField.isEnabled = false
        additionalDataTextField.isEnabled = false
        
        // Display the profile data of the logged in user
        
        let result:String = UserDefaults.standard.value(forKey: "LoginMethod") as! String
        
        if(result == "Google")
        {
            firstNameTextField.text = UserDefaults.standard.value(forKey: "FirstName") as? String
            LastNameTextField.text = UserDefaults.standard.value(forKey: "LastName") as? String
            additionalDataTextField.text = UserDefaults.standard.value(forKey: "FullName") as? String
        }
        else{
        let defaults = UserDefaults.standard
        if let user:NSDictionary = defaults.object(forKey: "lrUserProfile") as? NSDictionary {
            print(user)
            firstNameTextField.text = user.object(forKey: "FirstName")! as? String
            LastNameTextField.text = user.object(forKey: "LastName")! as? String
            additionalDataTextField.text = user.object(forKey: "FullName")! as? String
        }
        }

    }
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    /**
     * Called when logout button is pressed.
     */

    @IBAction func logoutAction(_ sender: Any) {
        
        let result:String = UserDefaults.standard.value(forKey: "LoginMethod") as! String
        
        if(result == "Google")
        {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        GIDSignIn.sharedInstance().signOut()
        }
        else{
            LoginRadiusSDK.logout()
        }
        self.navigationController?.popViewController(animated: false)
        
    }
    
    /**
     * Called when edit button is pressed.
     */
    
    @IBAction func editAction(_ sender: Any) {
        
        if editButton.titleLabel?.text == "Edit" {
            
        firstNameTextField.isEnabled = true
        firstNameTextField.clearButtonMode = .always
        LastNameTextField.isEnabled = true
        LastNameTextField.clearButtonMode = .always
        additionalDataTextField.isEnabled = true
        additionalDataTextField.clearButtonMode = .always
        editButton.setTitle("Save",for: .normal)
            
        }
        else{
            if (firstNameTextField.text == "") || (LastNameTextField.text == "") || (additionalDataTextField.text == ""){
                 alert(message: "Textfields cannot be blank.")
            }
            else
            {
                firstNameTextField.isEnabled = false
                firstNameTextField.clearButtonMode = .whileEditing
                LastNameTextField.isEnabled = false
                LastNameTextField.clearButtonMode = .whileEditing
                additionalDataTextField.isEnabled = false
                additionalDataTextField.clearButtonMode = .whileEditing
                editButton.setTitle("Edit",for: .normal)
                
                print(firstNameTextField.text!)
                print(LastNameTextField.text!)
                print(additionalDataTextField.text!)
               
            }
            
        }
        
    }
    
}

/**
 * Alert Extension for UIViewController
 */
extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
