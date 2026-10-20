import Foundation

final class ServidorFalso: URLProtocol {
    nonisolated(unsafe) static var respuestas: [String: (estado: Int, cuerpo: Data)] = [:]
    nonisolated(unsafe) static var peticiones: [URLRequest] = []

    static func responder(_ ruta: String, estado: Int = 200, json: String) {
        respuestas[ruta] = (estado, Data(json.utf8))
    }

    static func encender() {
        respuestas = [:]
        peticiones = []
        URLProtocol.registerClass(ServidorFalso.self)
    }

    static func apagar() {
        URLProtocol.unregisterClass(ServidorFalso.self)
        respuestas = [:]
        peticiones = []
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Self.peticiones.append(request)
        let ruta = request.url?.path ?? ""
        let respuesta = Self.respuestas[ruta] ?? (404, Data("{\"message\":\"No encontrado\"}".utf8))
        let http = HTTPURLResponse(
            url: request.url!,
            statusCode: respuesta.estado,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
        client?.urlProtocol(self, didReceive: http, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: respuesta.cuerpo)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
