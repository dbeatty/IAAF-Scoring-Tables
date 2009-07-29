#!/usr/bin/ruby -w

require "iaaf"

def to_seconds(time)
  array = time.split("/[:|.]/")
  array = time.split(":")
  # Reverse the order so seconds are first, then minutes, then hours
  array = array.reverse

  total = 0
  # Convert the time to seconds
  (0..2).each {|i|
    total = total + (array[i].to_f)*(60**i) 
  }
  return total
end

def print_array(array)
  formatted = "x" + array[0].to_s + " = ["
  first = true
  array.each {|entry|
    if not first
      formatted  = formatted + ", "
    else
      first = false
    end

    formatted = formatted + "\"" + entry.to_s + "\""
  }

  formatted = formatted + "]"

  return formatted
end


# All possible event names and their type
event_names = {
  'hj' => 'field',
  'pv' => 'field',
  'lj' => 'field',
  'tj' => 'field',
  'sp' => 'field',
  'dt' => 'field',
  'ht' => 'field',
  'jt' => 'field',
  'decathlon' => 'field',
  'heptathlon' => 'field',

  '2000mSC' => 'long',
  '3000m' => 'long',
  '3000mSC' => 'long',
  '2miles' => 'long',
  '5000m' => 'long',
  '10000m' => 'long',

  '600m' => 'middle',
  '800m' => 'middle',
  '1000m' => 'middle',
  '1500m' => 'middle',
  'mile' => 'middle',
  '2000m' => 'middle',

  '100m' => 'sprints',
  '110mH' => 'sprints',
  '200m' => 'sprints',
  '300m' => 'sprints',
  '400m' => 'sprints',
  '400mH' => 'sprints',
  '4x100m' => 'sprints',
  '4x200m' => 'sprints',
  '4x400m' => 'sprints'
}

# All possible event names and their type
event_columns = {
  'hj' => 1,
  'pv' => 2,
  'lj' => 3,
  'tj' => 4,
  'sp' => 5,
  'dt' => 6,
  'ht' => 7,
  'jt' => 8,
  'decathlon' => 9,
  'heptathlon' => 9,

  '2000mSC' => 1,
  '3000m' => 2,
  '3000mSC' => 3,
  '2miles' => 4,
  '5000m' => 5,
  '10000m' => 6,

  '600m' => 1,
  '800m' => 2,
  '1000m' => 3,
  '1500m' => 4,
  'mile' => 5,
  '2000m' => 6,

  '100m' => 1,
  '110mH' => 2,
  '200m' => 3,
  '300m' => 4,
  '400m' => 5,
  '400mH' => 6,
  '4x100m' => 7,
  '4x200m' => 8,
  '4x400m' => 9
}


# Help
if ARGV[0] == "--h" or ARGV[0] == "--help"
  print "Usage: score_iaaf.rb <gender> <event> <performance in time or distance>\n"
  print "Example: score_iaaf.rb male 400m 43.21\n" 
  print "For valid event names, use --events\n"
  exit(0)
end

if ARGV[0] == "--events"
  for event_name in event_names
    puts event_name[0]
  end
  exit(0)
end


# Gender can be 'male' or 'female'
if not ARGV[0] == "male" and not ARGV[0] == "female"
  print "First agrument must be 'male' or 'female'.  Bad arguments.  Try --h for proper format\n"
  exit(0)
end

gender = ARGV[0]


event_name = ARGV[1]

# Make sure the event name is one we recognize
if not event_names[ARGV[1]]
  print "Unrecognized event name.  Bad arguments.  Try --h for proper format\n"
  exit(0)
end

# Find the event type associated with the given event name
event_type = event_names[ARGV[1]]

# Make sure the distance/time is given in a format we recognize
performance = ARGV[2]
if event_type == "field"
  if performance.to_f == 0.0
    print "Distance in an improper format.  Try --h for proper format\n"
    exit(0)
  else
    performance = performance.to_f
  end
end

