//
//  ViewExtension.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/14.
//

import SwiftUI


extension View {
    func debugPrint(_ value:Any) -> some View {
        #if DEBUG
        NSLog("[SwiftUI], \(value)")
        #endif
        return self
    }
}
