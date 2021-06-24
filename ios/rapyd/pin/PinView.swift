//
//  PinView.swift
//  rapyd
//
//  Created by Roland Michelberger on 07.06.21.
//

import SwiftUI
import LocalAuthentication

struct PinView: View {
    
    let completion: () -> Void
    
    @State private var canEvaluatePolicy = true
    @State private var biometryType = LABiometryType.none
    
    private func authenticate() {
        
        #if targetEnvironment(simulator)
        completion()

        #else
        var error: NSError?
        
        let context = LAContext()
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Unlock app"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        completion()
                        // authenticated successfully
                    } else {
                        // there was a problem
                        print(authenticationError)
                    }
                }
            }
        } else {
            canEvaluatePolicy = false
            // no biometrics
            if let error = error {
                print(error)
            }
        }
        biometryType = context.biometryType
        #endif
    }
    
    @ViewBuilder
    private var enableBiometry: some View {
        
        switch biometryType {
        case .none:
            Text("Your device must support Face ID or Touch ID")
        case .faceID:
            Text("Enable face ID to unlock the app.")
        case .touchID:
            Text("Enable touch ID to unlock the app.")
        @unknown default:
            Text("Your device must support Face ID or Touch ID")
        }
    }
    
    @ViewBuilder
    private var unlockButton: some View {
        switch biometryType {
        case .none:
            Text("Your device must support Face ID or Touch ID")
        case .faceID:
            Image(systemName: "faceid")
            Text("Unlock with Face ID.")
        case .touchID:
            Image(systemName: "touchid")
            Text("Unlock with Touch ID")
        @unknown default:
            Text("Your device must support Face ID or Touch ID")
        }
    }        
    
    var body: some View {
        VStack {
            if !canEvaluatePolicy {
                
                Image("unlock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding()
                
                enableBiometry
                    .padding()
                
                Button("Open settings") {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    let application = UIApplication.shared
                    if application.canOpenURL(settingsUrl) {
                        application.open(settingsUrl, completionHandler: { _ in
                        })
                    }
                }
                .padding(.bottom)
            } else {
                Image("logo")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.primary)
                    .scaledToFit()
                    .frame(height: 50)
                    .padding()
                    .padding(.top, 40)
                
                Spacer()
                Button {
                    authenticate()
                } label: {
                    unlockButton
                }
                
                Spacer()
            }
        }
        .onAppear {
            authenticate()
        }
    }
}

#if DEBUG
struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        PinView() {
            
        }
    }
}
#endif
