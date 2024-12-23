use std::env;
use tokio_postgres::NoTls;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database_url = env::var("DATABASE_URL")?.to_string();
    let (client, connection) = tokio_postgres::connect(database_url.as_str(), NoTls).await?;

    println!("Database URL: {}", database_url);

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });
    
    Ok(())
}
