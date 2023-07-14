//
//  ContentView.swift
//  CS193p
//
//  Created by DerainZhou on 2023/3/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
            .environmentObject(ModelData())
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
