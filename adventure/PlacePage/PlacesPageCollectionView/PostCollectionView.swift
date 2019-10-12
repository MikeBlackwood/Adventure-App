//
//  PostsCollectionView.swift
//  adventure
//
//  Created by Mike Budei on 8/10/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit

class PostCollectionView: UICollectionView {

    private var posts: [Article?] = []
    var data: Country!
    weak var collectionViewDelegate: PostDelegateProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        registerNib()
        setupLayout()
    }
}

extension PostCollectionView {
    private func setupLayout() {
        guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        collectionViewLayout.collectionView?.backgroundView?.backgroundColor = .none
        collectionViewLayout.itemSize = CGSize(width: frame.size.width - 10, height: frame.size.height / 1.3 )
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
    }

    private func registerNib() {
        let nib = UINib(nibName: String(describing: "PostCollectionViewCell"), bundle: Bundle.main)
         register(nib, forCellWithReuseIdentifier: "PostCollectionViewCell")
    }
}

extension PostCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts.isEmpty {
            return 1
        }
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as? PostCollectionViewCell else {return UICollectionViewCell() }
        cell.layer.cornerRadius = 15
        if posts.isEmpty {
            cell.title.text = "Please add Articles "
            cell.post.text = "You can create anything you want"
        } else {
        cell.title.text = posts[indexPath.row]?.title
        cell.subtitle.text = posts[indexPath.row]?.subtitle
        cell.post.text = posts[indexPath.row]?.post
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if posts.isEmpty {
            return
        } else {
        collectionViewDelegate?.sendData(post: posts[indexPath.row]! )
        }
        }
}
extension PostCollectionView {
    func reviceData(posts: [Article] ) {
        self.posts = posts
    }

}
