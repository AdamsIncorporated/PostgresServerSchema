INSERT INTO
    multiview.report_template (report_name, report_structure)
VALUES (
        'Sources and Uses',
        '[
            {
                "AggGroup1": "SOURCE",
                "AggGroup2": "UNRESTRICTED REVNEUE",
                "AggGroup3": "PROPERTY TAX REVENUE",
                "AggGroup4": null,
                "AggGroup5": null,
                "AccountNo": "ADVALTAX",
                "BusinessUnitId": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "PROPERTY TAX REVENUE"
            },
            {
                "AggGroup1": "SOURCE",
                "AggGroup2": "UNRESTRICTED REVNEUE",
                "AggGroup3": "LEASE REVENUE",
                "AggGroup4": null,
                "AggGroup5": null,
                "AccountNo": "LSEREV",
                "BusinessUnitId": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "LEASE REVENUE"
            },
            {
                "AggGroup1": "SOURCE",
                "AggGroup2": "UNRESTRICTED REVNEUE",
                "AggGroup3": "NET TOBACCO SETTLEMENT REVENUE",
                "AggGroup4": null,
                "AggGroup5": null,
                "AccountNo": "TOBSETREV",
                "BusinessUnitId": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "NET TOBACCO SETTLEMENT REVENUE"
            },
            {
                "AggGroup1": "SOURCE",
                "AggGroup2": "UNRESTRICTED REVNEUE",
                "AggGroup3": "PATIENT REVENUE",
                "AggGroup4": null,
                "AggGroup5": null,
                "AccountNo": "TNR",
                "BusinessUnitId": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "PATIENT REVENUE"
            },
            {
                "AggGroup1": "SOURCE",
                "AggGroup2": "UNRESTRICTED REVNEUE",
                "AggGroup3": "OTHER REVENUE",
                "AggGroup4": null,
                "AggGroup5": null,
                "AccountNo": "INTINCREV",
                "BusinessUnitId": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "OTHER REVENUE"
            },
            {
                "AggGroup1": "SOURCE",
                "AggGroup2": "RESTRICTIED REVENUE",
                "AggGroup3": "OPIOID SETTLEMENT REVENUE",
                "AggGroup4": null,
                "AggGroup5": null,
                "AccountNo": "46500",
                "BusinessUnitId": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "OPIOID SETTLEMENT REVENUE"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Ancillary Services",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "ANCILL SRV",
                "DisplayName": "HCD-Ancillary Services"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Cardiology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "CARDIOLOGY",
                "DisplayName": "HCD-Cardiology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Dental",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "DENTAL",
                "DisplayName": "HCD-Dental"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Dermatology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "DERMATOLOGY",
                "DisplayName": "HCD-Dermatology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Dialysis",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "DIALYSIS",
                "DisplayName": "HCD-Dialysis"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Durable Medical Equipment",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "DURABLE MED",
                "DisplayName": "HCD-Durable Medical Equipment"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Endocrinology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "ENDOCRIN",
                "DisplayName": "HCD-Endocrinology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Ear, Nose & Throat ENT",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "ENT",
                "DisplayName": "HCD-Ear, Nose & Throat ENT"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Gastroenterology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "GASTRO",
                "DisplayName": "HCD-Gastroenterology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-General Surgery",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "GEN SURG",
                "DisplayName": "HCD-General Surgery"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Gynecology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "GYN",
                "DisplayName": "HCD-Gynecology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Infectious Disease",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "INF DIS",
                "DisplayName": "HCD-Infectious Disease"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Inmate Health",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "INMATE HEALT",
                "DisplayName": "HCD-Inmate Health"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Musculoskeletal",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "MUSCULOSKELE",
                "DisplayName": "HCD-Musculoskeletal"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Nephrology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "NEPHROLOGY",
                "DisplayName": "HCD-Nephrology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Neurology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "NEUROLOGY",
                "DisplayName": "HCD-Neurology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Oncology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "ONCOLOGY",
                "DisplayName": "HCD-Oncology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Ophthalmology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "OPHTHALM",
                "DisplayName": "HCD-Ophthalmology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Orthotics & Prosthetics",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "ORTHOTIC&PRO",
                "DisplayName": "HCD-Orthotics & Prosthetics"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Pain Management",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PAIN MGT",
                "DisplayName": "HCD-Pain Management"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Palliative Care",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PALL CARE",
                "DisplayName": "HCD-Palliative Care"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Physical Med & Rehab",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PHYSMEDREHAB",
                "DisplayName": "HCD-Physical Med & Rehab"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Podiatry",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PODIATRY",
                "DisplayName": "HCD-Podiatry"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Project Access",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PROJ ACCESS",
                "DisplayName": "HCD-Project Access"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Transportation",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PT TRANSPORT",
                "DisplayName": "HCD-Transportation"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Pulmonology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PULMONOLOGY",
                "DisplayName": "HCD-Pulmonology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Referral Management",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "REFERRALMGT",
                "DisplayName": "HCD-Referral Management"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Rheumatology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "RHEUMATOLOGY",
                "DisplayName": "HCD-Rheumatology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Sexual & Reproductive Service",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "SEXUAL&REPRO",
                "DisplayName": "HCD-Sexual & Reproductive Service"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Specialty Care Reserve",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "SPEC RSRV",
                "DisplayName": "HCD-Specialty Care Reserve"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Translation",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "TRANSLATE",
                "DisplayName": "HCD-Translation"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Convenient / Urgent Care",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "URGENT CARE",
                "DisplayName": "HCD-Convenient / Urgent Care"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Urology",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "UROLOGY",
                "DisplayName": "HCD-Urology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY CARE",
                "AggGroup5": "HCD-Wound Care",
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "WOUND CARE",
                "DisplayName": "HCD-Wound Care"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "PRIMARY CARE",
                "AggGroup5": null,
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PRIMARY CARE",
                "DisplayName": "PRIMARY CARE"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "SPECIALTY BEHAVIORAL HEALTH AND SUBTANCE USE",
                "AggGroup5": null,
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "MENTAL HLTH",
                "DisplayName": "SPECIALTY BEHAVIORAL HEALTH AND SUBTANCE USE"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "POST ACUTE CARE",
                "AggGroup5": null,
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "POST ACUTE",
                "DisplayName": "POST ACUTE CARE"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "PHARMACY",
                "AggGroup5": null,
                "AccountNo": "65000",
                "BusinessUnitId": "4100",
                "RadTypeId": "PROV",
                "RadId": "PHARMACY",
                "DisplayName": "PHARMACY"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "COMMUNITY HEALTHCARE INITIATIVES FUND",
                "AggGroup5": null,
                "AccountNo": "65000",
                "BusinessUnitId": "8200",
                "RadTypeId": "PROV",
                "RadId": "CHIF",
                "DisplayName": "COMMUNITY HEALTHCARE INITIATIVES FUND"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Direct Services Other",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "DSOT",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Direct Services Other"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Direct Services Support",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "DSSP",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Direct Services Support"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Endocrinology",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3475",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Endocrinology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Rheumatology",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3775",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Rheumatology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Cardiology",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3325",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Cardiology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Gastroenterology",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3500",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Gastroenterology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Nephrology",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3600",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Nephrology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Neurology",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3625",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Neurology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Podiatry",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3700",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Podiatry"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Pulmonology",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3750",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Pulmonology"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Palliative Care",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3675",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Palliative Care"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Pharmacy",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3305",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Pharmacy"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Operation Inactive",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3200",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Operation Inactive"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Behavioral Health",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3310",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Behavioral Health"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Patient Navigation Center",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3950",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Patient Navigation Center"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Psychiatry",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "3311",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Psychiatry"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Medical Respite",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "MRSP",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Medical Respite"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "HEALTHCARE DELIVERY PROGRAM",
                "AggGroup3": "SUBTOTAL PURCHASED HEALTHCARE SERVICES",
                "AggGroup4": "DIRECT SERVICES",
                "AggGroup5": "Direct-Services - Transition of Care",
                "AccountNo": "TOTOPEXP",
                "BusinessUnitId": "TOC",
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "Direct-Services - Transition of Care"
            },
            {
                "AggGroup1": "USE",
                "AggGroup2": "UT AFFILIATION AGREEMENT",
                "AggGroup3": null,
                "AggGroup4": null,
                "AggGroup5": null,
                "AccountNo": "65800",
                "BusinessUnitId": null,
                "RadTypeId": null,
                "RadId": null,
                "DisplayName": "UT AFFILIATION AGREEMENT"
            }
        ]'::JSONB
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