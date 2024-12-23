use std::fs::File;
use std::io::{BufRead, BufReader};
use tokio_postgres::Client;

pub async fn execute_schema_file(
    client: &Client,
    file_path: &str,
) -> Result<(), Box<dyn std::error::Error>> {
   
    let file = match File::open(file_path) {
        Ok(file) => file,
        Err(error) => {
            eprint!("Error opening file: {}", error);
            return Err(Box::new(error));
        }
    };

    let reader = BufReader::new(file);

    let mut sql_script = String::new();
    for line in reader.lines() {
        sql_script.push_str(&line?);
        sql_script.push('\n');
    }

    client
        .simple_query(&sql_script)
        .await
        .map_err(|e| {
            eprintln!("Error executing SQL script: {}", e);
            e
        })?;

    println!("SQL script executed successfully!");
    Ok(())
}