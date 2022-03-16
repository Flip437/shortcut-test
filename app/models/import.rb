module Import
  require 'csv'

  def import_csv(file_designation="", non_overwritable_attr=[])
    model_name = self.to_s.downcase.pluralize
    file = "#{Rails.root}/csv_imports/#{model_name}#{file_designation}.csv"

    CSV.foreach(file, headers: true) do |row| #avoid loading the entire csv file in memory
      create_or_update(row.to_h, non_overwritable_attr)
    end
  end



  def create_or_update(row_hash, non_overwritable_attr)
    model = self.create_with(row_hash).find_or_create_by(reference: row_hash["reference"])
    if !model.previously_new_record? and non_overwritable_attr.empty? #existing record and no tracked attribut : we can update with the entire row comming from CSV
      model.update(row_hash)
    elsif !model.previously_new_record? and !non_overwritable_attr.empty? #existing record and tracked attributes : we parse the row and collect only overwritable attributes
      new_model_attr = row_hash
      
      non_overwritable_attr.each do |attribut|
        values_of_attribut_backlog = model.backlogs.where(attribut_name: attribut).order(:updated_by).pluck(:attribut_value)
        new_model_attr[attribut] = values_of_attribut_backlog.last if values_of_attribut_backlog.include?(row_hash[attribut])
      end

      model.update(new_model_attr)
    end
  end


end
