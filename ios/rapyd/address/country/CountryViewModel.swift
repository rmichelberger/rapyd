//
//  CountryViewModel.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import Foundation

final class CountryViewModel: ObservableObject {
    
    @Published var searchText = "" {
        didSet {
            countries = allCountries.filter({ searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) })
                .sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
        }
    }
    
    @Published private(set) var countries: [Country]
    
    private let allCountries: [Country]
    
    init() {
        self.allCountries = Locale.isoRegionCodes.compactMap { Country(code: $0) }
        self.countries = Locale.isoRegionCodes.compactMap { Country(code: $0) }
    }

}
