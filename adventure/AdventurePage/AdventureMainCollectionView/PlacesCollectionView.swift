//
//  PlacesCollectionView.swift
//  adventure
//
//  Created by Mike Budei on 8/3/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit
import CoreData

class PlacesCollectionView: UICollectionView {

    var didSelectedItem:((_ indexPath: IndexPath) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
}

extension PlacesCollectionView {

    private func setupCollectionView() {
        delegate = self
        setupLayout()
        registerCell()

    }

    private func setupLayout() {
        guard  let placesCollectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else {return}
        placesCollectionViewLayout.collectionView?.backgroundView?.backgroundColor = .none
        placesCollectionViewLayout.itemSize = CGSize(width: frame.size.width, height: frame.size.height / 3)
        placesCollectionViewLayout.scrollDirection = .vertical
        placesCollectionViewLayout.collectionView?.showsVerticalScrollIndicator = false
    }

    private func registerCell() {
        let nib = UINib(nibName: String(describing: "PlacesCollectionViewCell"), bundle: Bundle.main)
        register(nib, forCellWithReuseIdentifier: "PlacesCollectionViewCell")
    }
}

// MARK: - UICollectionViewDelegate
extension PlacesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let didSelectedItem = didSelectedItem else { return }
        didSelectedItem(indexPath)
    }
}
