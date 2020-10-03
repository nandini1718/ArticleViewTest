//
//  ViewController.swift
//  ArticleView
//
//  Created by Nandini Mane on 01/10/20.
//  Copyright © 2020 Nandini Mane. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    
    private var currentPage:Int = 1
    private var articleViewModel : ArticleViewModel!
    
    private var dataSource : ArticleTableViewDataSource!
    private var delegate : ArticleTableViewDelegate!
    private var articlesList:Articles = Articles()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.articleTableView.reloadData()
        self.articleTableView.tableFooterView = UIView()
        self.articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier:"ArticleTableViewCell")
        self.articleViewModel =  ArticleViewModel()
        self.callAPIByViewModel()
    }

    // Bind view model to controller
    func callAPIByViewModel() {
        
        if self.currentPage == 1 {
            IndicatorUtil.shared.showActivityIndicator(view: self.view)
        }
        
        self.articleViewModel.callGetArticles(currentPage: self.currentPage)
        self.articleViewModel.bindViewModelToController = { articles in
            self.articlesList.append(contentsOf: articles)
            self.updateTableView()
        }
    }
    
    // Update table view once we received response
    func updateTableView() {
        if self.articlesList.count != 0 {
            self.dataSource = ArticleTableViewDataSource(cellId: "ArticleTableViewCell", articles:self.articlesList )
            if self.currentPage == 1 {
                self.delegate = ArticleTableViewDelegate(cellId: "ArticleTableViewCell", articles:self.articlesList)
            }else {
                self.delegate.isMoreDataPresent = self.articleViewModel.isMoreDataPresent
                self.delegate.articles = self.articlesList
                
            }
            
            // Update table view on main thread
            DispatchQueue.main.async {
                self.articleTableView.delegate = self.delegate
                self.articleTableView.dataSource = self.dataSource
                self.articleTableView.reloadData()
                self.delegate.isLoading = false
            }
            
            DispatchQueue.main.async {
                IndicatorUtil.shared.hideActivityIndicator()
            }
            
            // Call Load more Functionality
            self.delegate.loadMore = {
                DispatchQueue.global().async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.currentPage += 1
                         self.callAPIByViewModel()
                    })
                }
            }
            
            // Display alert for no more data present
            self.delegate.noMoreData = {
                ProjectUtils.showAlertTitleAndOkButton(withTitle: "", withMessage: "No more data available.", okButtonTitle: "Ok", action: {}, onController: self)
            }
        }else {
            DispatchQueue.main.async {
                IndicatorUtil.shared.hideActivityIndicator()
            }
        }
    }
}

