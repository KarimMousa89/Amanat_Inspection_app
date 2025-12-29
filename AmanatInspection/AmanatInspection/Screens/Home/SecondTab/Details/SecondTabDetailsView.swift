//
//  FirstTabDetailsView.swift
//  FifthDemo
//
//  Created by Karim Mousa on 06/07/2025.
//

import SwiftUI

struct SecondTabDetailsView<ViewModel: SecondTabDetailsViewModel>: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        Text("Hello, \(viewModel.user.name)")
        
        Button("Go Back") {
//            dismiss()
            viewModel.onDismiss()
        }
    }
}
