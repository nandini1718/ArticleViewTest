//
//  ArticleTableViewDelegate.swift
//  ArticleView
//
//  Created by Nandini Mane on 02/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

class ArticleTableViewDelegate: NSObject, UITableViewDelegate {
    
    private var cellIdentifier : String!
    var isLoading:Bool = false
    var articles:Articles!
    var isMoreDataPresent:Bool = true
    var loadMore : (() -> ()) = {}
    var noMoreData:(() -> ()) = {}
    
    init(cellId : String, articles : Articles) {
        self.cellIdentifier = cellId
        self.articles =  articles
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            if !self.isMoreDataPresent {
                tableView.tableFooterView = nil
                self.noMoreData()
                return
            }
           let spinner = UIActivityIndicatorView(style: .gray)
           spinner.startAnimating()
           spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

           tableView.tableFooterView = spinner
           tableView.tableFooterView?.isHidden = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if self.articles.count != 0 {
            if (offsetY > contentHeight - scrollView.frame.height) && !self.isLoading  {
                self.loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                self.loadMore()
            }
        }
    }
    
}
