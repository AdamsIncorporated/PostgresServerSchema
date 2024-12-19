use dotenv::dotenv;
use std::env;
use tokio_postgres::NoTls;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").unwrap().to_string();
    let mut client = tokio_postgres::connect(database_url.as_str(), NoTls).await?;
    Ok(())
}
