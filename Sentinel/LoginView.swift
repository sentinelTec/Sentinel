import SwiftUI

struct LoginView: View {
    @Environment(SessionStore.self) private var session
    @State var usuario = Usuario()
    @State var erroresFormulario: [String] = []
    @State private var enviando = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appColor
                    .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    Image("Sentinel")
                        .resizable()
                        .frame(maxWidth: 250, maxHeight: 250)
                    
                    Text("Iniciar Sesión")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    TextField("Correo", text: $usuario.correo)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
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
                        Text("¿Aún no tienes cuenta?")
                            .foregroundColor(.white)
                        NavigationLink {
                            RegistrationView()
                        } label: {
                            Text("Registrate")
                                .foregroundColor(Color(red: 51/255, green: 190/255, blue: 255/255))
                                .italic()
                        }
                    }
                    
                    Button {
                        iniciarSesion()
                    } label: {
                        if enviando {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Iniciar Sesión")
                        }
                    }
                    .disabled(enviando)
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

    private func iniciarSesion() {
        erroresFormulario = usuario.validaDatos()
        guard erroresFormulario.isEmpty else {
            return
        }
        enviando = true
        Task {
            do {
                try await session.login(
                    email: usuario.correo.trimmingCharacters(in: .whitespaces),
                    password: usuario.contrasena
                )
            } catch {
                erroresFormulario = [error.localizedDescription]
            }
            enviando = false
        }
    }
}


#Preview {
    LoginView()
        .environment(SessionStore())
}
