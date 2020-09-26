//
//  ArticleViewController.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 29/05/2020.
//  Copyright © 2020 Abra B.V. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ArticleViewController: WebViewController {
    
    var type: ArticleType!
    var id: Int?
    var slug: String?
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArticle()
    }
    
    private func getArticle() {
        isLoading = true
        
        let callback = { (article: Article?, error: Error?) in
            if let article = article {
                self.onArticle(article)
            } else if let error = error {
                self.onError(error)
            }
        }
        
        if let id = id {
            API.shared.getArticle(type: type, id: id, callback: callback)
        } else if let slug = slug {
            API.shared.getArticle(type: type, slug: slug, callback: callback)
        }
    }
    
    private func onArticle(_ article: Article) {
        self.article = article

        guard let content = article.content?.rendered else {
            return
        }
        
        load(content, title: article.title.rendered)
    }
    
    private func onError(_ error: Error) {
        print("onError", error)
        self.isLoading = false
    }
    
    @IBAction private func onShareTapped(_ sender: Any) {
        guard let link = article?.link else {
            return
        }
        
        let shareViewController = UIActivityViewController(activityItems: [link], applicationActivities: [])
        shareViewController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        present(shareViewController, animated: true)
    }
}
