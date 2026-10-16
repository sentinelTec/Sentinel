import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionManager
    @Environment(\.dismiss) private var dismiss
    @State var usuario = Usuario()
    @State var erroresFormulario: [String] = []
    @State private var cargando = false
    var onLoginSuccess: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()
                
            ScrollView(.vertical) {
                VStack(spacing: 15) {
                    Image("Sentinel")
                        .resizable()
                        .frame(maxWidth: 250, maxHeight: 250)
                    
                    Text("Iniciar Sesión")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    
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
                        Text("¿Aún no tienes cuenta?")
                            .foregroundColor(Color(red: 194/255, green: 194/255, blue: 194/255))
                        NavigationLink {
                            RegistrationView()
                        } label: {
                            Text("Registrate")
                                .foregroundColor(Color.red)
                                .italic()
                        }
                    }
                    
                    Button {
                        Task {
                            await iniciarSesion()
                        }
                    } label: {
                        Group {
                            if cargando {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Iniciar Sesión")
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
                        dismiss()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    @MainActor
    private func iniciarSesion() async {
        erroresFormulario = usuario.validaDatos()
        
        guard erroresFormulario.isEmpty else {
            return
        }
            
        cargando = true
        defer { cargando = false }
            
        do {
            try await session.login(
                email: usuario.correo.trimmingCharacters(in: .whitespacesAndNewlines),
                password: usuario.contrasena
            )
                
            if let onLoginSuccess {
                onLoginSuccess()
            } else {
                dismiss()
            }
        } catch {
            erroresFormulario = [
                "No se pudo iniciar sesión. Verifica tus credenciales y la conexión con el servidor.",
                error.localizedDescription
            ]
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .environmentObject(SessionManager())
}
