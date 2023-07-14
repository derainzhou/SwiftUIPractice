//
//  BadgeBackground.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/14.
//

import SwiftUI

struct BadgeBackground: View {
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // 使用geometry读取当前视图尺寸
                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                var height = width
                // 将badge放缩到当前视图
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) * 0.5
                width *= xScale
                let yOffset = (height * (1.0 - xScale)) * 0.5
                height *= xScale
                
                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.2 + HexagonParameters.adjustment) + yOffset)
                )
                
                HexagonParameters.segments.forEach { segment in
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y + yOffset))
                    
                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: width * segment.curve.y + yOffset),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: width * segment.control.y + yOffset)
                    )
                }
            }
            // fill()修饰符将形状转换为视图, 默认效果就是fill
            .fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
        // 使当前视图宽高度比1:1
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}
