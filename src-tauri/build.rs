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

    tauri_build::build()
}
