//
//  DataValidation.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 07/10/26.
//

import Foundation
extension RegistrationView {
    struct Usuario {
        var nombreDeUsuario: String = ""
        var correo: String = ""
        var contrasena: String = ""
        func validaDatos()->[String] {
            var errores: [String] = []
            if nombreDeUsuario.esVacio {
                errores.append("Ingrese un nombre de usuario")
            }
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
