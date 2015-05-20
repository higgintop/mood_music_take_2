#!/usr/bin/env ruby


class RecommendationsController
  def index(category_index)
    if Recommendation.count_by_mood(category_index) > 0
      recommendations = Recommendation.by_mood(category_index)
      rec_str = ""
      recommendations.each_with_index do |rec, index|
        rec_str << "#{index + 1}. #{rec[0]} by #{rec[1]}\n"
      end
      rec_str
    else
      "No recommendations found.\n"
    end
  end


  def get_selection(category_index, user_selection)
    if Recommendation.count > 0
      recommendations = Recommendation.by_mood(category_index)
      recommendations[user_selection-1]
    else
      nil
    end
  end


  def add_row(song_title, artist, mood_category)
    song_title_clean = song_title.strip
    artist_clean = artist.strip

    rec = Recommendation.new
    rec.song_title = song_title_clean
    rec.artist = artist_clean
    rec.mood_category = mood_category.to_i

    if rec.save
      return "valid"
    else
      rec.errors
    end
  end

  def update_row(new_song_title, new_artist, new_mood_category, id)
    song_title_clean = new_song_title.strip
    artist_clean = new_artist.strip

    rec = Recommendation.new
    rec.song_title = song_title_clean
    rec.artist = artist_clean
    rec.mood_category = new_mood_category.to_i

    if rec.update(id)
      return "valid"
    else
      rec.errors
    end

  end

  def delete_row(id)
    Recommendation.delete(id)
  end

  def is_song_title_valid?(title)
    rec = Recommendation.new
    rec.song_title = title
    return rec.song_title_valid?
  end

  def is_artist_valid?(artist)
    rec = Recommendation.new
    rec.artist = artist
    return rec.artist_valid?
  end

  def is_mood_category_valid?(mood_category)
    rec = Recommendation.new
    rec.mood_category = mood_category.to_i
    return rec.mood_category_valid?
  end

  def list_mood_categories_menu
    choose do |sub_menu|
      sub_menu.prompt=""
      puts "What category would you like to see?"
      sub_menu.choice('happy') do
        response = index(1)
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection(1, choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end
        # at this point have a valid selection
        list_action_options(selection['id'])
      end
      sub_menu.choice('sad') do
        response = index(2)
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection(2, choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end

        # at this point have a valid selection
        list_action_options(selection['id'])

      end
      sub_menu.choice('mellow') do
        response = index(3)
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection(3, choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end

        # at this point have a valid selection
        list_action_options(selection['id'])

      end
      sub_menu.choice('angry') do
        response = index(4)
        if response == "No recommendations found.\n"
          puts response
          list_main_menu
        else
          puts response
          selection = nil
          loop do
            choice = ask("").to_i
            selection = get_selection(4, choice)
            if selection.nil?
              puts "Try again!"
            end
            break if !selection.nil?
          end
        end

        # at this point have a valid selection
        list_action_options(selection['id'])
      end
    end
  end

  def list_action_options(id)

    puts "What would you like to do?"
    choose do |menu|
      menu.prompt = ""

      menu.choice('edit')do
        new_song_title = ""
        new_artist = ""
        new_mood_category = ""
        loop do
          update_song_title = ask("Update song title? [y/n]").upcase
          if update_song_title == 'Y'
            loop do
             new_song_title = ask("Please enter new song title:")
             break if is_song_title_valid?(new_song_title)
            end
          end
          break if update_song_title == 'Y' or update_song_title == 'N'
        end

        loop do
          update_artist = ask("Update song's artist? [y/n]").upcase
          if update_artist == 'Y'
            loop do
             new_artist = ask("Please enter new artist:")
             break if is_artist_valid?(new_artist)
            end
          end
          break if update_artist == 'Y' or update_artist == 'N'
        end

        loop do
          update_mood_category = ask("Update mood category? [y/n]").upcase
          if update_mood_category == 'Y'
            loop do
              new_mood_category = ask("Please enter new mood category:\n1. happy\n2. sad\n3. mellow\n4. angry")
             break if is_mood_category_valid?(new_mood_category)
            end
          end
          break if update_mood_category == 'Y' or update_mood_category == 'N'
        end

        # update unless all options are still blank
        unless new_song_title.empty? and new_artist.empty? and new_mood_category.empty?
          update_row(new_song_title, new_artist, new_mood_category, id)
          puts "Your song recommendation has been saved."
        else
          puts "No changes made."
        end
        list_main_menu
      end
      menu.choice('delete')do
        delete_row(id)
        puts "Your song recommendation has been deleted."
        list_main_menu
      end
      menu.choice('exit'){list_main_menu}
    end
  end
end


