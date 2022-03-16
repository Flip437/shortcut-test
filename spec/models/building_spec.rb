require 'rails_helper'
require 'csv'

RSpec.describe Building, type: :model do
  context "building association" do
    let(:name) { "name" }

    it "should increment backlogs count" do
      building = Building.create(
        reference: "1",
        address: "10 Rue La bruyère",
        zip_code: "75009",
        city: "Paris",
        country: "France",
        manager_name: "Martin Faure")
        expect(Backlog.where(backlogable_type: "Building").count).to eq(building.attributes.count)
    end
    
    it "shouldn't increment backlogs count" do
      building = Building.new(
        reference: "1",
        address: "10 Rue La bruyère",
        zip_code: "75009",
        city: "Paris",
        country: "France",
        manager_name: "Martin Faure")
        expect(Backlog.where(backlogable_type: "Building").count).to eq(0)
    end

    it 'should decrement backlog count' do 
      building = Building.create(
        reference: "1",
        address: "10 Rue La bruyère",
        zip_code: "75009",
        city: "Paris",
        country: "France",
        manager_name: "Martin Faure")
      expect(Backlog.where(backlogable_type: "Building").count).to eq(building.attributes.count)
      building.destroy
      expect(Backlog.where(backlogable_type: "Building").count).to eq(0)

    end

    it "shouldn't decrement backlog count" do 
      building = Building.create(
        reference: "1",
        address: "10 Rue La bruyère",
        zip_code: "75009",
        city: "Paris",
        country: "France",
        manager_name: "Martin Faure")
      expect(Backlog.where(backlogable_type: "Building").count).to eq(building.attributes.count)
      building.delete
      expect(Backlog.where(backlogable_type: "Building").count).to eq(building.attributes.count)

    end
  end


  context "building import" do
    let(:name) { "name" }
    it "should increment Building count" do
      Building.import_csv
      file = "#{Rails.root}/csv_imports/buildings.csv"
      expect(Building.count).to eq(CSV.table(file)[:reference].size)
    end

    it "shouldn't increment Building count" do
      Building.import_csv
      Building.import_csv("_ref1-2") #import other file, with same buildings but other values
      expect(Building.count).to eq(2)
    end

    it "sould increment Building count by one only" do
      Building.import_csv
      expect(Building.count).to eq(2)
      Building.import_csv("_ref1-2-3")
      # tp Building.all
      expect(Building.count).to eq(3)
    end

    it "shouldn't set address back to an old address if address field is tracked" do 
      Building.import_csv #Building.first.address == "10 Rue La bruyère"
      # tp Building.all
      expect(Building.first.address).to eq("10 Rue La bruyère")

      Building.import_csv('_updated_addr') #Now Building.first.address == "10 Rue La bruyère_bis"
      # tp Building.all
      expect(Building.first.address).to eq("10 Rue La bruyère_bis")

      Building.import_csv("", ["address"]) #Finaly Building.first.address == "10 Rue La bruyère_bis" still
      # tp Building.all
      expect(Building.first.address).to eq("10 Rue La bruyère_bis")
    end

    it "should set city back to an old city if city is not tracked or a field different from city is tracked" do 
      Building.import_csv #Building.second.city == "Paris"
      tp Building.all
      expect(Building.second.city).to eq("Paris")

      Building.import_csv('_updated_city') #Now Building.second.city == "Paris_bis"
      tp Building.all
      expect(Building.second.city).to eq("Paris_bis")

      Building.import_csv("", ["address", "country", "manager_name"]) #Finaly Building.second.city == "Paris"
      tp Building.all
      expect(Building.second.city).to eq("Paris")
    end

    it "shouldn't set city back to an old city if city is tracked with other fields" do 
      Building.import_csv #Building.second.city == "Paris"
      tp Building.all
      expect(Building.second.city).to eq("Paris")

      Building.import_csv('_updated_city') #Now Building.second.city == "Paris_bis"
      tp Building.all
      expect(Building.second.city).to eq("Paris_bis")

      Building.import_csv("", ["address", "country", "manager_name", "city"]) #Finaly Building.second.city == "Paris_bis"
      tp Building.all
      expect(Building.second.city).to eq("Paris_bis")
    end
  end

end
