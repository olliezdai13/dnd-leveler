# dnd-leveler
CS3200 Final Project: A tool that helps level up your D&amp;D characters.

How to set up database:
1. You need your MySQL service running
2. Using a client like MySQL Workbench, open daiocostichk_finalproject.sql
3. Run the entire script. This generates a new database called "ddcharactermanager" and seeds all the initial data, including 1 sample character.

How to set up application:
1. You need a NodeJS installation on your PC. Go to https://nodejs.org/en/download/ and install NodeJS
2. Clone the git repository (or download the starter code to a folder of your choice)
3. Navigate to project folder in a terminal
4. Run `npm install`. This should install all the dependencies required to run the project into a folder called node_modules.
5. To start the project: `npm start <user> <pass>`. For example: `npm start "root" "password"`
6. Navigate to http://localhost:3000/ to see the interactive webpage