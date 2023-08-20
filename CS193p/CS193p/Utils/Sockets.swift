//
//  Sockets.swift
//  CS193p
//
//  Created by DerainZhou on 2023/8/20.
//

import Foundation
import CocoaAsyncSocket

class ServerSockets: NSObject, GCDAsyncSocketDelegate {
    static let shared = ServerSockets()
    
    private lazy var socket: GCDAsyncSocket? = {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        socket.autoDisconnectOnClosedReadStream = true
        return socket
    }()
    
    
    private var clinetSocket: GCDAsyncSocket?
    
    private func fetchNewData() {
        socket?.readData(withTimeout: -1, tag: 10086)
    }
    
    public func listen() {
        do {
            try socket?.accept(onInterface: "localhost", port: 8080)
        } catch  {
            NSLog("Socket: listen failed, error: \(error)")
        }
    }
    
    public func send(_ message: String) {
        clinetSocket?.write(message.data(using: .utf8), withTimeout: 5.0, tag: 10086)
    }
    
    public func disconnect() {
        socket?.disconnect()
        socket = nil
    }
    
    // MARK: - GCDAsyncSocketDelegate
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        NSLog("Socket: didAcceptNewSocket, \(newSocket)")
        clinetSocket?.disconnectAfterReadingAndWriting()
        clinetSocket = newSocket
        fetchNewData()
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message = String(data: data, encoding: .utf8) ?? ""
        NSLog("Socket: didReaddata, \(message)")
        fetchNewData()
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        NSLog("Socket: didWriteDataWithTag, \(tag)")
    }
}


// MARK: - ClientSockets

protocol ClientSocketsDelegate {
    func socketsDidReceive(_ message: String)
}

class ClientSockets: NSObject, GCDAsyncSocketDelegate {
    static let shared = ClientSockets()
    var delegate: ClientSocketsDelegate?
    
    private lazy var socket: GCDAsyncSocket? = {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        return socket
    }()
    
    private func fetchNewData() {
        socket?.readData(withTimeout: -1, tag: 10086)
    }
    
    public func connect() {
        if socket?.isConnected ?? false { return }
        do {
            try socket?.connect(toHost: "localhost", onPort: 8080)
            socket?.readData(withTimeout: -1, tag: 10086)
        } catch {
            NSLog("Socket: listen failed, error: \(error)")
        }
        
    }
    
    public func send(_ message: String) {
        socket?.write(message.data(using: .utf8), withTimeout: 5.0, tag: 10086)
    }
    
    public func disconnect() {
        socket?.disconnect()
        socket = nil
    }
    
    // MARK: - GCDAsyncSocketDelegate
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        NSLog("Socket: didConnectToHost, \(host):\(port)")
        fetchNewData()
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        NSLog("Socket: socketDidDisconnect, error: \(err?.localizedDescription ?? "")")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message = String(data: data, encoding: .utf8) ?? ""
        NSLog("Socket: didReaddata, \(message)")
        delegate?.socketsDidReceive(message)
        fetchNewData()
        
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        NSLog("Socket: didWriteDataWithTag, \(tag)")
    }
}

