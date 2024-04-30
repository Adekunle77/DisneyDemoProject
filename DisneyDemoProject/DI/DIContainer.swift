//
//  DIContainer.swift
//  DisneyDemoProject
//
//  Created by Ade Adegoke on 26/04/2024.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    var components: [String: Any] = [:]
    
    init() {}
    
    func register<Service>(type: Service.Type, component: Any) {
        components["\(type)"] = component
    }
    
    func resolve<Service>(type: Service.Type) -> Service {
        components["\(type)"] as! Service
    }

}
