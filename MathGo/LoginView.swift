import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authView: AuthView
    
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var isSignUp = false
    
    var body: some View {
        VStack(spacing: 18) {
            Text(isSignUp ? "Create account" : "Log in")
                .font(.custom("PixelifySans-Regular", size: 34))
            
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .authFieldStyle()
            
            SecureField("Password", text: $password)
                .authFieldStyle()
            
            // Поле имени появляется только в режиме регистрации
            if isSignUp {
                TextField("Name", text: $displayName)
                    .authFieldStyle()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            SimpleButton(title: isSignUp ? "Sign up" : "Log in") {
                Task {
                    // Перед запросом к Supabase проверяю, что обязательные поля не пустые
                    if email.isEmpty || password.isEmpty {
                        authView.successMessage = ""
                        authView.errorMessage = "Please enter both email and password."
                        return
                    }
                    
                    // В зависимости от выбранного режима запускаю регистрацию или вход
                    if isSignUp {
                        await authView.signUp(
                            email: email,
                            password: password,
                            displayName: displayName
                        )
                    } else {
                        await authView.signIn(
                            email: email,
                            password: password
                        )
                    }
                }
            }
            
            // Кнопка переключает экран между login и sign-up режимами
            SimpleButton(title: isSignUp ? "Sign in" : "New here?") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isSignUp.toggle()
                    authView.errorMessage = ""
                    authView.successMessage = ""
                }
            }
            
            // Success message показывается после успешного действия
            if !authView.successMessage.isEmpty {
                Text(authView.successMessage)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.green)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.green.opacity(0.12))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.green.opacity(0.45), lineWidth: 1.5)
                    )
                    .transition(.opacity)
            }

            // Error message показывается, если возникла проблема с вводом или авторизацией
            if !authView.errorMessage.isEmpty {
                Text(authView.errorMessage)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.red.opacity(0.10))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.red.opacity(0.35), lineWidth: 1.5)
                    )
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 26)
        .animation(.easeInOut(duration: 0.3), value: isSignUp)
    }
}

// Reusable modifier для полей ввода на экране авторизации
extension View {
    func authFieldStyle() -> some View {
        self
            .font(.system(size: 18, weight: .regular, design: .rounded))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            )
    }
}
