//
//  Errors.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 23/09/26.
//

import SwiftUI

struct Errors: View {
    var errores:[String] = []
    var body: some View {
        VStack {
            if errores.count > 0 {
                ForEach(errores, id: \.self) {
                    error in Text(error)
                }
            } else {
                Text("No hay errores")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    var errores_preview: [String] = ["La contraseña es vacía", "Error 2"]
    Errors(errores: errores_preview)
    
}

#Preview {
    Errors()
}
