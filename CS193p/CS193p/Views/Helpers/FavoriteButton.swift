//
//  FavoriteButton.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/14.
//

import SwiftUI

struct FavoriteButton: View {
    // Binding属性既是Observer又是Observerable, 用于绑定信号与UI
    // 即isSet可订阅模型最新的值, 又可以更改模型的值
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            // 点击按钮发送信号
            isSet.toggle()
        } label: {
            // 读取isSet信号的值
            // The title string that you provide for the button’s label doesn’t appear in the UI when you use the iconOnly label style, but VoiceOver uses it to improve accessibility(人性化服务).
            Label("Toggle Favority", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .black)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true))
    }
}
