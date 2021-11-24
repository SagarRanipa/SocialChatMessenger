//
//  EditProfileTableViewController.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-23.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: - vars
    var gallery: GalleryController!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        configureTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableViewBackgroundColor")
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // show status view
        
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileToStatusSeg", sender: self)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        showImageGallery()
    }
    
    //MARK: - updateUI
    
    private func showUserInfo() {
        if let user = User.currentUser {
            usernameTextField.text = user.username
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user.avatarLink) { (avatarImage) in
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }
    
    //MARK: - configure
    
    private func configureTextField() {
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
    
    //MARK: - Gallery
    private func showImageGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        self.present(gallery, animated: true, completion: nil)
    }
    
    //MARK: - upload
    
    private func uploadAvatarImage(_ image: UIImage) {
        let fileDirectory = "Avatars/" + "_\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { (avatarLink) in
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFireStore(user)
            }
            
            // save Image Locally
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentId)
        }
    }
}

extension EditProfileTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if textField.text != "" {
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFireStore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EditProfileTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first!.resolve { (avatarImage) in
                
                if avatarImage != nil {
                    //upload image
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageView.image = avatarImage?.circleMasked
                } else {
                    ProgressHUD.showError("Could not Select Image")
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)

    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
