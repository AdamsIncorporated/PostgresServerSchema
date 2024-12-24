use calamine::{open_workbook, Reader, Xlsx};
use polars::prelude::*;

pub fn construct_accounts() {
    let file_path = "./src/seed/ownership.xlsx";
    let df = read_excel_to_dataframe(file_path).expect("Dataframe was expected");
    println!("{}", df);
}

pub fn read_excel_to_dataframe(file_path: &str) -> PolarsResult<DataFrame> {
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

            for name in names {
                let pl_small_str = name.try_into();
                match pl_small_str {
                    Ok(name) => {
                        let data: Vec<i32> = vec![1, 2, 3];
                        cols.push(Column::new(name, &data));
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
