import SwiftUI

@main
struct MathGoApp: App {
    // Создаю AuthView один раз при запуске приложения
    // Он хранит состояние авторизации и передается дальше во все основные экраны
    @StateObject private var authView = AuthView()
    
    var body: some Scene {
        WindowGroup {
            // Если пользователь уже вошел в аккаунт, открываю главный экран приложения
            if authView.isLoggedIn {
                ContentView()
                    .environmentObject(authView)
            } else {
                // Если активной сессии нет, показываю экран авторизации
                LoginView()
                    .environmentObject(authView)
            }
        }
    }
}
