//
//  DataManager.swift
//  Cartoon
//
//  Created by BCL Device-18 on 12/3/24.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private var datasource: Dictionary = Dictionary<String, Any>()
    
    func prepareData() {
        if let plistPath = Bundle.main.path(forResource: "Datasource", ofType: "plist") {
            // Read datasource data
            if let plistData = FileManager.default.contents(atPath: plistPath) {
                do {
                    // Deserialize datasource data
                    if let datasource = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] {
                        self.datasource = datasource
                    } else {
                        print("Failed to deserialize datasource data.")
                    }
                } catch {
                    print("Error reading datasource data: \(error)")
                }
            } else {
                print("Failed to load datasource data.")
            }
        } else {
            print("datasource file not found.")
        }
    }
    
    func getRootDataCount() -> Int? {
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]] else { return nil }
        return rootValue.count
    }
    
    func getSectionData(of section: Int) -> SectionData? {
        guard let rootValue = self.datasource["Home Category"] as? [[String: Any]],
              let sectionData = self.parseDictionaryToSectionData(dictionary: rootValue[section])
        else { return nil }
        return sectionData
    }
    
    func parseDictionaryToSectionData(dictionary: [String: Any]) -> SectionData? {
        guard let sectionTypeString = dictionary["sectionType"] as? String,
              let sectionType = SectionType(rawValue: sectionTypeString),
              let numberOfItemsInt = dictionary["numberOfItems"] as? Int,
              let numberOfItems = NumberOfItems(rawValue: numberOfItemsInt),
              let headerTitle = dictionary["headerTitle"] as? String,
              let shouldShowMore = dictionary["shouldShowMore"] as? Bool,
              let itemsArray = dictionary["items"] as? [[String: Any]]
        else { return nil }

        // Parse items
        var items: [Item] = []
        for itemDict in itemsArray {
            guard let text = itemDict["text"] as? String,
                  let image = itemDict["image"] as? String,
                  let description = itemDict["description"] as? String,
                  let isPro = itemDict["isPro"] as? Bool
            else { return nil }

            let item = Item(text: text, image: image, description: description, isPro: isPro)
            items.append(item)
        }

        let sectionData = SectionData(sectionType: sectionType, numberOfItems: numberOfItems, headerTitle: headerTitle, shouldShowMore: shouldShowMore, items: items)
        return sectionData
    }
}
