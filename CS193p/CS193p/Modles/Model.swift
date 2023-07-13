//
//  Model.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/13.
//

/// 从文件加载模型, 保存模型到文件
import Foundation

var landmarks: [Landmark] = load("landmarkData.json")

func load<T: Decodable>(_ filename: String) -> T {
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("没有找到文件: \(filename)")
    }

    do {
        let data = try Data(contentsOf: file)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("创建模型失败")
    }
}
