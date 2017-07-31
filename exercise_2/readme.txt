SETUP

Prerequisites
    - Run on EC2 instance using EX2 image:
        AMI Name UCB MIDS W205 EX2-FULL
        AMI ID  ami-d4dd4ec3
    - Setup postgres per lab 2

    - NOTE: Architecture.pdf lists all dependencies.


1. Clone \ checkout this repository

2. Setup database:

    a. # 'psql -U postgres'
    b. Run 'db_setup.sql' to create tcount database with table tweetwordcount
        '\i db_setup.sql'

3. Update database and twitter connection parameters and credentials. 
    a.  Edit /extweetwordcount/src/appCredentials/credentials.py

        For Twitter, update the following values with valid api keys:           
            consumer_key
            consumer_secret
            access_token
            access_token_secret

        For Postgres, update the following values:
            db_name
            db_user
            db_password
            db_host
            db_port
        NOTE: If the database has a default configuration only db_name requires updating.

5. Change directory to extweetwordcount
    a. Run command 'sparse run' - this captures streaming Twitter data and stores it int the database.

    b. Terminate the program after it runs for about 1 minute, press ctrl-C

7. For running serving scripts, use the following commands.
    a. Change directory to the project's top level directory
    b. Run command 'python finalresults.py {word}'. 
    c. Run command 'python histogram.py {#},{#}.
    NOTE: Either script will accept the -h option, This will display additional information


