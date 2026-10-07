//
//  RegistrationDataValidation.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 07/10/26.
//

import Foundation

extension String {
    var esVacio: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var esLongitudValida: Bool {
        return count >= 8
    }
    
    var esCorreoValido: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return self.range(of: emailRegEx, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var esTelefonoValido: Bool {
        return count == 10
    }
}
