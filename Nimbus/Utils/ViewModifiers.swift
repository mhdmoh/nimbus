//
//  ViewModifiers.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import Foundation
import SwiftUI

struct MainBackground: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .background{
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.background)
            }
    }
}
