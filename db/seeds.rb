# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Client.create([
  {name: "Zesty"},
  {name: "Google"},
  {name: "Pets.com"},
  {name: "Yo"},
  {name: "Enron"}
])

InventoryItem.create([
  {name: "fork",
   description: "multiple metal prongs make this tool a must-have",
   reusable: true},
  {name: "can of cola",
   description: "this will quench your thirst",
   reusable: false},
  {name: "paper plate",
   description: "quite disposable",
   reusable: false},
  {name: "spatula",
   description: "great for serving",
   reusable: true}
 ])
