require_relative 'course_manager'

manager = CourseManager.new

VALID_STATUSES = ["draft", "active", "archived"]

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
    if category.empty?
      puts "Category cannot be empty."
      next
    end

    puts "Duration hours:"
    duration = gets.chomp.to_i
    if duration <= 0
      puts "Duration must be greater than 0."
      next
    end

    puts "Start date:"
    start_date = gets.chomp.strip

    puts "End date:"
    end_date = gets.chomp.strip

    puts "Price:"
    price = gets.chomp.to_f
    if price < 0
      puts "Price cannot be negative."
      next
    end

    puts "Status (draft/active/archived):"
    status = gets.chomp.strip.downcase

    unless VALID_STATUSES.include?(status)
      puts "Wrong status. Set to draft."
      status = "draft"
    end

    course = Course.new(
      title, topics, instructors, category,
      duration, start_date, end_date,
      price, status
    )

    manager.add(course)

  # ---------- LIST ----------
  when "2"
    manager.list

  # ---------- EDIT ----------
  when "3"
    puts "Enter ID:"
    id = gets.chomp.to_i

    if manager.collection[id].nil?
      puts "Course not found."
      next
    end

    course = manager.collection[id]

    puts "Leave blank to keep current value"

    puts "New title:"
    value = gets.chomp.strip
    course.title = value unless value.empty?

    puts "New category:"
    value = gets.chomp.strip
    course.category = value unless value.empty?

    puts "New price:"
    value = gets.chomp.strip
    if !value.empty?
      new_price = value.to_f
      if new_price >= 0
        course.price = new_price
      else
        puts "Wrong price. Old value saved."
      end
    end

    puts "New status (draft/active/archived):"
    value = gets.chomp.strip.downcase

    if !value.empty?
      if VALID_STATUSES.include?(value)
        course.status = value
      else
        puts "Wrong status. Old value saved."
      end
    end

    puts "Course updated."

  # ---------- DELETE ----------
  when "4"
    puts "Enter ID:"
    id = gets.chomp.to_i
    manager.delete(id)

  # ---------- SEARCH ----------
  when "5"
    puts "Enter title:"
    txt = gets.chomp
    manager.find_by_title(txt)

  when "6"
    puts "Enter category:"
    txt = gets.chomp
    manager.filter_by_category(txt)

  when "7"
    puts "Enter status:"
    txt = gets.chomp
    manager.filter_by_status(txt)

  when "8"
    manager.save_to_json("courses.json")
    puts "Saved to JSON."

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