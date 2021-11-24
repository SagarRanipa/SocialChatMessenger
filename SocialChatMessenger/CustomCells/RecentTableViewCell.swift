//
//  RecentTableViewCell.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-26.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadCounterLabel: UILabel!
    @IBOutlet weak var unreadCounterBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unreadCounterBackgroundView.layer.cornerRadius = unreadCounterBackgroundView.frame.width / 2


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(recent: RecentChat) {
        usernameLabel.text = recent.receiverName
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.9
        
        lastMessageLabel.text = recent.lastMessage
        lastMessageLabel.adjustsFontSizeToFitWidth = true
        lastMessageLabel.numberOfLines = 2
        lastMessageLabel.minimumScaleFactor = 0.9
        
        if recent.unreadCounter != 0 {
            unreadCounterLabel.text = "\(recent.unreadCounter)"
            self.unreadCounterBackgroundView.isHidden = false
        } else {
            self.unreadCounterBackgroundView.isHidden = true
        }
        setAvatar(avatarLink: recent.avatarLink)

        dateLabel.text = timeElapsed(recent.date ?? Date())
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setAvatar(avatarLink: String) {
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
                self.avatarImageView.image = avatarImage?.circleMasked
            }
        } else {
            self.avatarImageView.image = UIImage(named: "avatar")
        }
    }

}
