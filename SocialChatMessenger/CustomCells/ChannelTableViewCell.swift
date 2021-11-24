//
//  ChannelTableViewCell.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-09-08.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    //MARK: - IbOutlet
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(channel: Channel) {
        
        nameLabel.text = channel.name
        aboutLabel.text = channel.aboutChannel
        memberCountLabel.text = "\(channel.memberIds.count) members"
        lastMessageDateLabel.text = timeElapsed(channel.lastMessageDate ?? Date())
        lastMessageDateLabel.adjustsFontSizeToFitWidth = true
        setAvatar(avatarLink: channel.avatarLink)
    }
    
    private func setAvatar(avatarLink: String) {

        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { (avatarImage) in
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "avatar")
                }
            }
        } else {
            self.avatarImageView.image = UIImage(named: "avatar")
        }
    }


}
