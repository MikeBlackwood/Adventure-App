//
//  DataInjection.swift
//  adventure
//
//  Created by Mike Budei on 8/24/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//

import Foundation
import CoreData

protocol PlacesDelegateProtocol: NSObject {
    func sendPlace(data: Country )

}

protocol PostDelegateProtocol: NSObject {
    func sendData(post: Article)
}
