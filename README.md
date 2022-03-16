# README

Hello,
here is the app I ended with for the test.

How is it working:
I create a method called import_csv that takes 2 optionnal arguments:
- file extension to select wich file in ../csv_imports folder you want to import
- an array on fields you do not want to overwrite at each import. I call them "tracked" fields. For example if you do not want to overwrite the "adress" and the "city" field for Building model, just pass ["adress", "city"] to the second argument of import_csv method.
I created a Backlog model that store all different values of all attributes for any model plugged to that Backlog model.

STEPS:
1. bundle install
2. rails db:migrate
3. rails c
4. Building.import_csv
5. tp Building.all display all Buildings
6. tp Backlog.all display the Backlog we save for each Building.

MANUAL TESTS:
1. open ../csv_imports/buildings.csv
2. rails c
3. Building.import_csv
4. tp Building.all
5. Modify first building city with Lyon for example and save buildings.csv
6. Building.import_csv
7. tp Building.all : first building city is Lyon
8. Set first building city back to Paris and save buildings.csv
9. Building.import_csv("", ["city"])
10. tp Buildgin.all : you can see that first building city is still Lyon. We did not overwrite the city because Paris was in the backlog for that building and we specified that we were tracking city field in the last import.

RSPEC TESTS
to Run RSpec test, execute bundle exec rpsec at root. 


Have fun :)
Philippe