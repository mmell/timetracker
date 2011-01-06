module Reports
class Daily < Base
  
  Day = Struct.new(:category_minutes, :activities)
  
  def self.file_ext
    'csv'
  end
  
  def file_ext
    Daily.file_ext
  end
  
  def add_header_lines
    arr = [''] + days
    add_line( arr )
    add_blank_line
  end

  def add_final_totals_lines()
    activity_row = ['']
    days.each { |day| 
      activity_row << @data[day].activities.uniq.join("\n")
    }
    add_line( activity_row)
    
    add_blank_line
    add_line( [
      '', 'total hours', total_hours
    ] )
    @client.work_categories.keys.sort.each { |e| 
      add_line( [
        '', "hours (#{e})", total_hours(e)
      ] )
    }
    add_blank_line
    add_line( ['', 'Report generated at', Time.now.to_s] )
  end

  def total_hours(category = 'all')
    format_hours(@data.each_value.inject(0) { |memo, e| memo + e.category_minutes[category] } / 60.0) 
  end
  
  def days 
    @data.keys.sort
  end
  
  def format_date(d)
    d.strftime('%m/%d/%Y')
  end 
  
  def format_activity(a)
    "(#{a.project.work_category}) #{a.project.name} #{a.project.url}".strip
  end 
  
  def initialize(start_date, end_date, activities)
    super(start_date, end_date, activities)
    @data = {} # FAILS: Hash.new(Summary.new(0, nil))
    @client = activities.first.project.client
    
    d = start_date
    while d <= end_date
      @data[format_date(d)] = Day.new(Hash.new(0), [])
      d += 1.day
    end

    add_header_lines

    activities.each { |activity|
      day, category = format_date(activity.stopped), activity.project.work_category
      @data[day].category_minutes['all'] += activity.minutes
      @data[day].category_minutes[category] += activity.minutes
      @data[day].activities << format_activity(activity)
    }
    
    add_blank_line
    
    @client.work_categories.keys.sort.each { |category|
      category_row = [category]
      days.each { |day| 
        category_row << format_hours(@data[day].category_minutes[category] / 60.0)
      }
      add_line( category_row )
    }

    add_final_totals_lines
  end
  
  def render
    @lines.map { |e| CSV.generate_line( e ) }.join('')
  end
  
end
end
