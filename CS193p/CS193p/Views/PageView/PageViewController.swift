//
//  PageViewController.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/17.
//


import SwiftUI
import UIKit

// 在SwiftUI中引入UIKit的视图, 并且将SwiftUI Viwe显示在UIkit视图上

// 1.0 遵守UIViewControllerRepresentable协议
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    // 3.0 在SwiftUI中使用State追踪UIkit视图的状态
    @Binding var currentPage: Int
    
    // MARK: - UIViewControllerRepresentable
    
    // SwiftUI在展示pageViweContoller调用改方法一次, 并管理创建的UIViewController的生命周期
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViweContoller = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViweContoller.dataSource = context.coordinator
        pageViweContoller.delegate = context.coordinator
        
        return pageViweContoller
    }
    
    // 同步SwiftUI与UIKit视图状态
    func updateUIViewController(_ pageViweContoller: UIPageViewController, context: Context) {
        // 将SwiftUI的view包装成UIHostingController, 然后传递给pageViweContoller
        pageViweContoller.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    // MARK: - Coordinator
    // 2.0 定义Coordinator提供DataSource, 以及delegate事件
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController

        // 提供数据源
        var controllers = [UIViewController]()
        
        init(_ pageViweContoller: PageViewController) {
            parent = pageViweContoller
            controllers = parent.pages.map {UIHostingController(rootView: $0)}
        }
        
        // MARK: - UIPageViewControllerDataSource
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index == 0 {
                return controllers.last
            }
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else { return nil }
            
            if index + 1 == controllers.count {
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        // MARK: - UIPageViewControllerDelegate
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
                if completed,
                   let visibleController = pageViewController.viewControllers?.first,
                   let index = controllers.firstIndex(of: visibleController) {
                    parent.currentPage = index
                }
        }
    }
}
