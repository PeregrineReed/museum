class Museum

  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def admit(patron)
    @patrons << patron
  end

  def recommend_exhibits(patron)
    @exhibits.find_all do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def patrons_by_exhibit_interest
    exhibit_patrons = {}
    @exhibits.each do |exhibit|
      exhibit_patrons[exhibit] = []
      @patrons.each do |patron|
        if patron.interests.include?(exhibit.name)
          exhibit_patrons[exhibit] << patron
        end
      end
    end
    exhibit_patrons
  end

end
