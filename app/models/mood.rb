

# Mood Model
class Mood
  attr_reader :id, :errors
  attr_accessor :category # happy/sad/mellow/angry

  def initialize(category)
    @category = category
  end

  def get_category_id
    @id = Database.execute("SELECT id FROM moods where category=?", category)[0]['id']
  end
end
