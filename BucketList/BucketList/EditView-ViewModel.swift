//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Dominik Hofer on 06.09.22.
//

import Foundation

extension EditView {
    @MainActor class ViewModel: ObservableObject {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        @Published private(set) var location: Location
        
        @Published var name: String
        @Published var description: String
        
        @Published private(set) var loadingState = LoadingState.loading
        @Published private(set) var pages = [Page]()
        
        init(location: Location, name: String, description: String) {
            self.location = location
            self.name = name
            self.description = description
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(self.location.coordinate.latitude)%7C\(self.location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                self.pages = items.query.pages.values.sorted()
                self.loadingState = .loaded
            } catch {
                self.loadingState = .failed
            }
        }
    }
}
