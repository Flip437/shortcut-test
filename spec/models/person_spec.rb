require 'rails_helper'

RSpec.describe Person, type: :model do
  context "person association" do
    let(:name) { "name" }

    it "should increment backlog count" do
      person = Person.create(
        reference: "1",
        firstname: "Henri",
        lastname: "Dupont",
        home_phone_number: "0123456789",
        mobile_phone_number: "0623456789",
        email: "h.dupont@gmail.com",
        address: "10 Rue La bruyère")
      expect(Backlog.where(backlogable_type: "Person").count).to eq(person.attributes.count)
    end
      
    it "shouldn't increment backlog count" do
      person = Person.new(
        reference: "1",
        firstname: "Henri",
        lastname: "Dupont",
        home_phone_number: "0123456789",
        mobile_phone_number: "0623456789",
        email: "h.dupont@gmail.com",
        address: "10 Rue La bruyère")
      expect(Backlog.where(backlogable_type: "Person").count).to eq(0)
    end

    it 'should decrement backlog count' do 
      person = Person.create(
        reference: "1",
        firstname: "Henri",
        lastname: "Dupont",
        home_phone_number: "0123456789",
        mobile_phone_number: "0623456789",
        email: "h.dupont@gmail.com",
        address: "10 Rue La bruyère")
      expect(Backlog.where(backlogable_type: "Person").count).to eq(person.attributes.count)
      person.destroy
      expect(Backlog.where(backlogable_type: "Person").count).to eq(0)
    end

    it "shouldn't decrement backlog count" do 
      person = Person.create(
        reference: "1",
        firstname: "Henri",
        lastname: "Dupont",
        home_phone_number: "0123456789",
        mobile_phone_number: "0623456789",
        email: "h.dupont@gmail.com",
        address: "10 Rue La bruyère")
      expect(Backlog.where(backlogable_type: "Person").count).to eq(person.attributes.count)
      person.delete
      expect(Backlog.where(backlogable_type: "Person").count).to eq(person.attributes.count)
    end
  end


  context "Person import" do
    let(:name) { "name" }
    it "should increment Person count" do
      Person.import_csv
      file = "#{Rails.root}/csv_imports/people.csv"
      expect(Person.count).to eq(CSV.table(file)[:reference].size)
    end

    it "shouldn't increment Person count" do
      Person.import_csv
      Person.import_csv("_ref1-2") #import other file, same Persons but other values
      expect(Person.count).to eq(2)
    end

    it "sould increment Person count by only 1" do
      Person.import_csv
      expect(Person.count).to eq(2)
      Person.import_csv("_ref1-2-3") #import a file with 3 refs but only one is new
      expect(Person.count).to eq(3)
    end

    it "shouldn't set lastname back to an old lastname if lastname field is tracked" do 
      Person.import_csv #Person.first.lastname == "Dupont"
      expect(Person.first.lastname).to eq("Dupont")

      Person.import_csv('_updated_lastname') #Now Person.first.lastname == "Dupont_bis"
      expect(Person.first.lastname).to eq("Dupont_bis")

      Person.import_csv("", ["lastname"]) #Finaly Person.first.lastname == "Dupont_bis" still, because we track "lastname" field
      expect(Person.first.lastname).to eq("Dupont_bis")
    end

    it "should set email back to an old email if email is not tracked or a field different from email is tracked" do 
      Person.import_csv #Person.second.email == "jdurand@gmail.com"
      expect(Person.second.email).to eq("jdurand@gmail.com")

      Person.import_csv('_updated_email') #Now Person.second.email == "jdurand@gmail.com_bis"
      expect(Person.second.email).to eq("jdurand@gmail.com_bis")

      Person.import_csv("", ["firstname", "lastname", "mobile_phone_number"]) #Finaly Person.second.email == "jdurand@gmail.com"
      expect(Person.second.email).to eq("jdurand@gmail.com")
    end

    it "shouldn't set email back to an old email if email is tracked with other fields" do 
      Person.import_csv #Person.second.email == "jdurand@gmail.com"
      expect(Person.second.email).to eq("jdurand@gmail.com")

      Person.import_csv('_updated_email') #Now Person.second.email == "jdurand@gmail.com_bis"
      expect(Person.second.email).to eq("jdurand@gmail.com_bis")

      Person.import_csv("", ["firstname", "lastname", "mobile_phone_number", "email"]) #Finaly Person.second.email == "jdurand@gmail.com_bis"
      expect(Person.second.email).to eq("jdurand@gmail.com_bis")
    end
  end
  
end
