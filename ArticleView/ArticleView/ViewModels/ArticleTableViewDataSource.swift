//
//  ArticleTableViewDataSource.swift
//  ArticleView
//
//  Created by Nandini Mane on 01/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

class ArticleTableViewDataSource: NSObject, UITableViewDataSource {

    private var cellIdentifier : String!
    private var articles:Articles!
    
    
    init(cellId : String, articles : Articles) {
        self.cellIdentifier = cellId
        self.articles =  articles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ArticleTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ArticleTableViewCell
        let item = self.articles[indexPath.row]
        cell.configureCell(article: item)
        return cell
    }    
    
}
