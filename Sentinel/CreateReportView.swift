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
    @State private var categorias: [Category] = []
    @State private var enviando = false
    @State private var registrado = false
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
                            .keyboardType(.URL)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
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
                        
                        Picker("Categoría", selection: $reporte.categoriaId) {
                            Text("Selecciona una categoría")
                                .tag(Int?.none)

                            ForEach(categorias) { categoria in
                                Text(categoria.name)
                                    .tag(Optional(categoria.id))
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .frame(maxWidth: 350)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    VStack(spacing: 10) {
                        Text("Tipo de caso")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        Picker("Tipo de caso", selection: $reporte.tipoCaso) {
                            ForEach(TipoCaso.allCases, id: \.self) { tipo in
                                Text(tipo.texto)
                                    .tag(tipo)
                            }
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
                        registrarReporte()
                    } label: {
                        if enviando {
                            ProgressView()
                        } else {
                            Text("Registrar Fraude")
                        }
                    }
                    .disabled(enviando || registrado)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding()
                    .scaledToFit()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .clipShape(Capsule())
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
        
        .task {
            await cargarCategorias()
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
        
    private func cargarCategorias() async {
        do {
            categorias = try await SentinelAPI.categories()
        } catch {
            erroresFormulario = [error.localizedDescription]
        }
    }

    private func registrarReporte() {
        erroresFormulario = reporte.validaDatos()

        guard erroresFormulario.isEmpty, let categoriaId = reporte.categoriaId else {
            return
        }

        enviando = true
        Task {
            do {
                let creado = try await SentinelAPI.createReport(
                    NewReport(
                        categoryId: categoriaId,
                        caseType: reporte.tipoCaso.rawValue,
                        title: reporte.titulo.trimmingCharacters(in: .whitespacesAndNewlines),
                        description: reporte.descripcion.trimmingCharacters(in: .whitespacesAndNewlines),
                        evidenceUrl: urlNormalizada(reporte.url)
                    )
                )

                var fallidas = 0
                for imagen in imagenes {
                    guard let jpeg = imagen.jpegParaSubir() else {
                        fallidas += 1
                        continue
                    }
                    do {
                        _ = try await SentinelAPI.uploadImage(reportId: creado.id, jpeg: jpeg)
                    } catch {
                        fallidas += 1
                    }
                }

                onSave(Reporte(dto: creado))
                if fallidas > 0 {
                    erroresFormulario = ["El reporte se registró, pero no se pudieron subir \(fallidas) imagen(es)."]
                    registrado = true
                    enviando = false
                } else {
                    dismiss()
                }
            } catch {
                erroresFormulario = [error.localizedDescription]
                enviando = false
            }
        }
    }

    private func urlNormalizada(_ texto: String) -> String {
        let limpio = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        if limpio.lowercased().hasPrefix("http://") || limpio.lowercased().hasPrefix("https://") {
            return limpio
        }
        return "https://" + limpio
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
}
