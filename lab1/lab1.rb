# каталог навчальних курсів

require 'json'
require 'yaml'

STATUSES = ['draft', 'active', 'archived']


def add_course(courses, title, topics, instructors, category,
duration_hours, start_date, end_date, price, status)

    id = courses.keys.max.to_i + 1

    unless STATUSES.include?(status)
        puts "Invalid status, can't add the course"
    else
        courses[id] = {
            title: title,
            topics: topics,
            instructors: instructors,
            category: category,
            duration_hours: duration_hours,
            start_date: start_date,
            end_date: end_date,
            price: price,
            status: status
        }
    end

    courses
end


def edit_course(courses, id, new_data)
    if courses[id]
        courses[id].merge!(new_data)
    else
        puts "Course with ID #{id} not found"
    end

    courses
end


def delete_course(courses, id)
    if courses[id]
        courses.delete(id)
    else
        puts "Course with ID #{id} not found"
    end

    courses
end



def list_courses(courses)
    courses.each do |id, c|
        puts "[#{id}] #{c[:title]} | #{c[:topics].join(', ')} | #{c[:instructors].join(', ')} | #{c[:category]} | #{c[:duration_hours]} hours | #{c[:start_date]} - #{c[:end_date]} | #{c[:price]} грн | #{c[:status]}"
    end
end


def find_by_title(courses, part_title)
    courses.select do |_, c|
        c[:title].downcase.include?(part_title.downcase)
    end
end


def filter_by_category(courses, category)
    courses.select do |_, c|
        c[:category].downcase == category.downcase
    end
end


def filter_by_status(courses, status)
    courses.select do |_, c|
        c[:status].downcase == status.downcase
    end
end


def save_to_json(courses, filename)
    File.write(filename, JSON.pretty_generate(courses))
    puts "Saved in #{filename}"

rescue => e
    puts "Error during saving: #{e.message}"
end


def load_from_json(filename)
    data = JSON.parse(File.read(filename))

    data.transform_keys(&:to_i).transform_values do |v|
        v.transform_keys(&:to_sym)
    end

rescue Errno::ENOENT
    puts "File #{filename} not found"
    {}
end


def save_to_yaml(courses, filename)
    File.write(filename, courses.to_yaml)

    puts "Saved in #{filename}"

rescue => e
    puts "Error during saving: #{e.message}"
end


def load_from_yaml(filename)
    YAML.load_file(filename)

rescue Errno::ENOENT
    puts "File #{filename} not found"
    {}
end



courses = {

1 => {
title: "Ruby on Rails",
topics: ["Ruby basics", "MVC", "Active Record"],
instructors: ["Іван Петренко"],
category: "Програмування",
duration_hours: 40,
start_date: "2024-03-01",
end_date: "2024-05-01",
price: 1500.00,
status: "active"
},

2 => {
title: "UI/UX Design",
topics: ["Figma", "Wireframing", "Prototyping"],
instructors: ["Марія Коваль", "Олег Сидоренко"],
category: "Дизайн",
duration_hours: 30,
start_date: "2024-04-01",
end_date: "2024-06-01",
price: 1200.00,
status: "draft"
}

}


# ПРИКЛАД ВИКОРИСТАННЯ
list_courses(courses)


add_course(
courses,
"Python Basics",
["Syntax", "Loops", "Functions"],
["Олександр Шевченко"],
"Програмування",
25,
"2024-05-01",
"2024-06-15",
1000,
"active"
)


results = find_by_title(courses, "ruby")
p results

design_courses = filter_by_category(courses, "Дизайн")
p design_courses

edit_course(courses, 2, { price: 1300 })

delete_course(courses, 1)

save_to_json(courses, "courses.json")

loaded_courses = load_from_json("courses.json")

puts "Loaded course title: #{loaded_courses[2][:title]}"

save_to_yaml(courses, "courses.yaml")

loaded_courses = load_from_yaml("courses.yaml")

puts "Loaded course start date: #{loaded_courses[2][:start_date]}"