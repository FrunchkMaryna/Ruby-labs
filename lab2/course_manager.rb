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

  # ---------- LIST ----------
  def list(collection)
    if collection.empty?
      puts "No courses found."
      return
    end

    collection.each do |id, c|
      puts "[#{id}] #{c.title} | #{c.category} | #{c.price} грн | #{c.status}"
    end
  end

  def print
    list(@collection)
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
  def edit(id, new_title)
    if @collection[id]
      @collection[id].title = new_title
      puts "Course updated."
    else
      puts "Course not found."
    end
  end

  # ---------- SEARCH ----------
  def find_by_title(text)
    result = @collection.select do |_, c|
      c.title.downcase.include?(text.downcase)
    end

    if result.empty?
      puts "Nothing found."
    else
      result.each do |id, c|
        puts "[#{id}] #{c.title}"
      end
    end
  end

  def filter_by_category(category)
     @collection.select do |_, c|
      c.category.downcase == category.downcase
    end

    
  end

  def filter_by_status(status)
    result = @collection.select do |_, c|
      c.status.downcase == status.downcase
    end

    result.each do |id, c|
      puts "[#{id}] #{c.title}"
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
    @collection = data.transform_keys(&:to_i)
                      .transform_values { |v| Course.from_h(v) }
  rescue Errno::ENOENT
    @collection = {}
  end
end