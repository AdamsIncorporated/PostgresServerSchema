INSERT INTO
    multiview.report_template (report_name, report_structure)
VALUES (
        'Sources and Uses',
        '[
            {
                "AccountNoList": [{ "AccountNo": "ADVALTAX", "IsParent": true }],
                "BusinessUnitIdList": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "PROPERTY TAX REVENUE"
            },
            {
                "AccountNoList": [{ "AccountNo": "LSEREV", "IsParent": true }],
                "BusinessUnitIdList": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "LEASE REVENUE"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOBSETREV", "IsParent": true }],
                "BusinessUnitIdList": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "NET TOBACCO SETTLEMENT REVENUE"
            },
            {
                "AccountNoList": [{ "AccountNo": "TNR", "IsParent": true }],
                "BusinessUnitIdList": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "PATIENT REVENUE"
            },
            {
                "AccountNoList": [{ "AccountNo": "INTINCREV", "IsParent": true }],
                "BusinessUnitIdList": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "OTHER REVENUE"
            },
            {
                "AccountNoList": [{ "AccountNo": "46500", "IsParent": false }],
                "BusinessUnitIdList": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "OPIOID SETTLEMENT REVENUE"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "ANCILL SRV",
                "DisplayName": "HCD-Ancillary Services"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "CARDIOLOGY",
                "DisplayName": "HCD-Cardiology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "DENTAL",
                "DisplayName": "HCD-Dental"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "DERMATOLOGY",
                "DisplayName": "HCD-Dermatology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "DIALYSIS",
                "DisplayName": "HCD-Dialysis"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "DURABLE MED",
                "DisplayName": "HCD-Durable Medical Equipment"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "ENDOCRIN",
                "DisplayName": "HCD-Endocrinology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "ENT",
                "DisplayName": "HCD-Ear, Nose & Throat ENT"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "GASTRO",
                "DisplayName": "HCD-Gastroenterology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "GEN SURG",
                "DisplayName": "HCD-General Surgery"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "GYN",
                "DisplayName": "HCD-Gynecology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "INF DIS",
                "DisplayName": "HCD-Infectious Disease"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "INMATE HEALT",
                "DisplayName": "HCD-Inmate Health"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "MUSCULOSKELE",
                "DisplayName": "HCD-Musculoskeletal"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "NEPHROLOGY",
                "DisplayName": "HCD-Nephrology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "NEUROLOGY",
                "DisplayName": "HCD-Neurology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "ONCOLOGY",
                "DisplayName": "HCD-Oncology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "OPHTHALM",
                "DisplayName": "HCD-Ophthalmology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "ORTHOTIC&PRO",
                "DisplayName": "HCD-Orthotics & Prosthetics"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "PAIN MGT",
                "DisplayName": "HCD-Pain Management"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "PALL CARE",
                "DisplayName": "HCD-Palliative Care"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "PHYSMEDREHAB",
                "DisplayName": "HCD-Physical Med & Rehab"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "PODIATRY",
                "DisplayName": "HCD-Podiatry"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "PROJ ACCESS",
                "DisplayName": "HCD-Project Access"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "PT TRANSPORT",
                "DisplayName": "HCD-Transportation"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "PULMONOLOGY",
                "DisplayName": "HCD-Pulmonology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "REFERRALMGT",
                "DisplayName": "HCD-Referral Management"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "RHEUMATOLOGY",
                "DisplayName": "HCD-Rheumatology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "SEXUAL&REPRO",
                "DisplayName": "HCD-Sexual & Reproductive Service"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "SPEC RSRV",
                "DisplayName": "HCD-Specialty Care Reserve"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "TRANSLATE",
                "DisplayName": "HCD-Translation"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "URGENT CARE",
                "DisplayName": "HCD-Convenient / Urgent Care"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "UROLOGY",
                "DisplayName": "HCD-Urology"
            },
            {
                "AccountNoList": [{ "AccountNo": "65000", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
                "RadTypeId": "PROV",
                "RadId": "WOUND CARE",
                "DisplayName": "HCD-Wound Care"
            },
            {
                "AccountNoList": [
                {
                    "AccountNo": "65000",
                    "IsParent": false
                }
                ],
                "BusinessUnitIdList": [
                {
                    "BusinessUnitId": "4100",
                    "IsParent": false
                }
                ],
                "RadTypeId": "PROV",
                "RadId": "PRIMARY CARE",
                "DisplayName": "PRIMARY CARE"
            },
            {
                "AccountNoList": [
                {
                    "AccountNo": "65000",
                    "IsParent": false
                }
                ],
                "BusinessUnitIdList": [
                {
                    "BusinessUnitId": "4100",
                    "IsParent": false
                }
                ],
                "RadTypeId": "PROV",
                "RadId": "MENTAL HLTH",
                "DisplayName": "SPECIALTY BEHAVIORAL HEALTH AND SUBTANCE USE"
            },
            {
                "AccountNoList": [
                {
                    "AccountNo": "65000",
                    "IsParent": false
                }
                ],
                "BusinessUnitIdList": [
                {
                    "BusinessUnitId": "4100",
                    "IsParent": false
                }
                ],
                "RadTypeId": "PROV",
                "RadId": "POST ACUTE",
                "DisplayName": "POST ACUTE CARE"
            },
            {
                "AccountNoList": [
                {
                    "AccountNo": "65000",
                    "IsParent": false
                }
                ],
                "BusinessUnitIdList": [
                {
                    "BusinessUnitId": "4100",
                    "IsParent": false
                }
                ],
                "RadTypeId": "PROV",
                "RadId": "PHARMACY",
                "DisplayName": "PHARMACY"
            },
            {
                "AccountNoList": [
                {
                    "AccountNo": "65000",
                    "IsParent": false
                }
                ],
                "BusinessUnitIdList": [
                {
                    "BusinessUnitId": "4100",
                    "IsParent": false
                }
                ],
                "RadTypeId": "PROV",
                "RadId": "CHIF",
                "DisplayName": "COMMUNITY HEALTHCARE INITIATIVES FUND"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "DSOT", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Direct Services Other"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "DSSP", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Direct Services Support"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3475", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Endocrinology"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3775", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Rheumatology"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3325", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Cardiology"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3500", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Gastroenterology"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3600", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Nephrology"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3625", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Neurology"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3700", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Podiatry"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3750", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Pulmonology"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3675", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Palliative Care"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3305", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Pharmacy"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3200", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Operation Inactive"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3310", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Behavioral Health"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3950", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Patient Navigation Center"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "3311", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Psychiatry"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "MRSP", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Medical Respite"
            },
            {
                "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "TOC", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Transition of Care"
            },
            {
                "AccountNoList": [
                { "AccountNo": "45700", "IsParent": false },
                { "AccountNo": "45800", "IsParent": false },
                { "AccountNo": "79000", "IsParent": false },
                { "AccountNo": "70100", "IsParent": false },
                { "AccountNo": "53000", "IsParent": false },
                { "AccountNo": "52200", "IsParent": false },
                { "AccountNo": "67000", "IsParent": false },
                { "AccountNo": "68000", "IsParent": false },
                { "AccountNo": "60000", "IsParent": false },
                { "AccountNo": "59999", "IsParent": false },
                { "AccountNo": "52500", "IsParent": false },
                { "AccountNo": "72000", "IsParent": false },
                { "AccountNo": "73000", "IsParent": false },
                { "AccountNo": "74000", "IsParent": false },
                { "AccountNo": "66500", "IsParent": false },
                { "AccountNo": "52300", "IsParent": false },
                { "AccountNo": "70200", "IsParent": false },
                { "AccountNo": "70000", "IsParent": false },
                { "AccountNo": "71000", "IsParent": false },
                { "AccountNo": "75000", "IsParent": false },
                { "AccountNo": "66000", "IsParent": false },
                { "AccountNo": "49100", "IsParent": false },
                { "AccountNo": "52400", "IsParent": false },
                { "AccountNo": "52150", "IsParent": false },
                { "AccountNo": "51000", "IsParent": false },
                { "AccountNo": "52100", "IsParent": false },
                { "AccountNo": "76000", "IsParent": false },
                { "AccountNo": "77100", "IsParent": false },
                { "AccountNo": "50000", "IsParent": false },
                { "AccountNo": "77200", "IsParent": false }
                ],
                "BusinessUnitIdList": [
                { "BusinessUnitId": "5200", "IsParent": false },
                { "BusinessUnitId": "9800", "IsParent": false },
                { "BusinessUnitId": "9550", "IsParent": false },
                { "BusinessUnitId": "9043", "IsParent": false },
                { "BusinessUnitId": "9042", "IsParent": false },
                { "BusinessUnitId": "9300", "IsParent": false },
                { "BusinessUnitId": "9400", "IsParent": false },
                { "BusinessUnitId": "9200", "IsParent": false },
                { "BusinessUnitId": "9850", "IsParent": false },
                { "BusinessUnitId": "9100", "IsParent": false },
                { "BusinessUnitId": "9900", "IsParent": false },
                { "BusinessUnitId": "9500", "IsParent": false },
                { "BusinessUnitId": "9000", "IsParent": false }
                ],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "TOTAL ADMINISTRATIVE PROGRAM"
            },
            {
                "AccountNoList": [{ "AccountNo": "65800", "IsParent": false }],
                "BusinessUnitIdList": [{ "BusinessUnitId": "4998", "IsParent": false }],
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "UT AFFILIATION AGREEMENT"
            }
            ]
            '::JSONB
    );

INSERT INTO
    multiview.report_template (report_name, report_structure)
VALUES (
        'Balance Sheet',
        '[
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "CASH AND CASH EQUIVALENTS",
            "Accounts": [
            "11000",
            "11100",
            "11298",
            "11299",
            "11300",
            "11310",
            "11400",
            "11500",
            "11600",
            "11800"
            ]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "SHORT TERM INVESTMENTS",
            "Accounts": [
            "12000",
            "12100",
            "12200",
            "12300",
            "12400",
            "12500",
            "12600",
            "12900",
            "30101"
            ]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "LEASE RECEIVABLE SHORT TERM",
            "Accounts": ["14302", "14301"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "ACCOUNTS RECEIVABLE TAX",
            "Accounts": ["13030", "13040", "13050", "13060", "13070", "13080", "15200"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "OTHER RECEIVABLES",
            "Accounts": [
            "13099",
            "13999",
            "14001",
            "14100",
            "14150",
            "14151",
            "14200",
            "15000",
            "15100",
            "15300",
            "15500",
            "15600"
            ]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "RESTRICTED TCHD LPPF CASH & INVESTMENTS",
            "Accounts": ["11900", "12010"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "RESTRICTED OPIOID FUNDS",
            "Accounts": ["46500"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "RESTRICTED FOR CAPITAL ACQUISITION",
            "Accounts": ["12020", "16900"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "SENDERO PAID-IN CAPITAL",
            "Accounts": ["16200"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "SENDERO SURPLUS DEBENTURE",
            "Accounts": ["16300"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "ADVANCE RECEIVABLE",
            "Accounts": ["15900", "16100"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "LEASE RECEIVABLE LONG TERM",
            "Accounts": ["15301"]
        },
        {
            "AccountTypeDisplayName": "Asset",
            "DisplayName": "TOTAL CAPITAL ASSETS, NET OF DEPRECIATION",
            "Accounts": [
            "17000",
            "17100",
            "17200",
            "17300",
            "17400",
            "17500",
            "17550",
            "17600",
            "17700",
            "17800",
            "17850",
            "17900",
            "18000",
            "18100",
            "18200",
            "18300"
            ]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "ACCOUNTS PAYABLE",
            "Accounts": [
            "20000",
            "20001",
            "20000H",
            "20100",
            "20101",
            "20200",
            "20300",
            "20400",
            "22500",
            "22600",
            "22700",
            "20500",
            "20600"
            ]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "SALARIES & BENEFITS PAYABLE",
            "Accounts": [
            "21000",
            "21100",
            "21200",
            "21300",
            "21350",
            "21400",
            "21500",
            "21550",
            "21600",
            "21700",
            "21900"
            ]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "SHORT-TERM DEBT SERVICE PAYABLE",
            "Accounts": ["23000", "23001"]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "DEFERRED TAX REVENUE",
            "Accounts": ["24000"]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "FUNDS HELD FOR TCHD LPPF",
            "Accounts": ["25000"]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "LONG-TERM DEBT SERVICE PAYABLE",
            "Accounts": ["26000", "27000"]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "LEASE & SUBSCRIPTION LIABILITIES",
            "Accounts": ["20301", "20302", "24700", "23301", "23302", "27301", "27302"]
        },
        {
            "AccountTypeDisplayName": "Liability",
            "DisplayName": "DEFERRED REVENUE",
            "Accounts": ["24600", "24500"]
        },
        {
            "AccountTypeDisplayName": "Capital",
            "DisplayName": "RESTRICTED FOR CAPITAL ASSETS",
            "Accounts": ["30300", "30200"]
        },
        {
            "AccountTypeDisplayName": "Capital",
            "DisplayName": "RESTRICTED FOR OPIOID SETTLEMENT",
            "Accounts": ["30101"]
        },
        {
            "AccountTypeDisplayName": "Capital",
            "DisplayName": "RESTRICTED CAPITAL",
            "Accounts": ["30100", "30500"]
        },
        {
            "AccountTypeDisplayName": "Capital",
            "DisplayName": "UNRESTRICTED CAPITAL",
            "Accounts": [
            "30400",
            "30000"
            ]
        }
        ]'::JSONB
    );