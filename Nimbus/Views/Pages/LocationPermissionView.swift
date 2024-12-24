//
//  LocationPermissionView.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 24/12/2024.
//

import SwiftUI
import Lottie

enum LocationPermissionViewEvents {
    case givePermission
    case selectOnMap
}

struct LocationPermissionView: View {
    private var delegate: (LocationPermissionViewEvents) -> Void
    
    init(delegate: @escaping (LocationPermissionViewEvents) -> Void) {
        self.delegate = delegate
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                LottieView(animation: .named("location_anim"))
                    .playing(loopMode: .loop)
                
                VGap()
                
                Text("Nimbus needs your location to provide you with accurate weather information")
                    .multilineTextAlignment(.center)
                
                VGap()
                
                HStack {
                    Button("Give Permission") {
                        delegate(.givePermission)
                    }
                    .buttonStyle(.borderless)
                    
                    Spacer()
                    
                    Button("Select On Map") {
                        delegate(.selectOnMap)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .padding()
            .navigationTitle("Location Required")
            .navigationBarBackButtonHidden(true) 
        }
    }
}

#Preview {
    LocationPermissionView() {event in
        
    }
}
