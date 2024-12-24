//
//  MapViewModel.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 23/12/2024.
//

import Foundation

class MapViewModel: ObservableObject {
    
    private let service: NimbusServiceProtocol
    
    @Published var updated: Bool = false
    
    init(service: NimbusServiceProtocol) {
        self.service = service
    }
    
    func updateWeathers() async {
        let result = await service.updateWeathers()
        switch result {
        case .success:
            updated = true
        case .failure:
            NLogger().log("Failed to update all weathers")
        }
    }
}
