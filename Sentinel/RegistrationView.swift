//
//  RegistrationView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 07/10/26.
//

import SwiftUI

struct RegistrationView: View {
    @State var usuario = Usuario()
    @State var erroresFormulario: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appColor
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    Image("Sentinel")
                        .resizable()
                        .frame(maxWidth: 250, maxHeight: 250)
                    
                    Text("Registro")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Nombre de Usuario", text: $usuario.nombreDeUsuario)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    TextField("Correo", text: $usuario.correo)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    SecureField("Contraseña", text: $usuario.contrasena)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    TextField("Número de teléfono", text: $usuario.numeroDeTelefono)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    HStack(spacing: 15) {
                        Text("¿Ya tienes cuenta?")
                            .foregroundColor(.white)
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Inicia Sesión")
                                .foregroundColor(Color(red: 51/255, green: 190/255, blue: 255/255))
                                .italic()
                        }
                    }
                    
                    Button("Registrarse") {
                        erroresFormulario = usuario.validaDatos()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: 350)
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .clipShape(Capsule())
                    if erroresFormulario.count > 0 {
                        Errors(errores: erroresFormulario)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: 350)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Volver al menú") {
                        
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    RegistrationView()
}
