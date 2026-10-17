fn main() {
    // Migration nova precisa forçar recompilação.
    //
    // `sqlx::migrate!` embute as migrations no binário em tempo de compilação.
    // O cargo, porém, não sabe disso sozinho: acrescentar um arquivo novo em
    // `migrations/` não invalida a build, e o binário de teste continua rodando
    // com o conjunto antigo. O resultado é o pior tipo de teste — um que passa
    // sem ter exercitado o que mudou.
    //
    // Aconteceu de verdade: a migration 016 acrescentou uma quinta linha de
    // contexto e o teste que afirmava haver quatro continuou verde, porque o
    // banco em memória dos testes nunca viu a 016.
    println!("cargo:rerun-if-changed=migrations");
    println!("cargo:rerun-if-changed=bin/libcrypto-4-x64.dll");

    // Copia a DLL do OpenSSL para o diretório de saída (debug/release e deps) no Windows
    if let Ok(out_dir) = std::env::var("OUT_DIR") {
        let out_path = std::path::Path::new(&out_dir);
        let dll_src = std::path::Path::new("bin/libcrypto-4-x64.dll");
        if dll_src.exists() {
            // OUT_DIR geralmente é target/<profile>/build/<pkg>/out
            if let Some(profile_dir) = out_path.ancestors().nth(3) {
                let _ = std::fs::copy(dll_src, profile_dir.join("libcrypto-4-x64.dll"));
                let deps_dir = profile_dir.join("deps");
                if deps_dir.exists() {
                    let _ = std::fs::copy(dll_src, deps_dir.join("libcrypto-4-x64.dll"));
                }
            }
        }
    }

    tauri_build::build()
}
