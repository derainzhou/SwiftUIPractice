//
//  PageControl.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/17.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    var numberOfPage: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPage
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(control: self)
    }

    class Coordinator: NSObject {
        var control: PageControl
        init(control: PageControl) {
            self.control = control
        }
        
        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}
