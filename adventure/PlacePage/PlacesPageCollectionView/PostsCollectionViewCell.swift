//
//  PostsCollectionViewCell.swift
//  adventure
//
//  Created by Mike Budei on 8/10/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit

class PostsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postSubtitle: UILabel!
    @IBOutlet weak var post: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
