//
//  ProfileView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("¿No tienes cuenta?")
                .font(.largeTitle)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Button("Iniciar Sesión") {
                
            }
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: 350)
            .background(Color.yellow)
            .cornerRadius(10)
            .clipShape(Capsule())
                
                
            Button("Registrarse") {
                                
            }
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: 350)
            .background(Color.yellow)
            .cornerRadius(10)
            .clipShape(Capsule())
                
            HStack(spacing: 15) {
                Text("¿Necesitas ayuda?")
                    .foregroundColor(.white)
                Button("Contáctanos") {
                
                }
                .foregroundColor(Color(red: 51/255, green: 190/255, blue: 255/255))
                .italic()
            }
        }
    }
}


#Preview {
    ProfileView()
}
