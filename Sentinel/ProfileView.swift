//
//  ProfileView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 21/09/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: SessionManager
    @State private var contactAlert = false
    @State private var logoutAlert = false
    @State private var cantidadMisReportes = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appColor
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    if session.isAuthenticated {
                        Text("Mi perfil")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)

                        Text(session.currentUser?.name ?? "Usuario de Sentinel")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        if let email = session.currentUser?.email {
                            Text(email)
                                .foregroundColor(.white)
                        }
                        
                        NavigationLink {
                            MyReports()
                        } label: {
                            HStack(spacing: 120) {
                                Text("Mis reportes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Text("\(cantidadMisReportes)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 38, height: 38)
                                    .background(Color(red: 255/255, green: 224/255, blue: 85/255))
                                    .clipShape(Capsule())
                            }
                            .padding(.horizontal, 15)
                            .frame(maxWidth: 350, maxHeight: 50)
                            .background(Color.yellow)
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)

                        Button("Cerrar sesión") {
                            logoutAlert = true
                        }
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.yellow)
                        .clipShape(Capsule())

                        .alert("¿Deseas cerrar sesión?", isPresented: $logoutAlert) {
                            
                            Button("Cancelar", role: .cancel) {
                            }
                            
                            Button("Cerrar sesión") {
                                session.logout()
                            }
                        } message: {
                            Text("")
                        }
                    } else {
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
                .padding()
                
                .task(id: session.isAuthenticated) {
                    guard session.isAuthenticated else {
                        cantidadMisReportes = 0
                        return
                    }
                    
                    do {
                        let reportes = try await session.fetchMyReports()
                        cantidadMisReportes = reportes.count
                    } catch {
                        print("Error al contar mis reportes:", error.localizedDescription)
                    }
                }
            }
        }
    }
}


#Preview {
    ProfileView()
        .environmentObject(SessionManager())
}
