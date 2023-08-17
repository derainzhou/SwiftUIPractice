//
//  UITest.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/17.
//

import Foundation
import SwiftUI

struct UITest: View {
    var body: some View {
        Label("Your account", systemImage: "person.crop.circle")
            .font(.title)
    }
    
    var imageTestView: some View {
        Image("charleyrivers")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 400)
            // 裁剪图片
            .clipShape(.circle)
            // 设置透明度
            .opacity(0.8)
            .overlay {
                Text("编辑")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                    .foregroundStyle(.red)
            }
    }
    
    var textTest: some View {
        Text("测试文本测试文本测试文本测试文本测试文本!")
            // 设置字重, 一般用于加粗
            .fontWeight(.bold)
            // 设置字体样式
            .font(.title)
            .font(.system(size: 17))
            // 多行文本对齐样式
            .multilineTextAlignment(.leading)
            // 设置行间距
            .lineSpacing(10.0)
            // 设置字体颜色
            .foregroundStyle(.white)
            // 设置背景颜色
            .background(.blue)
            // 设置字体阴影
            .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            // 设置边距, 使用Text的Frame更大
            .padding()
    }
}

struct UITest_Previews: PreviewProvider {
    static var previews: some View {
        UITest()
    }
}
