//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Dominik Hofer on 19.08.22.
//

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    enum Predicate: String {
        case beginsWith = "BEGINSWITH"
        case contains = "CONTAINS"
    }
    
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }
    
    init(filterKey: String, filterValue: String, predicate: Predicate, sortDescriptor: SortDescriptor<T>, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "%K \(predicate.rawValue) %@", filterKey, filterValue))
        self.content = content
    }
}
