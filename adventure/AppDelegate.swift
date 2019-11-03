//
//  AppDelegate.swift
//  adventure
//
//  Created by Mike Budei on 8/3/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DetourDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard error == nil else {
                print(error!)
                return
            }
        })
        return container
    }()

    func saveContext() {
        let context  = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Erorr \(error) has occured. \(error.userInfo)")
            }
        }
    }

    func preloadData() {
        let context = persistentContainer.viewContext

        let faroeIslands = Country(context: context)
        let faroeIslandsPost = Article(context: context)
        faroeIslands.addToPosts(faroeIslandsPost)
        faroeIslands.title = "Faroe Islands"
        faroeIslands.subtitle = "Lost paradise"
        faroeIslands.id = UUID().description
        faroeIslands.date = NSDate().addingTimeInterval(240) as Date
        let faroeImage = UIImage(named: "faroeislands")
        faroeIslands.thumbnail = faroeImage!.pngData() as NSData? as Data?
        faroeIslandsPost.country = faroeIslands
        faroeIslandsPost.post = "Múlafossur is a watarfall like no other. A nice walk from the village houses in Gásadalur you'll find this famous waterfall. Múlafossur is situated on Vagar island some 11 km (7 miles) from Vagar Airport. Just before getting to the waterfall, you will drive through the Gásadalstunnilin tunnel.There is a parking lot near the waterfall. From this parking lot, you will walk for 2 minutes in order to reach the breathtakingly beautiful waterfall that drops into the ocean. The waterfall is over 30 meters (100 feet) high."
        faroeIslandsPost.title = "Monufossur"
        faroeIslandsPost.subtitle = "Waterfall to remember"
        faroeIslandsPost.date = NSDate().addingTimeInterval(160) as Date
        let australia = Country(context: context)
        australia.subtitle = "New Year comes in Summer"
        australia.title = "Australia"
        australia.date = NSDate().addingTimeInterval(210) as Date
        let australiaImg = UIImage(named: "australia")
        australia.thumbnail = australiaImg?.pngData() as NSData? as Data?
        australia.id = UUID().description
        let beach = Article(context: context)
        beach.title = "Cairns"
        beach.subtitle = "Somewhere in the rainforest"
        beach.post = "Although Cairns itself is quite an unattractive place, the rainforests that surround it and the beautiful turquoise waters that lap against its beaches more than make up for the lack of sights in the city. A popular tourist destination, the city is considered to be the gateway to the Great Barrier Reef; this is the primary reason why Cairns is so inundated with tourists. Away from the reef, there are loads of amazing natural sights nearby, and lots of people stop by Cairns on their way to visit Daintree National Park or the Wet Tropics of Queensland. The fourth most popular city to visit in Australia, Cairns has enough good bars, restaurants and shopping options to keep visitors entertained before they head off into the stunning nature nearby. "
        beach.country = australia
        beach.date = NSDate().addingTimeInterval(120) as Date
        saveContext()
    }

    func deleteData() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        let deleteRequest = NSBatchDeleteRequest( fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            let error = error as NSError
            print(error)
        }

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        deleteData()
//        preloadData()
        if let navController = window?.rootViewController,
            let controller = navController.children.first(where: { $0 is AdventureMainViewController }) as? AdventureMainViewController {
            controller.managedObjectContext = persistentContainer.viewContext
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
