use std::env;
use tokio_postgres::NoTls;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let database_url = env::var("DATABASE_URL")?
        .to_string()
        .as_str();
    let (mut client, connection) = tokio_postgres::connect(database_url, NoTls).await?;

    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    let rows = client.query("SELECT * FROM [user]", &[]).await?;

    for row in rows {
        let id: String = row.get(0)?;
        let name: String = row.get(1)?;

        println!("User ID: {}, Name: {}", id, name);
    }

    Ok(())
}
