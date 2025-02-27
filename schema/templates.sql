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
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "ANCILL SRV",
    "DisplayName": "HCD-Ancillary Services"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "CARDIOLOGY",
    "DisplayName": "HCD-Cardiology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "DENTAL",
    "DisplayName": "HCD-Dental"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "DERMATOLOGY",
    "DisplayName": "HCD-Dermatology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "DIALYSIS",
    "DisplayName": "HCD-Dialysis"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "DURABLE MED",
    "DisplayName": "HCD-Durable Medical Equipment"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "ENDOCRIN",
    "DisplayName": "HCD-Endocrinology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "ENT",
    "DisplayName": "HCD-Ear, Nose & Throat ENT"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "GASTRO",
    "DisplayName": "HCD-Gastroenterology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "GEN SURG",
    "DisplayName": "HCD-General Surgery"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "GYN",
    "DisplayName": "HCD-Gynecology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "INF DIS",
    "DisplayName": "HCD-Infectious Disease"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "INMATE HEALT",
    "DisplayName": "HCD-Inmate Health"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "MUSCULOSKELE",
    "DisplayName": "HCD-Musculoskeletal"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "NEPHROLOGY",
    "DisplayName": "HCD-Nephrology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "NEUROLOGY",
    "DisplayName": "HCD-Neurology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "ONCOLOGY",
    "DisplayName": "HCD-Oncology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "OPHTHALM",
    "DisplayName": "HCD-Ophthalmology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "ORTHOTIC&PRO",
    "DisplayName": "HCD-Orthotics & Prosthetics"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "PAIN MGT",
    "DisplayName": "HCD-Pain Management"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "PHYSMEDREHAB",
    "DisplayName": "HCD-Physical Med & Rehab"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "PODIATRY",
    "DisplayName": "HCD-Podiatry"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "PROJ ACCESS",
    "DisplayName": "HCD-Project Access"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "PT TRANSPORT",
    "DisplayName": "HCD-Transportation"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "PULMONOLOGY",
    "DisplayName": "HCD-Pulmonology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "REFERRALMGT",
    "DisplayName": "HCD-Referral Management"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "RHEUMATOLOGY",
    "DisplayName": "HCD-Rheumatology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "SEXUAL&REPRO",
    "DisplayName": "HCD-Sexual & Reproductive Service"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "SPEC RSRV",
    "DisplayName": "HCD-Specialty Care Reserve"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "TRANSLATE",
    "DisplayName": "HCD-Translation"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "URGENT CARE",
    "DisplayName": "HCD-Convenient / Urgent Care"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "UROLOGY",
    "DisplayName": "HCD-Urology"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "4100", "IsParent": false }],
    "RadTypeId": "PROV",
    "RadId": "WOUND CARE",
    "DisplayName": "HCD-Wound Care"
  },
  {
    "AccountNoList": [
      {
        "AccountNo": "EXP-NOD&A",
        "IsParent": true
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
        "AccountNo": "EXP-NOD&A",
        "IsParent": true
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
        "AccountNo": "EXP-NOD&A",
        "IsParent": true
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
        "AccountNo": "EXP-NOD&A",
        "IsParent": true
      }
    ],
    "BusinessUnitIdList": [
      {
        "BusinessUnitId": "4100",
        "IsParent": false
      }
    ],
    "RadTypeId": "PROV",
    "RadId": "PALL CARE",
    "DisplayName": "POST ACUTE CARE"
  },
  {
    "AccountNoList": [
      {
        "AccountNo": "EXP-NOD&A",
        "IsParent": true
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
        "AccountNo": "EXP-NOD&A",
        "IsParent": true
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
    "AccountNoList": [
      {
        "AccountNo": "EXP-NOD&A",
        "IsParent": true
      }
    ],
    "BusinessUnitIdList": [
      {
        "BusinessUnitId": "8200",
        "IsParent": false
      }
    ],
    "RadTypeId": "PROV",
    "RadId": "CHIF",
    "DisplayName": "COMMUNITY HEALTHCARE INITIATIVES FUND"
  },
  {
    "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "DSOT", "IsParent": true }],
    "RadTypeId": null,
    "RadId": null,
    "DisplayName": "Direct-Services - Diagnostics and Other Services"
  },
  {
    "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "DSSP", "IsParent": true }],
    "RadTypeId": null,
    "RadId": null,
    "DisplayName": "Direct-Services - Clinical Support"
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
    "BusinessUnitIdList": [{ "BusinessUnitId": "MRSP", "IsParent": true }],
    "RadTypeId": null,
    "RadId": null,
    "DisplayName": "Direct-Services - Medical Respite"
  },
  {
    "AccountNoList": [{ "AccountNo": "TOTOPEXP", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "TOC", "IsParent": true }],
    "RadTypeId": null,
    "RadId": null,
    "DisplayName": "Direct-Services - Transition of Care"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "ADMN", "IsParent": true }],
    "RadTypeId": null,
    "RadId": null,
    "DisplayName": "TOTAL ADMINISTRATIVE PROGRAM"
  },
  {
    "AccountNoList": [{ "AccountNo": "EXP-NOD&A", "IsParent": true }],
    "BusinessUnitIdList": [{ "BusinessUnitId": "HCOP", "IsParent": true }],
    "RadTypeId": null,
    "RadId": null,
    "DisplayName": "HEALTHCARE OPERATIONS & SUPPORT"
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
            "AccountNoList": [{ "AccountNo": "CASH", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "CASH AND CASH EQUIVALENTS"
        },
        {
            "AccountNoList": [{ "AccountNo": "INVESTMNT", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "SHORT TERM INVESTMENTS"
        },
        {
            "AccountNoList": [{ "AccountNo": "LEAREC", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "LEASE RECEIVABLE SHORT TERM"
        },
        {
            "AccountNoList": [{ "AccountNo": "ARTAX", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RECEIVABLE TAX"
        },
        {
            "AccountNoList": [{ "AccountNo": "ARPAT", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "OTHER RECEIVABLES"
        },
        {
            "AccountNoList": [{ "AccountNo": "AROTH", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "OTHER RECEIVABLES"
        },
        {
            "AccountNoList": [{ "AccountNo": "RSTAST", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RESTRICTED TCHD LPPF CASH & INVESTMENTS"
        },
        {
            "AccountNoList": [{ "AccountNo": "RSTCAPACQ", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RESTRICTED FOR CAPITAL ACQUISITION"
        },
        {
            "AccountNoList": [{ "AccountNo": "16200", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "SENDERO PAID-IN CAPITAL"
        },
        {
            "AccountNoList": [{ "AccountNo": "16300", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "SENDERO SURPLUS DEBENTURE"
        },
        {
            "AccountNoList": [{ "AccountNo": "16100", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "ADVANCE RECEIVABLE"
        },
        {
            "AccountNoList": [{ "AccountNo": "LSERECLT", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "LEASE RECEIVABLE LONG TERM"
        },
        {
            "AccountNoList": [{ "AccountNo": "TOTCAPAST", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "TOTAL CAPITAL ASSETS, NET OF DEPRECIATION"
        },
        {
            "AccountNoList": [{ "AccountNo": "ACTPAY", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "ACCOUNTS PAYABLE"
        },
        {
            "AccountNoList": [{ "AccountNo": "SBPAY", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "SALARIES & BENEFITS PAYABLE"
        },
        {
            "AccountNoList": [{ "AccountNo": "DEBTST", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "SHORT-TERM DEBT SERVICE PAYABLE"
        },
        {
            "AccountNoList": [{ "AccountNo": "DEFTAXREV", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "DEFERRED TAX REVENUE"
        },
        {
            "AccountNoList": [{ "AccountNo": "FUNDSLPPF", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "FUNDS HELD FOR TCHD LPPF"
        },
        {
            "AccountNoList": [{ "AccountNo": "DEBTLT", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "LONG-TERM DEBT SERVICE PAYABLE"
        },
        {
            "AccountNoList": [{ "AccountNo": "NONCLEASES", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "LEASE & SUBSCRIPTION LIABILITIES"
        },
        {
            "AccountNoList": [{ "AccountNo": "OTHDEFREV", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "DEFERRED REVENUE"
        },
        {
            "AccountNoList": [{ "AccountNo": "30300", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RESTRICTED FOR CAPITAL ASSETS"
        },
        {
            "AccountNoList": [{ "AccountNo": "30200", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RESTRICTED FOR CAPITAL ASSETS"
        },
        {
            "AccountNoList": [{ "AccountNo": "30101", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RESTRICTED FOR OPIOID SETTLEMENT"
        },
        {
            "AccountNoList": [{ "AccountNo": "30100", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RESTRICTED CAPITAL"
        },
        {
            "AccountNoList": [{ "AccountNo": "30500", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "RESTRICTED CAPITAL"
        },
        {
            "AccountNoList": [{ "AccountNo": "30400", "IsParent": false }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "UNRESTRICTED CAPITAL"
        },
        {
            "AccountNoList": [{ "AccountNo": "UNA", "IsParent": true }],
            "BusinessUnitIdList": null,
            "RadTypeId": null,
            "RadId": null,
            "DisplayName": "UNRESTRICTED CAPITAL"
        }
        ]'::JSONB
    );