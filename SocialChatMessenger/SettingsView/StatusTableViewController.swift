//
//  StatusTableViewController.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-25.
//

import UIKit

class StatusTableViewController: UITableViewController {
    
    //MARK: - vars
    
    var allStatus: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        loadUserStatus()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStatus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let status = allStatus[indexPath.row]
        cell.textLabel?.text = status
        
        cell.accessoryType = User.currentUser?.status == status ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegates
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackroundColor")
        return headerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        updateCellCheck(indexPath)
        tableView.reloadData()
    }
    
    //MARK: - loading
    
    private func loadUserStatus() {
        allStatus = userDefaults.object(forKey: kSTATUS) as! [String]
        tableView.reloadData()
    }
    
    private func updateCellCheck(_ indexpath: IndexPath) {
        if var user = User.currentUser {
            user.status = allStatus[indexpath.row]
            saveUserLocally(user)
            FirebaseUserListener.shared.saveUserToFireStore(user)
        }
    }

}
