import Foundation

extension LoginView {
    struct Usuario {
        var correo: String = ""
        var contrasena: String = ""
        func validaDatos()->[String] {
            var errores: [String] = []
            if correo.esVacio {
                errores.append("Ingrese un correo")
            } else if !correo.esCorreoValido {
                errores.append("Ingrese un correo válido")
            }
            if contrasena.esVacio {
                errores.append("Ingrese una contraseña")
            } else if !contrasena.esLongitudValida {
                errores.append("La contraseña debe contener al menos 6 caracteres.")
            }
            
            return errores
        }
    }
}
