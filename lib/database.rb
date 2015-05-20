require 'sqlite3'

# TO DO: make mood table
# id, corresponding mood category

class Database

  def self.load_structure
    Database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS recommendations (
      id integer PRIMARY KEY AUTOINCREMENT,
      song_title varchar(255) NOT NULL,
      artist varchar(255) NOT NULL,
      mood_category integer NOT NULL
    );
    SQL
    Database.execute <<-SQL
    CREATE TABLE IF NOT EXISTS moods (
      id integer PRIMARY KEY AUTOINCREMENT,
      category varchar (150) NOT NULL
    );
    SQL
    Database.execute("INSERT INTO moods(category) SELECT 'happy' WHERE NOT EXISTS(SELECT 1 FROM moods WHERE category='happy')");
    Database.execute("INSERT INTO moods(category) SELECT 'sad' WHERE NOT EXISTS(SELECT 1 FROM moods WHERE category='sad')");
    Database.execute("INSERT INTO moods(category) SELECT 'mellow' WHERE NOT EXISTS(SELECT 1 FROM moods WHERE category='mellow')");
    Database.execute("INSERT INTO moods(category) SELECT 'angry' WHERE NOT EXISTS(SELECT 1 FROM moods WHERE category='angry')");
  end

  def self.execute(*args)
    initialize_database unless defined?(@@db)
    @@db.execute(*args)
  end

  def self.initialize_database
    environment = ENV["TEST"] ? "test" : "production"
    database = "db/mood_music_#{environment}.sqlite"
    @@db = SQLite3::Database.new(database)
    @@db.results_as_hash = true
  end
end
