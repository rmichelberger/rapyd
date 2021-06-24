//
//  ProfileView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var viewModel = ProfileViewModel(profile: DiskStore().get(key: .profile) ?? .empty)
    
    @ViewBuilder
    private func iconView(title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .padding(.top, 24)
            .padding(.horizontal)
            .padding(.bottom, 4)
    }
    
    @ViewBuilder
    private var emailView: some View {
        iconView(title: "Email", systemImage: "envelope")
        
        Text(viewModel.email)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private var nameView: some View {
        iconView(title: "Name", systemImage: "person")
        
        
        Text(viewModel.firstName)
            .padding(.horizontal)
        Text(viewModel.lastName)
            .padding(.horizontal)
        
    }
    
    @ViewBuilder
    private var birthdayView: some View {
        iconView(title: "Birthday", systemImage: "calendar")
        
        Text(DateFormatter.localizedString(from: viewModel.birthday, dateStyle: .medium, timeStyle: .none))
            .padding(.horizontal)
        
    }
    
    @ViewBuilder
    private var addressView: some View {
        iconView(title: "Address", systemImage: "house")
        
        Text(viewModel.formattedAddress)
            .padding(.horizontal)
    }
    
    
    var body: some View {
        PaddedScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    emailView
                    
                    nameView
                    
                    birthdayView
                    
                    addressView
                    
                }
                Spacer()
            }
        }
        .navigationTitle("Profile")
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
#endif
