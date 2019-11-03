//
//  PostCollectionViewCell.swift
//  adventure
//
//  Created by Mike Budei on 8/10/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

}

extension PostCollectionViewCell {
    private func setupCell() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
    }
}
