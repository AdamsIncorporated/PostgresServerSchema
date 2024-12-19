use tokio_postgres::{Client, Error};
use std::env;

#[tokio::main]
async fn main() -> Result<(), Error> {
    // Parse the database URL from the environment
    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL environment variable not set");

    // Connect to the database
    let (client, connection) = Client::connect(&database_url, tokio_postgres::NoTls)
        .await
        .expect("Failed to connect to database");

    // Spawn the connection task
    tokio::spawn(async move {
        if let Err(e) = connection.await {
            eprintln!("connection error: {}", e);
        }
    });

    // Prepare a statement
    let stmt = client.prepare("SELECT * FROM your_table_name").await?;

    // Execute the statement
    let rows = client.query(&stmt, &[]).await?;

    // Iterate over the rows and print the results
    for row in rows {
        let id: i32 = row.get(0);
        let name: String = row.get(1);
        println!("Id: {}, Name: {}", id, name);
    }

    Ok(())
}