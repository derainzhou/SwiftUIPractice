//
//  IntentHandler.swift
//  CS193Intent
//
//  Created by DerainZhou on 2023/7/21.
//

import Intents
import WidgetKit

class IntentHandler: INExtension {
    typealias ConfigurationTuple = [(title: String, items: [CS193pUserConfiguration])]
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    // MARK: - Private Method
    private func intentDataConfig(for widgetFamily: WidgetFamily) async -> INObjectCollection<CS193pUserConfiguration> {
        // 从AppGroup中获取用户保存的小组件Intents
        /*
        let intents = PPLSDB.shared.getAllIntents(with: widgetFamily.rawValue)
        let groupIntents = Dictionary(grouping: intents) { $0.category }
        
        let categorySections: ConfigurationTuple = PPLSWidgetCategory.allCases.compactMap { category in
            guard let categoryIntents = groupIntents[category.rawValue] else { return nil }
            let userConfigs = categoryIntents.map { POPUserConfiguration(intent: $0) }
            return (category.categoryTitle, userConfigs)
        }
        
        let sections = categorySections.map { INObjectSection(title: $0.title, items: $0.items) }
        return INObjectCollection(sections: sections)
         */
        // 假数据, 防止编译报错
        return INObjectCollection(sections: [INObjectSection(title: "Mock Data", items: [])])
    }
}

// MARK: - SmallWidgetConfigurationIntentHandling
extension IntentHandler: SmallWidgetConfigurationIntentHandling{
    func provideUserCustomConfigurationOptionsCollection(for intent: SmallWidgetConfigurationIntent, searchTerm: String?) async throws -> INObjectCollection<CS193pUserConfiguration> {
        return await intentDataConfig(for: .systemSmall)
    }
}

// MARK: - MiddleWidgetConfigurationIntentHandling
extension IntentHandler: MiddleWidgetConfigurationIntentHandling {
    func provideUserCustomConfigurationOptionsCollection(for intent: MiddleWidgetConfigurationIntent, searchTerm: String?) async throws -> INObjectCollection<CS193pUserConfiguration> {
        return await intentDataConfig(for: .systemMedium)
    }
}

// MARK: - LargeWidgetConfigurationIntentHandling
extension IntentHandler: LargeWidgetConfigurationIntentHandling {
    func provideUserCustomConfigurationOptionsCollection(for intent: LargeWidgetConfigurationIntent, searchTerm: String?) async throws -> INObjectCollection<CS193pUserConfiguration> {
        return await intentDataConfig(for: .systemLarge)
    }
}


