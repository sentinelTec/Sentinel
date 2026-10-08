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
    var onSave: (Reporte) -> Void
    
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
                            Text("Administrativas")
                                .tag("Administrativas")
                            
                            Text("Circulación y seguridad")
                                .tag("Circulación y seguridad")
                            
                            Text("Estacionamiento")
                                .tag("Estacionamiento")
                            
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
                    
                    Button("Registrar Fraude") {
                        registrarReporte()
                    }
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding()
                    .scaledToFit()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .clipShape(Capsule())
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
        
    private func registrarReporte() {
        reporte.estadoValidacion = .enRevision
        
        reporte.evidencia = imagenes.compactMap {
            $0.jpegData(compressionQuality: 0.8)
        }
        
        onSave(reporte)
        dismiss()
    }
}


#Preview {
    CreateReportView{ _ in
    }
}
