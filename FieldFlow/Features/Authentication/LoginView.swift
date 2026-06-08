import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()

                    SecureField("Password", text: $viewModel.password)
                }

                Section {
                    Button {
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("ログイン")
                        }
                    }
                    .disabled(viewModel.isLoading)
                }

                Section("Demo account") {
                    LabeledContent("Email", value: DemoAccount.email)
                    LabeledContent("Password", value: DemoAccount.password)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("FieldFlow")
        }
    }
}

#Preview {
    let container = DependencyContainer.preview()
    LoginView(viewModel: LoginViewModel(sessionStore: container.sessionStore))
}
