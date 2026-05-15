module CoursesHelper
    def status_badge(course)
      css_class = case course.status
      when "draft"    then "badge bg-secondary"
      when "active"   then "badge bg-success"
      when "archived" then "badge bg-dark"
      end
      content_tag(:span, course.status, class: css_class)
    end
end
