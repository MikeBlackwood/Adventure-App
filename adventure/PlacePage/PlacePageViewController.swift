//
//  PlacePageViewController.swift
//  adventure
//
//  Created by Mike Budei on 8/6/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit
import CoreData

class PlacePageViewController: UIViewController {

    private var country: Country?
    private var arcticles: [Article] = []
    private var managedObjectContext: NSManagedObjectContext?

    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var postCollectionView: PostCollectionView!

    @IBAction func addArticleVC(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              guard let controller = storyBoard.instantiateViewController(withIdentifier: String(describing: AddPostViewController.self) ) as? AddPostViewController else {return}
        controller.setupController(context: managedObjectContext, country: country)
              show(controller, sender: self )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionViewData()
        setupViewController()
        setupCollectionView()
        setupDataObservers()
    }
}
// MARK: - Setup Controller
extension PlacePageViewController {
    private func setupViewController () {
        guard let img  = country!.thumbnail as Data? else { return}
        placeTitle.text = country?.title
        subtitle.text = country?.subtitle
        thumbnail.image = UIImage(data: img)
    }

    private func setupCollectionView() {
        guard let place = country,
            let posts = place.posts?.compactMap({ $0 as? Article}) else {
                return
        }
        postCollectionView.collectionViewDelegate = self
        postCollectionView.reviceData(posts: posts)
    }
}

// MARK: - Data from place
extension PlacePageViewController {
    func setupController( country: Country, context: NSManagedObjectContext? ) {
        self.country = country
        managedObjectContext = context
    }
}

// MARK: - Observer for aricle updates
extension PlacePageViewController {

        private func setupDataObservers() {
               guard let context = managedObjectContext else { return }
               let center = NotificationCenter.default
               center.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
           }

           @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
               guard let userInfo = notification.userInfo else { return }

               if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
                   let insertedItems = inserts.filter({ $0 is Article }).map({ $0 }) as? [Article],
                   !insertedItems.isEmpty {
                   updateCollectionViewData()
               }

               if let updatedSet = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
                   let updatedItems = updatedSet.filter({ $0 is Article }).map({ $0 }) as? [Article],
                   !updatedItems.isEmpty {
                   updateCollectionViewData()
               }

               if let deletedSet = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
                   let deletedItems = deletedSet.filter({ $0 is Article }).map({ $0 }) as? [Article],
                   !deletedItems.isEmpty {
                   updateCollectionViewData()
               }
           }

    private func updateCollectionViewData() {
        guard let context = managedObjectContext, let country = country else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Article.country), country)

        do {
            let result = try context.fetch(request)
            let articles = result.compactMap({ $0 as? Article })
            arcticles = articles
            postCollectionView.reloadData(articles: articles)
        } catch {

        }
    }
}
    // MARK: - PostDelegateProtocol
    extension PlacePageViewController: PostDelegateProtocol {
        func sendData(post: Article) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyBoard.instantiateViewController(withIdentifier: String(describing: ArticleViewController.self)) as? ArticleViewController else {return}
            controller.reciveData(data: post)
            show(controller, sender: self)
        }
    }

    // MARK: - TypeToStringProtocol
    extension PlacePageViewController: TypeToStringProtocol {
}
