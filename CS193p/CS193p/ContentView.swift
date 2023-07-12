//
//  ContentView.swift
//  CS193p
//
//  Created by DerainZhou on 2023/3/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        HStack {
            Text("Hello, world!")
                .font(.title)
                .foregroundColor(.green)
            Spacer()
            Text("Derain zhou")
        }
        .background(.red)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
