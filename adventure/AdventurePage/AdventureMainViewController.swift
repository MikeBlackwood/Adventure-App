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
    @IBOutlet weak var placeSearchBar: UISearchBar!
    @IBOutlet weak var placesCollectionView: PlacesCollectionView!
    
    weak var managedObjectContext: NSManagedObjectContext?
    private var countries: [Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configueCollectionView()
        setupDataObservers()
        updateCollectionViewData()
    }
}

// MARK: - Collection View Configuration
extension AdventureMainViewController {
    private func configueCollectionView() {
        guard let collectionView = placesCollectionView else { return }
        collectionView.didSelectedItem = { [weak self] index in
            guard let weakSelf = self else { return }
            weakSelf.loadDetailsForItem(atIndex: index)
        }
    }
}

// MARK: - Setup Data
extension AdventureMainViewController {

    private func setupDataObservers() {
        guard let context = managedObjectContext else { return }
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }

    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
            let insertedItems = inserts.filter({ $0 is Country }).map({ $0 }) as? [Country],
            !insertedItems.isEmpty {
            updateCollectionViewData()
        }

        if let updatedSet = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
            let updatedItems = updatedSet.filter({ $0 is Country }).map({ $0 }) as? [Country],
            !updatedItems.isEmpty {
            updateCollectionViewData()
        }

        if let deletedSet = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
            let deletedItems = deletedSet.filter({ $0 is Country }).map({ $0 }) as? [Country],
            !deletedItems.isEmpty {
            updateCollectionViewData()
        }
    }

    private func updateCollectionViewData() {
        guard let context = managedObjectContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let result = try context.fetch(request)
            let countries = result.compactMap({ $0 as? Country })
            self.countries = countries
            placesCollectionView.reloadData(countries: countries)
        } catch {
            print("Failed")
        }
    }
}

extension AdventureMainViewController: PlacesDelegateProtocol {
    func sendPlace(data: Country) {

    }
}

extension AdventureMainViewController {
    private func loadDetailsForItem(atIndex index: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyBoard.instantiateViewController(withIdentifier: String(describing: PlacePageViewController.self) ) as? PlacePageViewController else {return}
        controller.setupController(country: countries[index], context: managedObjectContext)
        show(controller, sender: self )

    }
}

extension AdventureMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        guard let query = searchBar.text else {
        //            return
        //        }
        //        let request = Country.fetchRequest() as NSFetchRequest<Country>
        //        request.predicate = NSPredicate(format: "name CONTAINS %@", query)
        //        do  {
        //             places =  try context.fetch(request)
        //        } catch let error as NSError {
        //            print("Erorr - \(error.description)")
        //        }
        //        searchBar.resignFirstResponder()
        //        placesCollectionView.reloadData()
    }
}
