//
//  RegistrationView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 07/10/26.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject private var session: SessionManager
    @State var usuario = Usuario()
    @State var erroresFormulario: [String] = []
    @State private var cargando = false
    @State private var mostrarLogin = false
    
    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
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
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                    SecureField("Contraseña", text: $usuario.contrasena)
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
                    
                    Button {
                        Task {
                            await registrarUsuario()
                        }
                    } label: {
                        Group {
                            if cargando {
                                ProgressView()
                                    .tint(.black)
                            } else {
                                Text("Registrarse")
                            }
                        }
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .clipShape(Capsule())
                    }
                    .disabled(cargando)
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
        .navigationDestination(isPresented: $mostrarLogin) {
            LoginView()
        }
    }
    
    @MainActor
    private func registrarUsuario() async {
        erroresFormulario = usuario.validaDatos()

        guard erroresFormulario.isEmpty else {
            return
        }

        cargando = true
        defer { cargando = false }

        do {
            _ = try await session.register(
                name: usuario.nombreDeUsuario.trimmingCharacters(in: .whitespacesAndNewlines),
                email: usuario.correo.trimmingCharacters(in: .whitespacesAndNewlines),
                password: usuario.contrasena
            )

            mostrarLogin = true
        } catch {
            erroresFormulario = [
                "No se pudo completar el registro.",
                error.localizedDescription
            ]
        }
    }
}

#Preview {
    NavigationStack {
        RegistrationView()
    }
    .environmentObject(SessionManager())
}
