#!/usr/bin/env ruby

# this is the model - the model interacts with the sqlite db

class Recommendation

  attr_reader :id # should be able to read, but not able to set it!
  attr_accessor :song_title, :artist, :mood_category
  attr_reader :errors

  # dont put all args in initialize - just have setter/getter for each
  def initialize(song_title = nil)
    self.song_title = song_title
  end

  def self.all
    db = Database.execute("SELECT song_title, artist, id FROM recommendations order by song_title ASC")
    # retrieve things in database and populate into an array
    db.map do |row|
      recommendation = Recommendation.new
      recommendation.song_title = row[0]
      recommendation.artist = row[1]
      recommendation
    end
  end

  def self.by_mood(category_index)
    Database.execute("SELECT song_title, artist, id FROM recommendations WHERE mood_category=#{category_index.to_s}")
  end

  def self.count_by_mood(category_index)
    Database.execute("SELECT count(id) FROM recommendations WHERE mood_category=?", category_index)[0][0]
  end
  # class method count
  def self.count
    Database.execute("SELECT count(id) FROM recommendations")[0][0]
  end

  def song_title_valid?
    song_title.strip!
    if song_title.nil? or song_title.empty? or /^\d+$/.match(song_title)
      @errors = "Song title invalid"
      return false
    else
      @errors = nil
      return true
    end
  end

  def artist_valid?
    artist.strip!
    if artist.nil? or artist.empty? or /^\d+$/.match(artist)
      @errors = "Artist invalid"
      return false
    else
      @errors = nil
      return true
    end
  end


  def mood_category_valid?
    if mood_category.nil? or mood_category.to_i < 1 or mood_category.to_i > 4
      @errors = "Mood category invalid"
      return false
    else
      @errors = nil
      return true
    end
  end

  def save
   return false unless (song_title_valid? and artist_valid? and mood_category_valid?)
   Database.execute("INSERT INTO recommendations (song_title, artist, mood_category) VALUES (?,?,?)", song_title, artist, mood_category)
   @id = Database.execute("SELECT last_insert_rowid()")[0]['last_insert_rowid()']
  end

  def update(selection_id)
    if song_title_valid?
      Database.execute("UPDATE recommendations SET song_title=? WHERE id=?", song_title, selection_id)
    end

    if artist_valid?
      Database.execute("UPDATE recommendations SET artist=? WHERE id=?", artist, selection_id)
    end

    if mood_category_valid?
      Database.execute("UPDATE recommendations SET mood_category=? WHERE id=?", mood_category, selection_id)
    end
  end

  def self.find_random_song(mood_id)
    Database.execute("SELECT * FROM recommendations WHERE mood_category=? ORDER BY RANDOM() LIMIT 1", mood_id)[0]
  end

  def self.delete(id)
    Database.execute("DELETE FROM recommendations WHERE id=?", id)
  end

end
