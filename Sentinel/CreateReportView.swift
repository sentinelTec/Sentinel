//
//  CreateReportView.swift
//  Sentinel
//
//  Created by David Alejandro Gonçalves Pestana on 28/09/26.
//

import SwiftUI
import PhotosUI

struct CreateReportView: View {
    @State private var reporte = Reporte()
    @Environment(\.dismiss) var dismiss
    @State private var imagenes: [UIImage] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var mostrarCamara = false
    @State private var imagenTomada: UIImage?
    @State private var erroresFormulario: [String] = []
    @State private var guardando = false
    var onSave: (Reporte) async throws -> Void
    
    var body: some View {
        ZStack {
            Color.appColor
                .ignoresSafeArea()
            
            ScrollView(.vertical) {
                Text("Nuevo reporte")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Text("Título del reporte")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        TextField("", text: $reporte.titulo)
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 30)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    
                    VStack(spacing: 10) {
                        Text("Información proporcionada")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        TextField("", text: $reporte.url)
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 30)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    
                    VStack(spacing: 10) {
                        Text("Descripción breve")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        TextField("", text: $reporte.descripcion)
                            .padding()
                            .frame(maxWidth: 350, maxHeight: 150)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    VStack(spacing: 10) {
                        Text("Categoría")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Picker("Categoría", selection: $reporte.categoria) {
                            Text("Circulación y seguridad")
                                .tag("Circulación y seguridad")
                            
                            Text("Estacionamiento")
                                .tag("Estacionamiento")
                            
                            Text("Administrativa")
                                .tag("Administrativa")
                            
                            Text("Estado del vehículo")
                                .tag("Estado del vehículo")
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    VStack(spacing: 10) {
                        Text("Evidencia")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 20) {
                            PhotosPicker(
                                selection: $selectedItems,
                                maxSelectionCount: 3,
                                matching: .images
                            ) {
                                Label("Galería", systemImage: "photo")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                            
                            Button {
                                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                    mostrarCamara = true
                                }
                            } label: {
                                Label("Cámara", systemImage: "camera")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                        }
                        
                        if !imagenes.isEmpty {
                            ScrollView(.horizontal) {
                                HStack(spacing: 12) {
                                    ForEach(imagenes.indices, id: \.self) {
                                        index in
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: imagenes[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            
                                            Button {
                                                imagenes.remove(at: index)
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                            }
                                            .padding()
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Button {
                        Task {
                            await registrarReporte()
                        }
                    } label: {
                        HStack {
                            if guardando {
                                ProgressView()
                                    .tint(.black)
                            }

                            Text(guardando ? "Guardando..." : "Registrar reporte")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .scaledToFit()
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .clipShape(Capsule())
                    }
                    .disabled(guardando)
                    if erroresFormulario.count > 0 {
                        Errors(errores: erroresFormulario)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: 350)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        
        .sheet(isPresented: $mostrarCamara) {
            ImagePicker(image: $imagenTomada, sourceType: .camera)
        }
                
        .onChange(of: selectedItems) { _, nuevosItems in cargarImagenes(nuevosItems)}
                
        .onChange(of: imagenTomada) { _, nuevaImagen in
            if let nuevaImagen {
                imagenes.append(nuevaImagen)
                imagenTomada = nil
            }
        }
    }
    
    private func cargarImagenes(_ items: [PhotosPickerItem]) {
        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        imagenes.append(image)
                    }
                }
            }
        }
    }
       
    @MainActor
    private func registrarReporte() async {
        erroresFormulario = reporte.validaDatos()

        guard erroresFormulario.isEmpty else {
            return
        }
        
        guardando = true
        defer { guardando = false }
        
        reporte.estadoValidacion = .enRevision
        
        reporte.evidencia = imagenes.compactMap {
            $0.jpegParaSubir()
        }
        
        do {
            try await onSave(reporte)
            dismiss()
        } catch {
            erroresFormulario = [
                "No se pudo crear el reporte.",
                error.localizedDescription
            ]
        }
    }
}


extension UIImage {
    func jpegParaSubir(maximoBytes: Int = 4_500_000, ladoMaximo: CGFloat = 2048) -> Data? {
        let escala = min(1, ladoMaximo / max(size.width, size.height))
        let nuevoTamano = CGSize(width: size.width * escala, height: size.height * escala)
        let formato = UIGraphicsImageRendererFormat.default()
        formato.scale = 1
        let redimensionada = UIGraphicsImageRenderer(size: nuevoTamano, format: formato).image { _ in
            draw(in: CGRect(origin: .zero, size: nuevoTamano))
        }
        var calidad: CGFloat = 0.8
        while calidad >= 0.3 {
            if let datos = redimensionada.jpegData(compressionQuality: calidad), datos.count <= maximoBytes {
                return datos
            }
            calidad -= 0.1
        }
        return nil
    }
}

#Preview {
    CreateReportView{ _ in
    }
    .environmentObject(SessionManager())
}
