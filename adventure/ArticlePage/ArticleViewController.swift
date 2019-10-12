//
//  ArticleViewController.swift
//  adventure
//
//  Created by Mike Budei on 8/10/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    private var post: Article?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
}

extension ArticleViewController {
    func reciveData(data: Article?) {
        post = data
    }
}

extension ArticleViewController {

    func setupController() {

        guard let post = self.post else {
            setDefaultState()
            return
        }

        titleLabel.text = post.title
        setupDescription(text: post.post)

    }

    private func setupDescription(text: String?) {
        guard let description = text else { fatalError() }
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 14
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraph]
        let attributedString = NSAttributedString(string: description, attributes: attributes)
        descriptionLabel.attributedText = attributedString
    }

    private func setDefaultState() {
        fatalError()
    }
}
