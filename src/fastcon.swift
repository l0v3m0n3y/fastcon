import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public class Fastcon{
    private let api = "https://fastcon.harknmav.fun/api"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "charset":"utf-8",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "User-Agent":"Dalvik/2.1.0 (Linux; U; Android 7.1.2; LGM-V300K Build/N2G47H)"
        ]

    }
    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func get_telegram_proxy_list() async throws -> Any {
        return try await fetchJSON(from: "\(api)/proxies")
    }

    public func ping_server(serverId: String) async throws -> Any {
        // if telegram proxy - id, if servers - host
        return try await fetchJSON(from: "\(api)/proxy-ping/\(serverId)")
    }

    public func get_servers_list(password: String = "0402036") async throws -> Any {
        return try await fetchJSON(from: "\(api)/admin/servers?password=\(password)")
    }
}
