import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("PT")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.yellow)
                    .padding(.top, 8)

                Text("Personal Training")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("Password", text: $password)
                    .textContentType(.password)

                if let error = auth.error {
                    Text(error)
                        .font(.system(size: 11))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button(action: {
                    isLoading = true
                    Task {
                        await auth.login(email: email, password: password)
                        isLoading = false
                    }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Kirjaudu")
                            .fontWeight(.semibold)
                    }
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
            }
            .padding(.horizontal, 4)
        }
    }
}
