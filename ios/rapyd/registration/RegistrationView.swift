//
//  RegistrationView.swift
//  rapyd
//
//  Created by Roland Michelberger on 31.05.21.
//

import SwiftUI

struct RegistrationView: View {
    
    @ObservedObject var viewModel: RegistrationViewModel
    
    @State private var currentPageIndex = 0
    
    @ViewBuilder
    private var editProfileView: some View {
        EditProfileView(profile: $viewModel.profile)
    }
    
    @ViewBuilder
    private var registrationView: some View {
        NavigationView {
            VStack {
                PaddedScrollView {
                    editProfileView
                }
                PrimaryButton("Register") {
                    viewModel.register()
                }
                .disabled(!viewModel.canRegister)
                .padding()
                //            .padding(.bottom, 40)
            }
            .navigationTitle("Create account")
        }
    }
    
    @ViewBuilder
    private var welcomeView: some View {
        VStack {
            
            HStack {
                Text("Welcome")
                    .font(.largeTitle)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            
            AnimatedImageView(imageNames: ["shop1", "shop3", "shop2", "secure"])
                .frame(maxHeight: 260)
                .padding()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Pay online or in-store.")
                        .font(.title2)
                    Text("Easy. Secure. Rapyd.")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
            
            Image("logo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.secondary)
                .scaledToFit()
                .frame(maxWidth: 100)
                .padding()
        }
        .padding()
        .foregroundColor(.white)
    }
    
    @ViewBuilder
    private var forwardView: some View {
        VStack {
            
            HStack {
                Text("Send or receive money?")
                    .font(.largeTitle)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            AnimatedImageView(imageNames: ["send_money", "send1",  "send2", "send3"])
                .frame(maxHeight: 260)
                .padding()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Easy as a chat message.")
                        .font(.title2)
                    Text("Fun. Secure. Rapyd.")
                        .font(.title2)
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
            
            Image("logo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.secondary)
                .scaledToFit()
                .frame(maxWidth: 100)
                .padding()
        }
        .padding()
        .foregroundColor(.white)
    }
    
    var body: some View {
        GeometryReader { geometry in
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            } else {
                LiquidSwipeView(contents: [
                                    AnyView(welcomeView
                                                .padding(.top, geometry.safeAreaInsets.top)
                                    ),
                                    AnyView(LazyView(forwardView
                                                .padding(.top, geometry.safeAreaInsets.top))
                                    ),
                                    AnyView(registrationView
                                                .background(Color.primary.colorInvert())
                                                .padding(.top, geometry.safeAreaInsets.top)
                                    )], pageIndex: $currentPageIndex)
                    
                    .alert(isPresented: Binding<Bool>(get: { viewModel.error != nil}, set: { (show) in
                        viewModel.error = nil
                    })) { () -> Alert in
                        Alert(title: Text("Oops"), message: Text(viewModel.error?.localizedDescription ?? "Something went wrong. Try again later."), dismissButton: nil)
                    }
            }
        }
    }
}

#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel())
    }
}
#endif
