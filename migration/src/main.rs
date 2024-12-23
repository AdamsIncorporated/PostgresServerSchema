use std::env;
use tokio_postgres::NoTls;
mod schema_write;
use schema_write::execute_schema_file;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database_url = env::var("DATABASE_URL")?.to_string();
    let (client, connection) = tokio_postgres::connect(database_url.as_str(), NoTls).await?;

    println!("Database URL: {}", database_url);

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }

        let file_path = "schema/schema.sql";
        let _ = execute_schema_file(&client, file_path).await;

        println!("made it!");
    });

    Ok(())
}
