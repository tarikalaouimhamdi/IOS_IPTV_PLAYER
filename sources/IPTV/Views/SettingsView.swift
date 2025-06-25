//
//  SettingsView.swift
//  IPTV
//
//  Created by Tarik ALAOUI on 19/11/2024.
//

import RealmSwift
import SwiftUI

struct SettingsView: View {
  @AppStorage("apiLogin") private var apiLogin: String = AppConfig.apiLogin
  @AppStorage("apiPassword") private var apiPassword: String = AppConfig.apiPassword
  @AppStorage("apiHost") private var apiHost: String = AppConfig.apiHost
  @AppStorage("expDate") private var expDate: String = ""
  @AppStorage("status") private var status: String = ""

  @State private var showSavedMessage: Bool = false
  @State private var showErrorMessage: Bool = false
  @State private var errorMessage: String = ""

  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        HStack {
          VStack(alignment: .center) {
            Image(systemName: "gear")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 200, height: 200)
          }
          .frame(width: geometry.frame(in: .global).width / 2)

          Form {
            Section(header: Text("API Settings")) {
              TextField("Login", text: $apiLogin)
                .textContentType(.username)
                .autocapitalization(.none)
                .disableAutocorrection(true)

              SecureField("Mot de passe", text: $apiPassword)
                .textContentType(.password)
                .autocapitalization(.none)
                .disableAutocorrection(true)

              TextField("Host", text: $apiHost)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .disableAutocorrection(true)

              Button(action: validateAndSaveSettings) {
                Text("Enregistrer")
                  .frame(maxWidth: .infinity)
                  .foregroundStyle(.black)
              }
              .buttonStyle(.plain)
              .tint(.black)

              Text("\($status.wrappedValue) - Expire le: \($expDate.wrappedValue)")
                .font(.callout)
                .foregroundStyle(.black)
            }
          }
          .frame(width: geometry.frame(in: .global).width / 2)
        }
      }
    }
    .alert(isPresented: $showSavedMessage) {
      Alert(
        title: Text("Réglages sauvegardés"),
        message: Text("Vos réglages API ont été enregistrés avec succès."),
        dismissButton: .default(Text("OK"))
      )
    }
    .alert(isPresented: $showErrorMessage) {
      Alert(
        title: Text("Erreur"),
        message: Text(errorMessage),
        dismissButton: .default(Text("OK"))
      )
    }
    .onAppear {
      UserDefaults.standard.set(AppConfig.apiHost, forKey: "apiHost")
      UserDefaults.standard.set(AppConfig.apiPassword, forKey: "apiPassword")
      UserDefaults.standard.set(AppConfig.apiLogin, forKey: "apiLogin")
      UserDefaults.standard.synchronize()
    }
    .navigationTitle("Réglages")
  }

  private func validateAndSaveSettings() {
    if apiLogin.isEmpty {
      errorMessage = "Le champ Login ne peut pas être vide."
      showErrorMessage = true
      return
    }

    if apiPassword.isEmpty {
      errorMessage = "Le champ Mot de passe ne peut pas être vide."
      showErrorMessage = true
      return
    }

    if apiHost.isEmpty {
      errorMessage = "Le champ Host ne peut pas être vide."
      showErrorMessage = true
      return
    }

    saveSettings()
  }

  private func saveSettings() {
    showSavedMessage = true
    APIManager.shared.fetchInfoUser(from: "\(APIManager.shared.baseURL)&action=get_infos") { result in
      switch result {
      case let .success(userInfo):
        print(userInfo)
        UserDefaults.standard.set(userInfo.userInfo.expDate.formatted(), forKey: "expDate")
        UserDefaults.standard.set(userInfo.userInfo.status, forKey: "status")
        UserDefaults.standard.synchronize()
      case let .failure(failure):
        print(failure)
      }
    }
  }
}
