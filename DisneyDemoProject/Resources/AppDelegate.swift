//
//  AppDelegate.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let container = DIContainer.shared
        let apiDataFetcher = APIDataFetcher()
        container.register(type: DataFetchable.self, component: apiDataFetcher)
        
        let cache = Cache()
        container.register(type: Cacheable.self, component: cache)
        
        let coreDataStack = CoreDataStack()
        container.register(type: ContextSavable.self, component: coreDataStack)
        
        let persistance = CDPersistence(persistentContainer: coreDataStack.persistentContainer)
        container.register(type: CDPersistence.self, component: persistance)
        
        let disneyCDPersistence = DisneyCDPersistence(persistence: container.resolve(type: CDPersistence.self), coreDataStack: container.resolve(type: ContextSavable.self))
        container.register(type: DisneyCDPersistence.self, component: disneyCDPersistence)
        
        let charactersRepository = CharactersRepository(apiDataFetcher: container.resolve(type: DataFetchable.self), cache: container.resolve(type: Cacheable.self), persistance: container.resolve(type: DisneyCDPersistence.self))
        container.register(type: CharactersRepositoryable.self, component: charactersRepository)
    
        return true
    }
}

