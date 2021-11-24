//
//  ViewController.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-17.
//

import UIKit
import ProgressHUD
class LoginViewController: UIViewController {
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var resendEmailButton: UIButton!
    
    @IBOutlet weak var repeatPasswordLineView: UIView!
    
    var isLogin: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIFor(login: true)
        setupBackgroundTap()
        loginButton.layer.cornerRadius = 20
        signUpButton.layer.cornerRadius = 20
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            isLogin ? loginuser() : registerUser()
        } else {
            ProgressHUD.showFailed("All Fields Are Required")
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        if isDataInputedFor(type: "password") {
            // reset password
            resetPassword()
        } else {
            ProgressHUD.showFailed("Email is Required")
        }
    }
    
    @IBAction func resendEmailPressed(_ sender: UIButton) {
        if isDataInputedFor(type: "password") {
            resendVerificationEmail()
            print("have data for resend email")
        } else {
            ProgressHUD.showFailed("Email is Required")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    //MARK: - setup
    
    private func setupBackgroundTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backGroundTap(){
        view.endEditing(false)
    }
    
    //MARK: - Animations
    
    private func updateUIFor(login: Bool) {
        loginButton.setTitle(login ? "Login" : "Register", for: .normal)
        signUpButton.setTitle(login ? "Signup" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an Account?" : "Have an Account?"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLineView.isHidden = login
        }
    }
    
    //MARK: - helpers
    
    private func isDataInputedFor(type: String) -> Bool {
        switch type {
        case "login":
             return emailTextField.text != "" && passwordTextField.text != ""
        case "registration":
        return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default :
            return emailTextField.text != ""
        }
    }
    
    private func registerUser() {
        if passwordTextField.text! == repeatPasswordTextField.text! {
            
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                
                if error == nil {
                    ProgressHUD.showSuccess("Verification Email sent.")
                    self.resendEmailButton.isHidden = false
                } else {
                    ProgressHUD.showFailed(error?.localizedDescription)
                }
            }
            
        }else {
            ProgressHUD.showFailed("Passwords Don't Match")
        }
    }
    
    private func loginuser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified {
                    self.goToApp()
                } else {
                    ProgressHUD.showFailed("Please verify Email")
                    self.resendEmailButton.isHidden = false
                }
            } else {
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("Reset Link Sent to email.")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { (error) in
            if error == nil {
                ProgressHUD.showSuccess("New Verification Email Sent")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
            
        }
    }
    
    //MARK: - Navigation
    
    private func goToApp() {
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
    
}

