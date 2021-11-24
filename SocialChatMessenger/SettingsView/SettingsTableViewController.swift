//
//  SettingsTableViewController.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-23.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var appVersionLabel: UILabel!
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = 20
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "settingsToEditProfileSeg", sender: self)
        }
    }
    
    //MARK: - IBActions
  
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        FirebaseUserListener.shared.logOutCurrentUser { (error) in
            if error == nil {
                
                let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
                
                DispatchQueue.main.async {
                    loginView.modalPresentationStyle = .fullScreen
                    self.present(loginView, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - UpdateUI
    
    private func showUserInfo() {
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appVersionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            
            if user.avatarLink != "" {
                //download and set avatar image
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
}
