//
//  ContentView.swift
//  Split
//
//  Created by Hugo Queinnec on 04/01/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State var appHasBeenUpdated = false

    var body: some View {
        StartView()
            .onAppear {
                ParametersStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let parameters):
                        let currentAppVersion = getCurrentAppVersion()
                        print(currentAppVersion)
                        if parameters.appVersion != currentAppVersion {
                            print("App has been updated!")
                            appHasBeenUpdated = true
                            
                            var newParameters = parameters
                            newParameters.appVersion = currentAppVersion
                                                        
                            ParametersStore.save(parameters: newParameters) { result in
                                switch result {
                                case .failure(let error):
                                    fatalError(error.localizedDescription)
                                case .success(_):
                                    print("Updated version number saved")
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $appHasBeenUpdated) {
                UpdateSheet()
            }
    }
}

func getCurrentAppVersion() -> String {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
    let version = (appVersion as! String)

    return version
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
