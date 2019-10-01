def string_to_datetime(date, time, ampm)
    date = date.split("-")
    time = time.split(":")
    hours = time[0].to_i
    if ampm == "PM" && hours != 12 
        hours += 12
    elsif ampm == "AM" && hours == 12
        hours = 0
    end
    date_and_time = Time.utc(date[0].to_i, date[1].to_i, date[2].to_i, hours, time[1].to_i)
end