//
//  ContentView.swift
//  CallRecording
//
//  Created by 遠藤拓弥 on 10.8.2023.
//
import SwiftUI
import CallKit
import SwiftUI
import CallKit

class CallManager: NSObject, CXProviderDelegate {
    let provider: CXProvider
    let callController = CXCallController()

    override init() {
        self.provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "CallKitSample"))
        super.init()
        self.provider.setDelegate(self, queue: nil)
    }

    func startCall() {
        let callUUID = UUID()
        let handle = CXHandle(type: .generic, value: "destinationNumber")
        let startCallAction = CXStartCallAction(call: callUUID, handle: handle)
        let transaction = CXTransaction(action: startCallAction)

        callController.request(transaction) { error in
            if let error = error {
                print("Error starting call: \(error)")
            } else {
                print("Successfully started call")
            }
        }
    }

    func endCall() {
        let callUUID = UUID() // Ideally, you should keep track of the UUID you used to start the call
        let endCallAction = CXEndCallAction(call: callUUID)
        let transaction = CXTransaction(action: endCallAction)

        callController.request(transaction) { error in
            if let error = error {
                print("Error ending call: \(error)")
            } else {
                print("Successfully ended call")
            }
        }
    }

    func providerDidReset(_ provider: CXProvider) {}

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
}

struct ContentView: View {
    private var callManager = CallManager()

    var body: some View {
        VStack(spacing: 20) {
            Button("Start Call") {
                callManager.startCall()
            }
            Button("End Call") {
                callManager.endCall()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
