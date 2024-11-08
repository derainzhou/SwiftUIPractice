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
        case photo
    }
    var body: some View {
        Button {
            ServerSockets.shared.send("Hello Client")
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
            
            PhotoLibraryView()
                .tabItem { Label("Photo", systemImage: "list.bullet") }
                .tag(Tab.photo)
                
        }
        .onOpenURL { url in
            NSLog("WidgetURL: \(url)")
        }
        .onAppear(perform: {
            ServerSockets.shared.listen()
        })
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
