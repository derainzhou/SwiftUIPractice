//
//  LandmarkRow.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/13.
//

import Foundation
import SwiftUI

struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        Text("")
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkRow(landmark: landmarks[0])
    }
}
