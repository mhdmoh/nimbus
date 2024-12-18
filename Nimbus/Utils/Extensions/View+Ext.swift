//
//  View+Ext.swift
//  Nimbus
//
//  Created by Mohamad Mohamad on 18/12/2024.
//

import Foundation
import SwiftUI

extension View {
    func mainBackground() -> some View {
        return self.modifier(MainBackground())
    }
}
