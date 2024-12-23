use std::env;
use tokio_postgres::NoTls;
mod schema_write;
use schema_write::execute_schema_file;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database_url = env::var("DATABASE_URL")?.to_string();
    let (client, connection) = tokio_postgres::connect(database_url.as_str(), NoTls).await?;

    println!("Database URL: {}", database_url);

    match env::current_dir() {
        Ok(cwd) => println!("Current directory: {:?}", cwd),
        Err(e) => println!("Error getting current directory: {:?}", e),
    }

    let file_path = "migration/src/schema/schema.sql";
    let _ = execute_schema_file(&client, file_path).await;

    println!("made it!");

    Ok(())
}
