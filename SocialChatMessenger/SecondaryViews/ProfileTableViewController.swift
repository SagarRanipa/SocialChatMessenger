//
//  ProfileTableViewController.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-26.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //MARK: - IBoutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Vars
    var user: User?
    
    //MARK: - viewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        setupUI()
    }
    
    //MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            // Go to chat room
            
            let chatId = startChat(user1: User.currentUser!, user2: user!)
            
            let privateChatView = ChatViewController(chatId: chatId, recipientId: user!.id, recipientName: user!.username)
            
            privateChatView.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(privateChatView, animated: true)

        }

    }

    
    //MARK: - SetupUI
    
    private func setupUI() {
        
        if user != nil {
            self.title = user!.username
            usernameLabel.text = user!.username
            statusLabel.text = user!.status
            
            if user!.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { (avatarImage) in

                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
}
