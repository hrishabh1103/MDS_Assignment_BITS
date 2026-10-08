# Inter-City Bus MDS — Relational DB: Prayogshala Setup Guide

This package is for the **Inter-City Bus Operator** relational implementation for the BITS Pilani WILP Modern Database Systems assignment.

It contains:

- the four MySQL setup/validation scripts;
- the 25 relational SQL requirement files (Q01–Q25);
- this complete from-scratch Prayogshala execution guide;
- empty `outputs/` and `evidence/` folders for team members to save their work.

## Database

Database name:

```text
modern_db_lab
```

Expected tables:

```text
PASSENGER
COACH_TYPE
BUS
SEAT
STOP
ROUTE
ROUTE_STOP
TRIP
FARE_RULE
FESTIVAL
BOOKING
PAYMENT
```

Expected seeded row counts:

| Table | Rows |
|---|---:|
| PASSENGER | 20 |
| COACH_TYPE | 10 |
| BUS | 20 |
| SEAT | 200 |
| STOP | 20 |
| ROUTE | 10 |
| ROUTE_STOP | 100 |
| TRIP | 20 |
| FARE_RULE | 20 |
| FESTIVAL | 10 |
| BOOKING | 22 |
| PAYMENT | 22 |

---

# Part A — From a fresh Prayogshala VM

## 1. Start/enter the VM

Open your assigned Prayogshala virtual machine and use its terminal.

The project should be placed somewhere under the shared workspace. The recommended location is:

```bash
~/workspace/intercity-bus-mds
```

If you clone this repository into another location, simply replace the path in the commands below.

## 2. Check MySQL

```bash
sudo systemctl status mysql
```

If MySQL is not running:

```bash
sudo systemctl start mysql
```

Then test it:

```bash
sudo mysql -e "SELECT VERSION();"
```

### Important: MySQL password

You do **not** need the MySQL root password for this setup if `sudo mysql` works on the Prayogshala VM.

Use:

```bash
sudo mysql
```

or:

```bash
sudo mysql < path/to/script.sql
```

Do not use `mysql -u root -p` unless you specifically know the password.

---

# Part B — Locate the SQL setup scripts

If the repository is at `~/workspace/intercity-bus-mds`, the setup files from this package should be available under:

```text
~/workspace/intercity-bus-mds/relational/setup/
```

Check:

```bash
ls -lah ~/workspace/intercity-bus-mds/relational/setup/
```

You should see:

```text
01_create_database.sql
02_create_tables.sql
03_insert_data.sql
04_validation.sql
```

If your GitHub repository keeps these files somewhere else, use that exact path.

---

# Part C — Create the database

Run:

```bash
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/01_create_database.sql
```

Verify:

```bash
sudo mysql -e "SHOW DATABASES;"
```

You should see:

```text
modern_db_lab
```

---

# Part D — Create all relational tables

Run:

```bash
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/02_create_tables.sql
```

Verify:

```bash
sudo mysql -e "USE modern_db_lab; SHOW TABLES;"
```

Expected tables:

```text
PASSENGER
COACH_TYPE
BUS
SEAT
STOP
ROUTE
ROUTE_STOP
TRIP
FARE_RULE
FESTIVAL
BOOKING
PAYMENT
```

If these 12 tables appear, table creation is complete.

---

# Part E — Insert the project data

Run:

```bash
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/03_insert_data.sql
```

A successful script normally returns to the shell without printing an error.

---

# Part F — Verify the data

Run the following command exactly:

```bash
sudo mysql -e "
USE modern_db_lab;
SELECT 'PASSENGER' AS table_name, COUNT(*) AS row_count FROM PASSENGER
UNION ALL SELECT 'COACH_TYPE', COUNT(*) FROM COACH_TYPE
UNION ALL SELECT 'BUS', COUNT(*) FROM BUS
UNION ALL SELECT 'SEAT', COUNT(*) FROM SEAT
UNION ALL SELECT 'STOP', COUNT(*) FROM STOP
UNION ALL SELECT 'ROUTE', COUNT(*) FROM ROUTE
UNION ALL SELECT 'ROUTE_STOP', COUNT(*) FROM ROUTE_STOP
UNION ALL SELECT 'TRIP', COUNT(*) FROM TRIP
UNION ALL SELECT 'FARE_RULE', COUNT(*) FROM FARE_RULE
UNION ALL SELECT 'FESTIVAL', COUNT(*) FROM FESTIVAL
UNION ALL SELECT 'BOOKING', COUNT(*) FROM BOOKING
UNION ALL SELECT 'PAYMENT', COUNT(*) FROM PAYMENT;
"
```

Use the alias `row_count`, not `rows`.

The expected result is:

```text
PASSENGER   20
COACH_TYPE  10
BUS         20
SEAT        200
STOP        20
ROUTE       10
ROUTE_STOP  100
TRIP        20
FARE_RULE   20
FESTIVAL    10
BOOKING     22
PAYMENT     22
```

If the counts match, the relational database is populated correctly.

---

# Part G — Run the validation script

After the table and row-count checks pass:

```bash
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/04_validation.sql
```

Read the complete validation output and keep screenshots for assignment evidence where appropriate.

---

# Part H — Test the database manually

Open MySQL:

```bash
sudo mysql
```

Then:

```sql
USE modern_db_lab;
SHOW TABLES;
SELECT * FROM PASSENGER LIMIT 5;
SELECT * FROM ROUTE LIMIT 5;
SELECT * FROM BOOKING LIMIT 5;
```

