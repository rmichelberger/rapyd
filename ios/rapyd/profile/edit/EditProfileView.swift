//
//  EditProfileView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct EditProfileView: View {
    
    @Binding var profile: Profile
    
    @ObservedObject private var viewModel: ProfileViewModel
    //    @State private var birthday = Date(timeIntervalSinceNow: TimeInterval(-30*365*24*60*60))
    
    init(profile: Binding<Profile>) {
        _profile = profile
        viewModel = ProfileViewModel(profile: profile.wrappedValue)
    }
    
    
    @ViewBuilder
    private func iconView(title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .padding(.top, 24)
            .padding(.horizontal)
            .padding(.bottom, 6)
    }
    
    @ViewBuilder
    private var emailView: some View {
        iconView(title: "Email", systemImage: "envelope")
        
        VStack {
            TextField("Your email address", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
        }
        .background(Color.secondary.opacity(0.2))
        .padding(.bottom)
    }
    
    @ViewBuilder
    private var nameView: some View {
        iconView(title: "Name", systemImage: "person")
        
        
        VStack(alignment: .leading) {
            TextField("Your first Name", text: $viewModel.firstName)
                .padding()
            TextField("Your last Name", text: $viewModel.lastName)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .background(Color.secondary.opacity(0.2))
        .padding(.bottom)
        
    }
    
    @ViewBuilder
    private var birthdayView: some View {
        iconView(title: "Birthday", systemImage: "calendar")
        
        VStack {
            DatePicker(selection: $viewModel.birthday, displayedComponents: .date) {
                Text("Set date")
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.secondary.opacity(0.2))
        .padding(.bottom)
        
    }
    
    @ViewBuilder
    private var addressView: some View {
        iconView(title: "Address", systemImage: "house")
        
        NavigationLink(destination: AddressView(address: $viewModel.address)) {
            HStack {
                Text(viewModel.formattedAddress)
                    .padding()
                Spacer()
            }
            .background(Color.secondary.opacity(0.2))
        }.isDetailLink(isIpad)
        .padding(.bottom)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            emailView
            
            nameView
            
            birthdayView
            
            addressView
            
        }
        .onReceive(viewModel.profilePublisher) { (profile) in
            self.profile = profile
        }
        
    }
}

#if DEBUG
struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(profile: .constant(.empty))
    }
}
#endif
