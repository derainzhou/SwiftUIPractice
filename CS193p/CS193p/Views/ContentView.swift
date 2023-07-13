//
//  ContentView.swift
//  CS193p
//
//  Created by DerainZhou on 2023/3/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .frame(height: 300)
            
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)
            
            // 设置VStack中子视图左对齐
            VStack(alignment: .leading) {
                Text("Derain zhou")
                    .font(.title)
                
                HStack {
                    Text("Good job")
                        .font(.subheadline)
                    Spacer()
                    Text("Well Done!")
                        .font(.subheadline)
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
