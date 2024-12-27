use calamine::Data;
use calamine::{open_workbook, Reader, Xlsx};
use itertools::multizip;
use polars::prelude::*;
use std::error::Error;
use std::vec;

#[derive()]
struct Account {
    account_no: String,
    account: String,
    account_type: String,
}

pub struct Accounts {
    accounts: Vec<Account>,
}

pub fn insert_into_sql() -> Result<(), Box<dyn Error>> {
    let accounts = construct_accounts_struct()?;

    Ok(())
}

fn construct_accounts_struct() -> Result<Accounts, polars::error::PolarsError> {
    let df: DataFrame = construct_accounts_dataframe()?;

    // find index delimeter value for slice
    let target_value: &str = "~business_unit";

    // Find the index where "Description" equals the target_value
    let first_index = df
        .clone()
        .lazy()
        .filter(col("Description").eq(lit(target_value)))
        .collect()?
        .column("Description")?
        .str()?
        .into_no_null_iter()
        .enumerate()
        .next()
        .map(|(index, _)| index)
        .ok_or_else(|| {
            PolarsError::ComputeError(format!("No match found for {}", target_value).into())
        })?;

    let df = df.clone().slice(0, first_index);
    let objects = df.take_columns();
    let combined = multizip((
        objects[1].str()?.iter(),
        objects[2].str()?.iter(),
        objects[3].str()?.iter(),
    ));
    let rows: Vec<Account> = combined
        .map(|(a, b, c)| Account {
            account: a.unwrap_or_default().to_string(),
            account_no: b.unwrap_or_default().to_string(),
            account_type: c.unwrap_or_default().to_string(),
        })
        .collect();
    let accounts = Accounts { accounts: rows };

    Ok(accounts)
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
