# dnd-leveler
CS3200 Final Project: A tool that helps level up your D&amp;D characters.

Set up the project folder

1. Download daiocostichk_project.zip 
2. Extract the files to a folder. This is the project folder.

How to set up the database:

1. You need your MySQL service running
2. Using a client like MySQL Workbench, open daiocostichk_finalproject.sql, found inside of the project folder. This contains all the hand-written SQL that was used to build our database. 
3. Alternatively, you can open our database dump file that is included in the project submission. The dump file was auto-generated from our complete database using MySQL Workbench’s data export feature. 
4. Run the entire script. This generates a new database called "ddcharactermanager" and seeds all the initial data, including 1 sample character.

How to set up the application:

1. You need a NodeJS installation on your PC. Go to https://nodejs.org/en/download/ and install NodeJS
2. Navigate to project folder in a terminal
3. Run `npm install`. This should install all the dependencies required to run the project into a folder called node_modules.
4. To start the project: `npm start <user> <pass>`. For example: `npm start "root" "password"`
5. Navigate to http://localhost:3000/ to see the interactive webpage
