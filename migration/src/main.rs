use polars::prelude::*;
use std::env;
use tokio_postgres::NoTls;

fn read_csv_to_dataframe(file_path: &str) -> PolarsResult<DataFrame> {
    CsvReadOptions::default()
        .with_has_header(true)
        .try_into_reader_with_file_path(Some(file_path.into()))?
        .finish()
}

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

    let df = read_csv_to_dataframe("./seed/bt.csv");
    print!("made it!");

    Ok(())
}
