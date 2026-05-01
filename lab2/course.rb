class Course
  attr_accessor :title, :topics, :instructors,
                :category, :duration_hours,
                :start_date, :end_date,
                :price, :status

  def initialize(title, topics, instructors, category,
                 duration_hours, start_date, end_date,
                 price, status = "draft")

    @title = title
    @topics = topics
    @instructors = instructors
    @category = category
    @duration_hours = duration_hours
    @start_date = start_date
    @end_date = end_date
    @price = price
    @status = status
  end

  # для JSON
  def to_h
    {
      title: @title,
      topics: @topics,
      instructors: @instructors,
      category: @category,
      duration_hours: @duration_hours,
      start_date: @start_date,
      end_date: @end_date,
      price: @price,
      status: @status
    }
  end

  # відновлення з JSON
  def self.from_h(hash)
    new(
      hash["title"],
      hash["topics"],
      hash["instructors"],
      hash["category"],
      hash["duration_hours"],
      hash["start_date"],
      hash["end_date"],
      hash["price"],
      hash["status"]
    )
  end
end