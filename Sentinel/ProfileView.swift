//
//  ProfileView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(SessionStore.self) private var session
    @State private var contactAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appColor
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    Text("Mi cuenta")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)

                    if let profile = session.profile {
                        Text(profile.name ?? "")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)

                        Text(profile.email ?? "")
                            .foregroundColor(.white)
                    } else {
                        ProgressView()
                            .tint(.white)
                    }

                    Button {
                        session.logout()
                    } label: {
                        Text("Cerrar sesión")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: 350)
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .clipShape(Capsule())
                    }
                    
                    HStack(spacing: 15) {
                        Text("¿Necesitas ayuda?")
                            .foregroundColor(.white)
                        Button("Contáctanos") {
                            contactAlert = true
                        }
                        .foregroundColor(Color(red: 51/255, green: 190/255, blue: 255/255))
                        .italic()
                    }
                    .alert("Medios de contactos de la organización:", isPresented: $contactAlert) {
                        Button("Cerrar", role: .cancel) {
                        }
                    } message: {
                        Text("Teléfono: 55 4865 7031\nCorreo: rplsadmin@outlook.com")
                    }
                }
            }
        }
    }
}


#Preview {
    ProfileView()
        .environment(SessionStore())
}
