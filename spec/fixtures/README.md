# GDBM Dump test fixtures

0. Data is stored in `data.rb` as a plain ruby Hash
1. Create a GDBM DB: `ruby spec/fixtures/create_test_db.rb`
2. Create a dump file using gdbm_dump: `gdbm_dump --format=ascii spec/fixtures/test.db spec/fixtures/test.dump`
