//
//  ProfilHost.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/17.
//

import SwiftUI

struct ProfilHost: View {
    // SwiftUI provides storage in the environment for values you can access using the @Environment property wrapper. Access the editMode value to read or write the edit scope.
    @Environment(\.editMode) private var editModel
    
    @EnvironmentObject var modelData: ModelData
    
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editModel?.wrappedValue == .active {
                    Button("取消") {
                        // 防止onDisappear中对原来模型进行更改
                        draftProfile = modelData.profile
                        editModel?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            
            if editModel?.wrappedValue == .inactive {
                ProfileSummary(profile: modelData.profile)
            } else {
                ProfileEditor(profile: $draftProfile)
                    // 利用界面展示/隐藏才对模型进行备份以及保存
                    .onAppear {
                        draftProfile = modelData.profile
                    }
                    .onDisappear {
                        modelData.profile = draftProfile
                    }
            }
            
        }
        .padding(EdgeInsets(top: 30, leading: 15, bottom: 15, trailing: 15))
    }
}

struct ProfilHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfilHost()
            .environmentObject(ModelData())
    }
}
