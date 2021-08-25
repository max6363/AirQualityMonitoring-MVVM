//
//  DataProvider.swift
//  AirQualityMonitoring
//
//  Created by minhazpanara on 25/08/21.
//

import Foundation
import Starscream

protocol DataProviderDelegate {
    func didReceive(response: Result<[AQIResponseData], Error>)
}

class DataProvider {
    
    var isConnected: Bool = false
    
    var delegate: DataProviderDelegate?
    
    var socket: WebSocket? = {
        guard let url = URL(string: ServerConnection.url) else {
            print("can not create URL from: \(ServerConnection.url)")
            return nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        var socket = WebSocket(request: request)
        return socket
    }()
    
    func subscribe() {
        self.socket?.delegate = self
        self.socket?.connect()
    }
    
    func unsubscribe() {
        self.socket?.disconnect()
    }
    
    deinit {
        self.socket?.disconnect()
        self.socket = nil
    }
    
}

extension DataProvider: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                handleText(text: string)
            case .binary(let data):
                print("Received data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error(let error):
                isConnected = false
                handleError(error: error)
            }
    }
    
    private func handleText(text: String) {
        let jsonData = Data(text.utf8)
        let decoder = JSONDecoder()
        do {
            let resArray = try decoder.decode([AQIResponseData].self, from: jsonData)
            self.delegate?.didReceive(response: .success(resArray))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func handleError(error: Error?) {
        if let e = error {
            self.delegate?.didReceive(response: .failure(e))
        }
    }
}
