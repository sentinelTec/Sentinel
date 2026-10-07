//
//  ProfileView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var contactAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Text("¿No tienes cuenta?")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Iniciar Sesión")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .clipShape(Capsule())
                }
                
                NavigationLink {
                    RegistrationView()
                } label: {
                    Text("Registrarse")
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


#Preview {
    ProfileView()
}
