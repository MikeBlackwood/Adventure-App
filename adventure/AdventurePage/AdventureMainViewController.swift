//
//  ViewController.swift
//  adventure
//
//  Created by Mike Budei on 8/3/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit
import CoreData

protocol AdventureVCListener: NSObject {
    func didAddItem()
}

class AdventureMainViewController: UIViewController {

    private enum Section: CaseIterable { case main }
    @IBOutlet weak var placesCollectionView: PlacesCollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    weak var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        configueCollectionView()
        setupDataSource()
        registerNotifications()
        updateCollectionViewData(filter: nil)
    }

    deinit {
        unregisterNotifications()
    }
}

// MARK: - Notifications
extension AdventureMainViewController {
    private func registerNotifications() {
        guard let context = managedObjectContext else { return }
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange),
                           name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }

    private func unregisterNotifications() {
        guard let context = managedObjectContext else { return }
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
}

// MARK: - Collection View Configuration
extension AdventureMainViewController {

    private func configueCollectionView() {
        guard let collectionView = placesCollectionView else { return }
        collectionView.didSelectedItem = { [weak self] index in
            guard let weakSelf = self else { return }
            weakSelf.loadDetailsForItem(indexPath: index)
        }
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: placesCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, country: Country) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlacesCollectionViewCell", for: indexPath) as? PlacesCollectionViewCell else {
                fatalError("Cannot create new cell")
            }
            cell.layer.cornerRadius = 15
            cell.mainTitle.text = country.title
            cell.subtitle.text = country.subtitle
            let img = UIImage(data: country.thumbnail! as Data)
            cell.placeImg.image = img
            return cell
        }
    }
}

// MARK: - Setup Data
extension AdventureMainViewController {

    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            let insertedItems = inserts.filter({ $0 is Country }).map({ $0 }) as? [Country],
            !insertedItems.isEmpty {
            updateCollectionViewData(filter: nil)
        }

        if let updatedSet = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            let updatedItems = updatedSet.filter({ $0 is Country }).map({ $0 }) as? [Country],
            !updatedItems.isEmpty {
            updateCollectionViewData(filter: nil)
        }

        if let deletedSet = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            let deletedItems = deletedSet.filter({ $0 is Country }).map({ $0 }) as? [Country],
            !deletedItems.isEmpty {
            updateCollectionViewData(filter: nil)
        }
    }

    private func updateCollectionViewData(filter: String?) {
        guard let context = managedObjectContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        if let filter = filter, !filter.isEmpty {
            let predicate = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Country.title), filter)
            request.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "TRUEPREDICATE")
            request.predicate = predicate
        }

        do {
            let result = try context.fetch(request)
            let countries = result.compactMap({ $0 as? Country })
            var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
            snapshot.appendSections([.main])
            snapshot.appendItems(countries)
            dataSource.apply(snapshot, animatingDifferences: true)
        } catch {
            assertionFailure("Core data fetch failed")
        }
    }
}

extension AdventureMainViewController: PlacesDelegateProtocol {
    func sendPlace(data: Country) {

    }
}

extension AdventureMainViewController {
    private func loadDetailsForItem(indexPath: IndexPath) {

        if let country = dataSource.itemIdentifier(for: indexPath) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyBoard.instantiateViewController(withIdentifier: String(describing: PlacePageViewController.self) ) as? PlacePageViewController else {return}
            controller.setupController(country: country, context: managedObjectContext)
            show(controller, sender: self )
        }

    }
}

extension AdventureMainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextDidChange(searchText: searchText)
    }
}

extension AdventureMainViewController {
    private func searchTextDidChange(searchText: String) {
        updateCollectionViewData(filter: searchText)
    }
}
