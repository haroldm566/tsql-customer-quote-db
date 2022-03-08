## Run the scripts in this order:

1. CREATE_TABLES.sql (Self-explanatory)
2. ADDED_DESIGN_FEATURES.sql (Create procedures and triggers)
3. PopulateQuoteCompilationWithComponents.sql (Add functions and populate all tables but the ones below)
4. POPULATE_CUSTOMER_AND_QUOTES.sql (Use the created procedures to populate these two tables)

## DROP_TABLES.sql

For debugging. Contains commands for:

- Viewing table data
- Dropping tables, functions and procedures
- Resetting identity column values