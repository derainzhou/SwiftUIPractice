//
//  ContentView.swift
//  CS193p
//
//  Created by DerainZhou on 2023/3/7.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    var body: some View {
//        Text("This is placeholder text")
//            .font(.title)
//            .redacted(reason: [])
        
        Button {
            ServerSockets.shared().sendMessage()
        } label: {
            Label("Socket Test", systemImage: "person.crop.circle")
        }
        
        TabView(selection: $selection) {
            
            CategoryHome()
                .tabItem{
                    Label("Featured", systemImage: "star")
                }
                .tag(Tab.featured)
            
            LandmarkList()
                .tabItem{
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        }
        .onOpenURL { url in
            NSLog("WidgetURL: \(url)")
        }
        .onAppear(perform: {
            ServerSockets.shared().linsten()
        })
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
