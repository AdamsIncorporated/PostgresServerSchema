use std::vec;

use calamine::Data;
use calamine::{open_workbook, Reader, Xlsx};
use polars::prelude::*;

#[derive(Debug)]
struct Account {
    account_no: String,
    account: String,
    account_type: String,
}

#[derive(Debug)]
struct Accounts {
    accounts: Vec<Account>,
}

impl Accounts {
    fn new(accounts: Vec<Account>) -> Self {
        Self { accounts }
    }
}

pub fn construct_accounts_struct() -> Result<Accounts, polars::error::PolarsError> {
    let df: DataFrame = construct_accounts_dataframe()?;
    let accounts: Vec<_> = vec![];
    let accounts: Vec<Account> = df
        .iter()
        .map(|row| Account {
            account_no: row.get(0),
            account: row[1].utf8().unwrap().to_string(),
            account_type: row[2].utf8().unwrap().to_string(),
        })
        .collect();

    Ok(Accounts::new(accounts))
}

fn construct_accounts_dataframe() -> PolarsResult<DataFrame> {
    let file_path = "./src/seed/ownership.xlsx";
    let df = read_excel_to_dataframe(file_path).expect("Dataframe was expected");
    let df = df
        .clone()
        .lazy()
        .select([
            col("LayerNumber").cast(DataType::Int16),
            col("Description"),
            col("AccountNo"),
            col("AccountType"),
        ])
        .collect()?;

    Ok(df)
}

fn read_excel_to_dataframe(file_path: &str) -> PolarsResult<DataFrame> {
    let mut workbook: Xlsx<_> = match open_workbook(file_path) {
        Ok(workbook) => workbook,
        Err(err) => {
            return Err(PolarsError::ComputeError(
                format!("Cannot open excel file: {}", err).into(),
            ))
        }
    };

    let range = match workbook.worksheet_range("Layer1") {
        Ok(range) => range,
        Err(err) => {
            return Err(PolarsError::ComputeError(
                format!("Layer1 sheet name was not found: {}", err).into(),
            ))
        }
    };

    let column_names = range.headers();

    match column_names {
        Some(names) => {
            let mut cols = Vec::new();

            for (index, col_name) in names.iter().enumerate() {
                match col_name.try_into() {
                    Ok(name) => {
                        let mut excel_data = vec![];

                        // populate the vector with data from each column
                        for row in range.rows().skip(1) {
                            let value = match row.get(index) {
                                Some(data) => match data {
                                    Data::Int(x) => x.to_string(),
                                    Data::Float(x) => x.to_string(),
                                    Data::String(x) => x.clone(),
                                    Data::Bool(x) => x.to_string(),
                                    Data::DateTime(x) => x.to_string(),
                                    Data::DateTimeIso(x) => x.to_string(),
                                    Data::DurationIso(x) => x.to_string(),
                                    Data::Error(x) => x.to_string(),
                                    Data::Empty => "".to_string(),
                                },
                                None => "".to_string(),
                            };
                            excel_data.push(value);
                        }
                        cols.push(Column::new(name, &excel_data));
                    }
                    Err(_) => {
                        return Err(PolarsError::ComputeError(
                            format!("Failed to convert column name to PlSmallStr").into(),
                        ));
                    }
                }
            }

            DataFrame::new(cols)
        }
        None => {
            return Err(PolarsError::ComputeError(
                "Calamine column names were None".into(),
            ));
        }
    }
}
