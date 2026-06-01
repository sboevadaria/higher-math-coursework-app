import Foundation
import Supabase

// Здесь я создаю Supabase client, через который приложение подключается к backend
// Он используется в AuthView для регистрации, входа, выхода и работы с таблицей profiles
let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://boymezebsyzsqyfcaquv.supabase.co")!,
    supabaseKey: "sb_publishable_m9E6LiMSbWdtKIs6vMguEg_6cWf5K-M"
)
