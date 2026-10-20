import Foundation

final class ServidorFalso: URLProtocol {
    nonisolated(unsafe) static var estado = 200
    nonisolated(unsafe) static var json = ""

    static func responder(estado: Int = 200, json: String) {
        self.estado = estado
        self.json = json
        URLProtocol.registerClass(ServidorFalso.self)
    }

    static func apagar() {
        URLProtocol.unregisterClass(ServidorFalso.self)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let respuesta = HTTPURLResponse(url: request.url!, statusCode: Self.estado, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: respuesta, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(Self.json.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
