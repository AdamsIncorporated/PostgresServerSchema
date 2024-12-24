use std::env;
use tokio_postgres::NoTls;
mod schema_write;
mod read_csv;
mod utils;
use schema_write::execute_schema_file;
use read_csv::account::read_ownership;


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database_url = env::var("DATABASE_URL")?.to_string();
    let (client, conn) = tokio_postgres::connect(database_url.as_str(), NoTls).await?;

    // Spawn a blocking task to handle the connection
    tokio::spawn(async move {
        if let Err(e) = conn.await {
            eprintln!("Connection error: {}", e);
        }
    });

    let file_path = "./src/schema_write/schema.sql";
    execute_schema_file(&client, file_path).await?;
    read_ownership();

    Ok(())
}
