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

    private var places: [Country] = []
    var didSelectedItem:((_ atIndex: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func reloadData(countries: [Country]) {
        places = countries
        reloadData()
    }
}

extension PlacesCollectionView {

    private func setupCollectionView() {
        delegate = self
        dataSource = self
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

//MARk: - UICollectionViewDataSource
extension PlacesCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlacesCollectionViewCell", for: indexPath) as? PlacesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 15
        cell.mainTitle.text = places[indexPath.row].title
        cell.subtitle.text = places[indexPath.row].subtitle
        let img = UIImage(data: places[indexPath.row].thumbnail! as Data)
        cell.placeImg.image = img
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlacesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let didSelectedItem = didSelectedItem else { return }
        didSelectedItem(indexPath.row)
    }
}
