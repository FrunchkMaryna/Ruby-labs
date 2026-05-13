require_relative 'course_manager'

manager = CourseManager.new

# ---------- AUTOLOAD ----------
begin

  if File.exist?("courses.yaml")
    manager.load_from_yaml("courses.yaml")

  elsif File.exist?("courses.json")
    manager.load_from_json("courses.json")

  else
    puts "Start with empty list."
  end

rescue => e

  puts "Load error: #{e.message}"
end

# ---------- MENU ----------
begin

loop do

  puts
  puts "1 Add course"
  puts "2 Show courses"
  puts "3 Edit course"
  puts "4 Delete course"
  puts "5 Search by title"
  puts "6 Filter by category"
  puts "7 Filter by status"
  puts "8 Save to JSON"
  puts "0 Exit"

  choice = gets.chomp

  case choice

  # ---------- ADD ----------
  when "1"

    puts "Title:"
    title = gets.chomp.strip

    if title.empty?
      puts "Title cannot be empty."
      next
    end

    puts "Topics (comma separated):"
    topics = gets.chomp.split(",").map(&:strip)

    puts "Instructors (comma separated):"
    instructors = gets.chomp.split(",").map(&:strip)

    puts "Category:"
    category = gets.chomp.strip

    puts "Duration hours:"
    duration = gets.chomp.to_i

    if duration <= 0
      puts "Wrong duration."
      next
    end

    puts "Start date:"
    start_date = gets.chomp.strip

    puts "End date:"
    end_date = gets.chomp.strip

    puts "Price:"
    price = gets.chomp.to_f

    if price < 0
      puts "Wrong price."
      next
    end

    puts "Status #{Course::Status.join(', ')}"
    status = gets.chomp.strip.downcase

    course = Course.new(
      title,
      topics,
      instructors,
      category,
      duration,
      start_date,
      end_date,
      price,
      status
    )

    manager.add(course)

  # ---------- SHOW ----------
  when "2"

    manager.show_all

  # ---------- EDIT ----------
  when "3"

    puts "Enter ID:"
    id = gets.chomp.to_i

    manager.edit_course(id)

  # ---------- DELETE ----------
  when "4"

    puts "Enter ID:"
    id = gets.chomp.to_i

    manager.delete(id)

  # ---------- SEARCH ----------
  when "5"

    puts "Enter title:"
    text = gets.chomp

    manager.find_by_title(text)

  # ---------- FILTER CATEGORY ----------
  when "6"

    puts "Enter category:"
    category = gets.chomp

    manager.filter_by_category(category)

  # ---------- FILTER STATUS ----------
  when "7"

    puts "Enter status:"
    status = gets.chomp

    manager.filter_by_status(status)

  # ---------- SAVE JSON ----------
  when "8"

    manager.save_to_json("courses.json")

    puts "Saved to JSON."

  # ---------- EXIT ----------
  when "0"

    break

  else

    puts "Wrong choice."
  end
end

# ---------- AUTOSAVE ----------
ensure

  manager.save_to_yaml("courses.yaml")

  puts "Saved automatically."
end