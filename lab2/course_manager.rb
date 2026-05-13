require 'json'
require 'yaml'
require_relative 'course'

class CourseManager

  attr_reader :collection

  def initialize
    @collection = {}
  end

  # ---------- ADD ----------
  def add(course)

    id = (@collection.keys.max || 0) + 1

    @collection[id] = course

    puts "Course added!"
  end

  # ---------- SHOW ----------
  def show_all

    if @collection.empty?
      puts "No courses found."
      return
    end

    @collection.each do |id, course|
      puts "[#{id}] #{course}"
    end
  end

  # ---------- DELETE ----------
  def delete(id)

    if @collection[id]
      @collection.delete(id)
      puts "Course deleted."
    else
      puts "Course not found."
    end
  end

  # ---------- EDIT ----------
  def edit_course(id)

    course = @collection[id]

    if course.nil?
      puts "Course not found."
      return
    end

    puts "Leave blank to keep old value."

    puts "New title:"
    value = gets.chomp.strip
    course.title = value unless value.empty?

    puts "New category:"
    value = gets.chomp.strip
    course.category = value unless value.empty?

    puts "New price:"
    value = gets.chomp.strip

    unless value.empty?

      if value.to_f >= 0
        course.price = value.to_f
      else
        puts "Wrong price."
      end
    end

    puts "New status (draft/active/archived):"
    value = gets.chomp.strip.downcase

    unless value.empty?

      if Course.valid_status?(value)
        course.status = value
      else
        puts "Wrong status."
      end
    end

    puts "Course updated."
  end

  # ---------- SEARCH ----------
  def find_by_title(text)

    result = @collection.select do |_, course|
      course.title.downcase.include?(text.downcase)
    end

    print_collection(result)
  end

  # ---------- FILTER CATEGORY ----------
  def filter_by_category(category)

    result = @collection.select do |_, course|
      course.category.downcase == category.downcase
    end

    print_collection(result)
  end

  # ---------- FILTER STATUS ----------
  def filter_by_status(status)

    result = @collection.select do |_, course|
      course.status.downcase == status.downcase
    end

    print_collection(result)
  end

  # ---------- PRINT COLLECTION ----------
  def print_collection(collection)

    if collection.empty?
      puts "Nothing found."
      return
    end

    collection.each do |id, course|
      puts "[#{id}] #{course}"
    end
  end

  # ---------- YAML ----------
  def save_to_yaml(file)

    File.write(file, @collection.to_yaml)
  end

  def load_from_yaml(file)

    @collection = YAML.unsafe_load_file(file)

  rescue Errno::ENOENT

    @collection = {}
  end

  # ---------- JSON ----------
  def save_to_json(file)

    data = @collection.transform_values(&:to_h)

    File.write(file, JSON.pretty_generate(data))
  end

  def load_from_json(file)

    data = JSON.parse(File.read(file))

    @collection =
      data.transform_keys(&:to_i)
          .transform_values { |v| Course.from_h(v) }

  rescue Errno::ENOENT

    @collection = {}
  end
end