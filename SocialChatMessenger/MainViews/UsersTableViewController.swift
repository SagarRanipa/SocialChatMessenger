//
//  UsersTableViewController.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-26.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: - vars
    var allUsers: [User] = []
    var filteredUsers: [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl

        tableView.tableFooterView = UIView()
        //createDummyUsers()
        setupSearchController()
        downloadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUsers.count : allUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        cell.configure(user: user)
        return cell
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
        // show profile View
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        
        showUserProfile(user)
    }
    
    //MARK: - downloadUsers
    
    private func downloadUsers() {
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { (allFirebaseUsers) in
            
            self.allUsers = allFirebaseUsers
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - setupSearchController
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    private func filteredContentForSearchText(searchText: String) {
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.username.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if self.refreshControl!.isRefreshing {
            self.downloadUsers()
            self.refreshControl!.endRefreshing()
        }
    }
    
    //MARK: - Navigation
    
    private func showUserProfile(_ user: User) {
        
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "profileView") as! ProfileTableViewController
        
        profileView.user = user
        self.navigationController?.pushViewController(profileView, animated: true)
    }

}

extension UsersTableViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}
