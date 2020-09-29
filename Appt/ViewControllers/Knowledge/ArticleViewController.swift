//
//  ArticleViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import Accessibility
import UIKit
import WebKit
import SafariServices

class ArticleViewController: WebViewController {
    
    @IBOutlet private var shareItem: UIBarButtonItem!
    
    var type: ArticleType!
    var id: Int?
    var slug: String?
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareItem.isEnabled = false
        shareItem.title = "article_share".localized
        
        getArticle()
    }
    
    private func getArticle() {
        isLoading = true
        
        let callback = { (response: Response<Article>) in
            if let article = response.result {
                self.article = article
                guard let content = article.content?.rendered else {
                    return
                }
                self.load(content, title: article.title.rendered)
            } else if let error = response.error {
                self.isLoading = false
                self.showError(error)
            }
        }
        
        if let id = id {
            API.shared.getArticle(type: type, id: id, callback: callback)
        } else if let slug = slug {
            API.shared.getArticle(type: type, slug: slug, callback: callback)
        }
    }
    
    override func onLoaded() {
        shareItem.isEnabled = true
        Accessibility.announce("Het artikel is geladen")
    }
    
    @IBAction private func onShareTapped(_ sender: Any) {
        guard let link = article?.link, let url = URL(string: link) else {
            return
        }
        let shareViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
        shareViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(shareViewController, animated: true)
    }
}
