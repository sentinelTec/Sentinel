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
        var numeroDeTelefono: String = ""
        func validaDatos()->[String] {
            var errores: [String] = []
            if correo.esVacio {
                errores.append("Ingrese un correo")
            }
            if contrasena.esVacio {
                errores.append("Ingrese una contrasena")
            }
            if numeroDeTelefono.esVacio {
                errores.append("Ingrese un número de teléfono")
            }
            if !correo.esCorreoValido {
                errores.append("Ingrese un correo válido")
            }
            if !contrasena.esLongitudValida {
                errores.append("La contraseña debe contener al menos 8 caracteres.")
            }
            if !numeroDeTelefono.esTelefonoValido {
                errores.append("Ingrese un número de teléfono válido")
            }
            
            return errores
        }
    }
}
