//
//  ArticleTableViewCell.swift
//  ArticleView
//
//  Created by Nandini Mane on 01/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblUserName:UILabel!
    @IBOutlet weak var lblUserDesignation:UILabel!
    @IBOutlet weak var lblTimeAgo:UILabel!
    @IBOutlet weak var imgViewUser:UIImageView!
    @IBOutlet weak var imgViewArticle:UIImageView!
    @IBOutlet weak var lblArticleContent:UILabel!
    @IBOutlet weak var txtViewArticle:UITextView!
    @IBOutlet weak var lblLikesCount:UILabel!
    @IBOutlet weak var lblCommentCount:UILabel!
    @IBOutlet weak var heightConstarintForArticleImageView:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgViewUser.layer.cornerRadius = self.imgViewUser.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(article:Article) {
        // Set User details
        if let userList = article.user, userList.count != 0 {
            let user = userList[0]
            self.lblUserName.text = (user.name ?? "") + " " + (user.lastname ?? "")
            self.lblUserDesignation.text = user.designation ?? ""
            self.imgViewUser.downloaded(from: user.avatar ?? "")
        }
        
        // Set Article Image
        if let mediaList = article.media, mediaList.count != 0 {
            let media = mediaList[0]
            if let url = media.image, url.count != 0 {
                self.heightConstarintForArticleImageView.constant = 200
                self.imgViewArticle.downloaded(from: url)
            }else {
                self.heightConstarintForArticleImageView.constant = 0
            }
            // Set Article Description
            var content = (article.content ?? "") + "\n\n"
            content = content + (media.title ?? "") + "\n\n"
            content = content + (media.url ?? "")
            self.txtViewArticle.text = content
        }else {
            // Set Article Description
            self.heightConstarintForArticleImageView.constant = 0
            self.txtViewArticle.text = article.content ?? ""
        }
        self.txtViewArticle.sizeToFit()
        
        // Set Likes and Comments
        self.lblLikesCount.text = ProjectUtils.formatNumber(article.likes ?? 0) + " Likes"
        self.lblCommentCount.text = ProjectUtils.formatNumber(article.comments ?? 0) + " Comments"
        
        // Set time when article is posted
        let date = ProjectUtils.stringToDate(dateInStr: article.createdAt ?? "")
        let timeAgo = date?.timeAgoSinceDate()
        self.lblTimeAgo.text = timeAgo
    }
    
}
