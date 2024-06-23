//
//  ContentView.swift
//  ChatDemo
//
//  Created by ISHOWSPEED on 2024/06/01.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
//class FirebaseManager: NSObject {
//    let auth: Auth
//    static let shared = FirebaseManageer()
//    override init() {
//        FirebaseApp.configure()
//        self.auth = Auth.auth()
//        super.init()
//    }
//}

struct LoginView: View {
    let didCompleteLoginProcess: () -> ()
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var password = ""
    @State var shouldShowImagePicker = false
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("選択してください", selection: $isLoginMode) {
                        Text("ログイン").tag(true)
                        Text("アカウント登録").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if !isLoginMode{
                        Button(action: {
                            shouldShowImagePicker.toggle()
                            // プロフィール画像を選択するアクション
                        }) {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3)
                            )
                        }
                    }
                    
                    Group {
                        TextField("メールアドレス", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(5.0)
                        
                        SecureField("パスワード", text: $password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(5.0)
                    }
                    .padding(.horizontal, 16)
                    
                    Button(action: {
                        handleAction()
                    }) {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "ログイン" : "アカウント作成")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                        .cornerRadius(5.0)
                    }
                    .padding(.horizontal, 16)
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "ログイン" : "アカウント登録")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
        
        
        
    }
    @State var image: UIImage?
    
    private func handleAction() {
        if isLoginMode {
            // ログイン処理
            loginUser()
            print("ログイン: \(email), \(password)")
        } else {
            // アカウント作成処理
            createNewAccount()
                        print("アカウント作成: \(email), \(password)")
        }
    }
    @State var loginStatusMessage = ""
    private func createNewAccount() {
        if self.image == nil {
            self.loginStatusMessage = "You must select an avatar image"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("アカウント作成に失敗しました", err)
                self.loginStatusMessage = "アカウント作成に失敗しました \(err)"
                return
            }
            print("アカウントを作成しました: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "アカウントを作成しました: \(result?.user.uid ?? "")"
            
                        self.persistImageToStorage()
        }
    }
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("ログインに失敗しました", err)
                self.loginStatusMessage = "ログインに失敗しました \(err)"
                return
            }
            print("ログインしました: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "ログインしました: \(result?.user.uid ?? "")"
            self.didCompleteLoginProcess()

        }
    }
        private func persistImageToStorage() {
                    let filename = UUID().uuidString
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let ref = Storage.storage().reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                    return
                }
    
                ref.downloadURL { url, err in
                    if let err = err {
                        self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                        return
                    }
    
                    self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                    print(url?.absoluteString)
                    guard let url = url else { return }
                    self.storeUserInformation(imageProfileUrl: url)
                }
            }
        }
    private func storeUserInformation(imageProfileUrl: URL){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userData = [ "email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        Firestore.firestore().collection("users")
            .document(uid).setData(userData){ err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
                self.didCompleteLoginProcess()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {
            
        })
    }
}