# Make sure the distance/time is given in a format we recognize
if event_type != "field"
  #match = (performance =~ /\A<0(x|X)(\d|[a-f]|[A-F])+>/) != nil
  #match = (performance =~ /\A(\d):(\d)(\d).(\d)(\d)/\A)
  #match = (performance =~ /\A(\d):(\d)(\d):(\d)(\d).(\d)(\d)/\A)
  #match = (performance =~ /\A(\d){0,2}.(\d)(\d)\z/)

  # Should be in format xx.xx or xx:xx.xx or xx:xx:xx.xx
  match = (performance =~ /\A((((\d):)?(\d))?(\d):)?(\d){0,2}.(\d)(\d)\z/)

  if not match
    print "Time in an improper format.  Try --h for proper format\n"
    exit(0)
  end

  # Convert the string representation of the time to seconds
  #puts performance
  performance = to_seconds(performance)
  #puts performance

end






if gender == "male" and event_type == "sprints"
  big_array = Iaaf::MENS_SPRINTS # mens_sprints
elsif gender == "male" and event_type == "field"
  big_array = Iaaf::MENS_FIELD # mens_field
elsif gender == "male" and event_type == "middle"
  big_array = Iaaf::MENS_MIDDLE # mens_middle
elsif gender == "male" and event_type == "long"
  big_array = Iaaf::MENS_LONG # mens_long
elsif gender == "female" and event_type == "sprints"
  big_array = Iaaf::WOMENS_SPRINTS # womens_sprints
elsif gender == "female" and event_type == "field"
  big_array = Iaaf::WOMENS_FIELD # womens_field
elsif gender == "female" and event_type == "middle"
  big_array = Iaaf::WOMENS_MIDDLE # womens_middle
elsif gender == "female" and event_type == "long"
  big_array = Iaaf::WOMENS_LONG # womens_long
end

# We want the gender, event name, and time/distance
# Gender can be 'male' or 'female'
# Events for males can be 
# hj pv lj tj sp dt ht jt decathlon
# 2000mSC 3000m 3000mSC 2miles 5000m 10000m
# 600m 800m 1000m 1500m mile 2000m
# 100m 110mH 200m 300m 400m 400mH 4x100m 4x200m 4x400m
#
# 
# hj pv lj tj sp dt ht jt heptathlon
# 2000mSC 3000m 3000mSC 2miles 5000m 10000m
# 600m 800m 1000m 1500m mile 2000m
# 100m 100mH 200m 300m 400m 400mH 4x100m 4x200m 4x400m




# Find the smallest number larger than the target
# Find the largest number smaller than the target

# event types 'sprints', 'middle', and 'long' are track events
track_event = event_type != "field"

target = performance.to_f
column = event_columns[event_name]


x1 = 0
x2 = 0
y1 = 0
y2 = 0

first = true
big_array.each {|array|

  # The first time we iterate through this loop, we get the column labels, so skip it
  if first
    first = false
    next
  end


  # Skip this entry if it doesn't have useful data
  if array[column] == "-"
    next
  end

  # Convert to seconds if it is a timed event, leave alone otherwise
  if track_event
    tmp = to_seconds(array[column])
  else
    tmp = array[column].to_f
  end

  # Try to find the smallest number that is still larger than the target
  if tmp > target
    x1 = tmp
    y1 = array[0].to_f
    if track_event
      break
    end
  end

  # Try to find the largest number that is still smaller than the target
  if tmp < target
    x2 = tmp
    y2 = array[0].to_f
    if not track_event
      break
    end
  end
}

#p "smalger = #{x1}, #{y1}"
#p "largler = #{x2}, #{y2}"
x = target

#y = mx + b
#y = ((y1-y2)/(x1-x2))x + b
b = y1 - ((y1-y2)/(x1-x2))*x1
#p "y = ((#{y1}-#{y2})/(#{x1}-#{x2}))*x + #{b}"


#y = ((1400-1349)/(9.9-10.17))*x + 3270.0
y = ((y1-y2)/(x1-x2))*x + b

# Print the final result
#$stdout << y.round
print y.round.to_s + "\n"

#p big_array

# X - Find the two numbers that are closest to the target number on either side using a 
# binary search algorithm twice



# Find the two numbers that are closest to the target number on either side using a linear
# search algorithm
# Use these points to construct a linear formula
# Solve the formula using our value for x and round to the nearest whole number


# Dead middle overestimates by 6 on the low end (102 when it should have been 96)
# (1295 when it should have been 1295)
# (795 when it should have been a 795)
# (495.5 when it should have been a 495)


# For field events, stop when we find a lower number
# For track events, stop when we find a higher number

# Convert minutes:seconds to seconds
# Create a big array with all events combined (seperately for men and women) 

