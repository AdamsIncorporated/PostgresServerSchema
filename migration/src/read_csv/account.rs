use crate::utils::csv::read_csv_to_dataframe;
use polars::prelude::*;

pub fn read_ownership() {
    let file_path = "./src/seed/ownership.csv";
    let df = read_csv_to_dataframe(file_path).unwrap_or_default();
    let cols = ["Description", "AccountNo", "AccountType"];
    let sliced_df = df.select(cols).unwrap_or_default();
    let names = sliced_df.get_column_names();

    println!("Column names: {:?}", names);
}
