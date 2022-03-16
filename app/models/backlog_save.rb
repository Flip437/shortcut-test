module BacklogSave

  def backlog_save
    self.attributes.each { |key, value| self.backlogs << Backlog.new(attribut_name: key, attribut_value: value) }
  end

end