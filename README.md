"# mido-db-railways" 
Prerequisites: 
* Ruby 2.2+
* RDBS (MS SQL SERVER preffered)
* Bundlere installed

1. `bundle update`
2. Override `dataserver:` key in db.rb connection, specify `port:` if required
3. Create db objects executing commands in `db_setup/ddl` folder
4. Seed the db executing commands on `db_setup/dml` folder
5. `ruby app.rb`
6. `localhost:4567`
