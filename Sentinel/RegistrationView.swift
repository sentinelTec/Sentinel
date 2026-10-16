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
                        .foregroundColor(.red)
                    
                    TextField("", text: $usuario.nombreDeUsuario,
                        prompt: Text("Ingresa tu usuario")
                            .foregroundColor(.white)
                            .italic()
                        )
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.red)
                        .clipShape(Capsule())
                    
                    TextField("", text: $usuario.correo,
                        prompt: Text("Correo")
                            .foregroundColor(.white)
                            .italic()
                        )
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.red)
                        .clipShape(Capsule())
                    
                    SecureField("", text: $usuario.contrasena,
                        prompt: Text("Contraseña")
                            .foregroundColor(.white)
                            .italic()
                        )
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.red)
                        .clipShape(Capsule())
                    
                    HStack(spacing: 15) {
                        Text("¿Ya tienes cuenta?")
                            .foregroundColor(Color(red: 194/255, green: 194/255, blue: 194/255))
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Inicia Sesión")
                                .foregroundColor(Color.red)
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
                                    .tint(.white)
                            } else {
                                Text("Registrarse")
                            }
                        }
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.red)
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
