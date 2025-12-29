//
//  FirstTabDetailsView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct FirstTabDetailsView<ViewModel: FirstTabDetailsViewModel>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Text("Hello, \(viewModel.book.title)")
        
        Button("Go Back") {
            viewModel.onDismiss()
        }
    }
}