Exit:

```sql
EXIT;
```

---

# Part I — Run the 25 assignment requirements

The folder:

```text
relational/queries/
```

contains:

```text
Q01.sql
Q02.sql
...
Q25.sql
```

Each requirement should be executed against `modern_db_lab`.

## Run one query

For example, if you are in the repository root:

```bash
sudo mysql modern_db_lab < relational/queries/Q01.sql
```

For Q02:

```bash
sudo mysql modern_db_lab < relational/queries/Q02.sql
```

Continue similarly for the queries assigned to you.

Alternatively, open a MySQL session:

```bash
sudo mysql
```

and run:

```sql
USE modern_db_lab;
```

Then paste the SQL from the corresponding Q file.

---

# Part J — Assignment documentation format

For **every analytical/retrieval requirement**, keep the following order in the final report:

1. **Natural-language requirement**
2. **SQL query**
3. **Query output**
4. **Prayogshala evidence/screenshot**, where required

Do not change the natural-language requirement or SQL unnecessarily. If a query needs modification, coordinate with the team first so that the final report remains consistent.

---

# Part K — Evidence to capture

Each team member should retain appropriate Prayogshala evidence for the work they execute.

Recommended evidence includes:

- MySQL service running;
- `modern_db_lab` visible in `SHOW DATABASES`;
- all 12 tables visible in `SHOW TABLES`;
- expected row counts;
- `04_validation.sql` output;
- the assigned Q01–Q25 query outputs;
- screenshots showing important analytical results.

Use the repository's agreed evidence/outputs folders rather than scattering screenshots across the project.

---

# Part L — Important warnings

## Do not reset the database unnecessarily

Before rerunning setup scripts on a VM that already has data, check:

```bash
sudo mysql -e "USE modern_db_lab; SHOW TABLES;"
```

If the database is already populated, **do not blindly rerun the setup scripts**. Depending on the script contents, rerunning setup/data scripts may recreate objects or attempt to insert duplicate data.

Coordinate with the team before resetting an existing VM.

## Do not modify seed data for query execution

The Q01–Q25 requirements are intended to run against the common seeded dataset. Do not insert/update/delete project data merely to make a query produce a desired result.

## Do not change the schema independently

All teammates should use the same relational schema and seed data so that outputs remain comparable and the final report is consistent.

---

# Part M — Troubleshooting

## `Access denied for user 'root'`

Try:

```bash
sudo mysql
```

If that opens MySQL, use `sudo mysql` for all setup scripts.

## MySQL is inactive

```bash
sudo systemctl status mysql
sudo systemctl start mysql
```

Then:

```bash
sudo mysql -e "SELECT VERSION();"
```

## Database exists but tables are missing

Check:

```bash
sudo mysql -e "USE modern_db_lab; SHOW TABLES;"
```

If it is an intentionally fresh VM, run the setup sequence from Part C onward.

## Query gives a syntax error

First confirm that you are using the correct query file and database:

```bash
sudo mysql -e "SELECT DATABASE();"
```

For a command-line query file, use:

```bash
sudo mysql modern_db_lab < relational/queries/Qxx.sql
```

Replace `Qxx` with the actual query number.

---

# Part N — Recommended GitHub structure

Recommended repository layout:

```text
intercity-bus-mds/
├── README.md
├── relational/
│   ├── setup/
│   │   ├── 01_create_database.sql
│   │   ├── 02_create_tables.sql
│   │   ├── 03_insert_data.sql
│   │   └── 04_validation.sql
│   ├── queries/
│   │   ├── Q01.sql
│   │   ├── Q02.sql
│   │   ├── ...
│   │   ├── Q25.sql
│   │   └── README.md
│   ├── outputs/
│   ├── evidence/
│   └── README.md
└── ...
```

The four setup SQL files are the source of truth for creating and seeding the relational database.

---

# Quick Start — Copy/Paste

For a genuinely fresh VM, the complete setup is:

```bash
sudo systemctl status mysql
sudo mysql -e "SELECT VERSION();"
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/01_create_database.sql
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/02_create_tables.sql
sudo mysql -e "USE modern_db_lab; SHOW TABLES;"
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/03_insert_data.sql
sudo mysql -e "USE modern_db_lab; SELECT 'PASSENGER' AS table_name, COUNT(*) AS row_count FROM PASSENGER UNION ALL SELECT 'COACH_TYPE', COUNT(*) FROM COACH_TYPE UNION ALL SELECT 'BUS', COUNT(*) FROM BUS UNION ALL SELECT 'SEAT', COUNT(*) FROM SEAT UNION ALL SELECT 'STOP', COUNT(*) FROM STOP UNION ALL SELECT 'ROUTE', COUNT(*) FROM ROUTE UNION ALL SELECT 'ROUTE_STOP', COUNT(*) FROM ROUTE_STOP UNION ALL SELECT 'TRIP', COUNT(*) FROM TRIP UNION ALL SELECT 'FARE_RULE', COUNT(*) FROM FARE_RULE UNION ALL SELECT 'FESTIVAL', COUNT(*) FROM FESTIVAL UNION ALL SELECT 'BOOKING', COUNT(*) FROM BOOKING UNION ALL SELECT 'PAYMENT', COUNT(*) FROM PAYMENT;"
sudo mysql < ~/workspace/intercity-bus-mds/relational/setup/04_validation.sql
```

After this, the teammate can execute their assigned Q files from `relational/queries/`.
