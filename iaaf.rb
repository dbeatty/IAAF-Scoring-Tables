module Iaaf

  def Iaaf.say()
    puts "Doug is cool"
  end

  def Iaaf.score_to_performance(gender, event_name, points)

    event_type = EVENT_NAMES[event_name]

    if gender == "male" and event_type == "sprints"
      big_array = MENS_SPRINTS # mens_sprints
    elsif gender == "male" and event_type == "field"
      big_array = MENS_FIELD # mens_field
    elsif gender == "male" and event_type == "middle"
      big_array = MENS_MIDDLE # mens_middle
    elsif gender == "male" and event_type == "long"
      big_array = MENS_LONG # mens_long
    elsif gender == "female" and event_type == "sprints"
      big_array = WOMENS_SPRINTS # womens_sprints
    elsif gender == "female" and event_type == "field"
      big_array = WOMENS_FIELD # womens_field
    elsif gender == "female" and event_type == "middle"
      big_array = WOMENS_MIDDLE # womens_middle
    elsif gender == "female" and event_type == "long"
      big_array = WOMENS_LONG # womens_long
    end



    track_event = event_type != "field"
    
    target = points.to_i
    event_column = EVENT_COLUMNS[event_name]
    column = 0


    x1 = 0
    x2 = 0
    y1 = 0
    y2 = 0
    
    index1 = 0
    index2 = big_array.size

    counter = 0
    first = true
    big_array.each {|array|

      # The first time we iterate through this loop, we get the column labels, so skip it
      if first
        first = false
        counter = counter + 1
        next
      end


      # Skip this entry if it doesn't have useful data
      if array[EVENT_COLUMNS[event_name]] == "-"
        counter = counter + 1
        next
      end

      # Get the points value
      tmp = array[column].to_f
  
      # Try to find the smallest number that is still larger than the target
      if tmp > target
        index1 = counter
      end
  
      # Try to find the largest number that is still smaller than the target
      if tmp < target
        index2 = counter
        break
      end

      counter = counter + 1
    }


    x1 = big_array[index1][column].to_f
    x2 = big_array[index2][column].to_f

    if track_event
      y1 = to_seconds(big_array[index1][EVENT_COLUMNS[event_name]])
      y2 = to_seconds(big_array[index2][EVENT_COLUMNS[event_name]])
    else
      y1 = big_array[index1][EVENT_COLUMNS[event_name]].to_f
      y2 = big_array[index2][EVENT_COLUMNS[event_name]].to_f
    end

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
    #p (y*100).round / 100.0
    performance = (y*100).round / 100.0
    if track_event
      performance = to_h_m_s(performance)
    end
    #$stdout << performance
    #print performance + "\n"
    
    return performance.to_s

  end




  def Iaaf.performance_to_score(gender, event_name, performance)
    
    event_type = EVENT_NAMES[event_name]


    if gender == "male" and event_type == "sprints"
      big_array = MENS_SPRINTS # mens_sprints
    elsif gender == "male" and event_type == "field"
      big_array = MENS_FIELD # mens_field
    elsif gender == "male" and event_type == "middle"
      big_array = MENS_MIDDLE # mens_middle
    elsif gender == "male" and event_type == "long"
      big_array = MENS_LONG # mens_long
    elsif gender == "female" and event_type == "sprints"
      big_array = WOMENS_SPRINTS # womens_sprints
    elsif gender == "female" and event_type == "field"
      big_array = WOMENS_FIELD # womens_field
    elsif gender == "female" and event_type == "middle"
      big_array = WOMENS_MIDDLE # womens_middle
    elsif gender == "female" and event_type == "long"
      big_array = WOMENS_LONG # womens_long
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
    
    if track_event
      performance = to_seconds(performance)
    end

    target = performance.to_f
    column = EVENT_COLUMNS[event_name]
    
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
    score = y.round.to_s
    #print score + "\n"

    return score.to_s


  end





def Iaaf.to_seconds(time)
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

def Iaaf.to_h_m_s(seconds)
  array = []

  while seconds > 0
    divmod = seconds.divmod(60)
    array = array << divmod[1]
    seconds = divmod[0].to_i
  end
  
  (0...array.size-1).each {|i|
    if array[i] < 10
      array[i] = "0" + array[i].to_s
    end
  }

  array = array.reverse

  return array.join(":")
end


def Iaaf.short_to_long_name(event)

iaaf_event_names  = {}

iaaf_event_names['1000m'] = '10,000 Meters'
iaaf_event_names['100m'] = '100 Metres'
iaaf_event_names['100mH'] = '100 Metres Hurdles'
iaaf_event_names['110mH'] = '110 Metres Hurdles'
iaaf_event_names['1500m'] = '1500 Metres'
iaaf_event_names['200m'] = '200 Metres'
iaaf_event_names['3000mSC'] = '3000 Metres Steeplechase'
iaaf_event_names['400m'] = '400 Metres'
iaaf_event_names['400mH'] = '400 Metres Hurdles'
iaaf_event_names['4x100'] = '4x100 Metres Relay'
iaaf_event_names['4x400'] = '4x400 Metres Relay'
iaaf_event_names['5000m'] = '5000 Metres'
iaaf_event_names['800m'] = '800 Metres'
iaaf_event_names['decathlon'] = 'Decathlon'
iaaf_event_names['dt'] = 'Discus Throw'
iaaf_event_names['ht'] = 'Hammer Throw'
iaaf_event_names['heptathlon'] = 'Heptathlon'
iaaf_event_names['hj'] = 'High Jump'
iaaf_event_names['jt'] = 'Javelin Throw'
iaaf_event_names['lj'] = 'Long Jump'
iaaf_event_names['pv'] = 'Pole Vault'
iaaf_event_names['sp'] = 'Shot Put'
iaaf_event_names['tj'] = 'Triple Jump'

  return iaaf_event_names[event]

end

def Iaaf.records()

  records = {}
  
  records['100m'] = {}
records['200m'] = {}
records['400m'] = {}
records['800m'] = {}
records['1500m'] = {}
records['5000m'] = {}
records['10000m'] = {}
records['3000mSC'] = {}
records['110mH'] = {}
records['400mH'] = {}
records['hj'] = {}
records['pv'] = {}
records['lj'] = {}
records['tj'] = {}
records['sp'] = {}
records['dt'] = {}
records['ht'] = {}
records['jt'] = {}
records['decathlon'] = {}
records['100m'] = {}
records['200m'] = {}
records['400m'] = {}
records['800m'] = {}
records['1500m'] = {}
records['5000m'] = {}
records['10000m'] = {}
records['3000mSC'] = {}
records['100mH'] = {}
records['400mH'] = {}
records['hj'] = {}
records['pv'] = {}
records['lj'] = {}
records['tj'] = {}
records['sp'] = {}
records['dt'] = {}
records['ht'] = {}
records['jt'] = {}
records['heptathlon'] = {}

records['100m']['male'] = {}
records['200m']['male'] = {}
records['400m']['male'] = {}
records['800m']['male'] = {}
records['1500m']['male'] = {}
records['5000m']['male'] = {}
records['10000m']['male'] = {}
records['3000mSC']['male'] = {}
records['110mH']['male'] = {}
records['400mH']['male'] = {}
records['hj']['male'] = {}
records['pv']['male'] = {}
records['lj']['male'] = {}
records['tj']['male'] = {}
records['sp']['male'] = {}
records['dt']['male'] = {}
records['ht']['male'] = {}
records['jt']['male'] = {}
records['decathlon']['male'] = {}
records['100m']['female'] = {}
records['200m']['female'] = {}
records['400m']['female'] = {}
records['800m']['female'] = {}
records['1500m']['female'] = {}
records['5000m']['female'] = {}
records['10000m']['female'] = {}
records['3000mSC']['female'] = {}
records['100mH']['female'] = {}
records['400mH']['female'] = {}
records['hj']['female'] = {}
records['pv']['female'] = {}
records['lj']['female'] = {}
records['tj']['female'] = {}
records['sp']['female'] = {}
records['dt']['female'] = {}
records['ht']['female'] = {}
records['jt']['female'] = {}
records['heptathlon']['female'] = {}

  
records['10000m']['female']['cr_performance'] = '30:04.20'
records['10000m']['female']['cr_score'] = ['1266']
records['10000m']['female']['wr_performance'] = ['29:31.80']
records['10000m']['female']['wr_score'] = ['1297']
records['10000m']['female']['wr_score'] = '1297'
records['10000m']['male']['cr_performance'] = ['26:49.60']
records['10000m']['male']['cr_score'] = ['1254']
records['10000m']['male']['wr_performance'] = ['26:17.50']
records['10000m']['male']['wr_performance'] = '26:17.50'
records['10000m']['male']['wr_score'] = ['1307']
records['10000m']['male']['wr_score'] = '1307'
records['100m']['female']['cr_performance'] = ['10.70']
records['100m']['female']['cr_score'] = ['1251']
records['100m']['female']['wr_performance'] = ['10.49']
records['100m']['female']['wr_score'] = ['1289']
records['100m']['female']['wr_score'] = '1289'
records['100m']['male']['cr_performance'] = ['9.80']
records['100m']['male']['cr_score'] = ['1289']
records['100m']['male']['wr_performance'] = ['9.77']
records['100m']['male']['wr_performance'] = '9.77'
records['100m']['male']['wr_score'] = ['1301']
records['100m']['male']['wr_score'] = '1301'
records['100mH']['female']['cr_performance'] = ['12.34']
records['100mH']['female']['cr_score'] = ['1237']
records['100mH']['female']['wr_performance'] = ['12.21']
records['100mH']['female']['wr_score'] = ['1254']
records['100mH']['female']['wr_score'] = '1254'
records['110mH']['male']['cr_performance'] = ['12.91']
records['110mH']['male']['cr_score'] = ['1270']
records['110mH']['male']['wr_performance'] = ['12.88']
records['110mH']['male']['wr_performance'] = '12.88'
records['110mH']['male']['wr_score'] = ['1275']
records['110mH']['male']['wr_score'] = '1275'
records['1500m']['female']['cr_performance'] = ['03:58.50']
records['1500m']['female']['cr_score'] = ['1218']
records['1500m']['female']['wr_performance'] = ['03:50.50']
records['1500m']['female']['wr_score'] = ['1284']
records['1500m']['female']['wr_score'] = '1284'
records['1500m']['male']['cr_performance'] = ['03:27.60']
records['1500m']['male']['cr_score'] = ['1280']
records['1500m']['male']['wr_performance'] = ['03:26.00']
records['1500m']['male']['wr_performance'] = '03:26.00'
records['1500m']['male']['wr_score'] = ['1303']
records['1500m']['male']['wr_score'] = '1303'
records['200m']['female']['cr_performance'] = ['21.74']
records['200m']['female']['cr_score'] = ['1252']
records['200m']['female']['wr_performance'] = ['21.34']
records['200m']['female']['wr_score'] = ['1284']
records['200m']['female']['wr_score'] = '1284'
records['200m']['male']['cr_performance'] = ['19.79']
records['200m']['male']['cr_score'] = ['1261']
records['200m']['male']['wr_performance'] = ['19.32']
records['200m']['male']['wr_performance'] = '19.32'
records['200m']['male']['wr_score'] = ['1335']
records['200m']['male']['wr_score'] = '1335'
records['3000mSC']['female']['cr_performance'] = ['09:18.20']
records['3000mSC']['female']['cr_score'] = ['1176']
records['3000mSC']['female']['wr_performance'] = ['09:01.60']
records['3000mSC']['female']['wr_score'] = ['1217']
records['3000mSC']['female']['wr_score'] = '1217'
records['3000mSC']['male']['cr_performance'] = ['08:04.20']
records['3000mSC']['male']['cr_score'] = ['1243']
records['3000mSC']['male']['wr_performance'] = ['07:53.60']
records['3000mSC']['male']['wr_performance'] = '07:53.60'
records['3000mSC']['male']['wr_score'] = ['1293']
records['3000mSC']['male']['wr_score'] = '1293'
records['400m']['female']['cr_performance'] = ['47.99']
records['400m']['female']['cr_score'] = ['1272']
records['400m']['female']['wr_performance'] = ['47.60']
records['400m']['female']['wr_score'] = ['1286']
records['400m']['female']['wr_score'] = '1286'
records['400m']['male']['cr_performance'] = ['43.18']
records['400m']['male']['cr_score'] = ['1300']
records['400m']['male']['wr_performance'] = ['43.18']
records['400m']['male']['wr_performance'] = '43.18'
records['400m']['male']['wr_score'] = ['1300']
records['400m']['male']['wr_score'] = '1300'
records['400mH']['female']['cr_performance'] = ['52.61']
records['400mH']['female']['cr_score'] = ['1249']
records['400mH']['female']['wr_performance'] = ['52.34']
records['400mH']['female']['wr_score'] = ['1258']
records['400mH']['female']['wr_score'] = '1258'
records['400mH']['male']['cr_performance'] = ['47.18']
records['400mH']['male']['cr_score'] = ['1264']
records['400mH']['male']['wr_performance'] = ['46.78']
records['400mH']['male']['wr_score'] = ['1284']
records['400mH']['male']['wr_score'] = '1284'
records['5000m']['female']['cr_performance'] = ['14:38.60']
records['5000m']['female']['cr_score'] = ['1230']
records['5000m']['female']['wr_performance'] = ['14:16.60']
records['5000m']['female']['wr_score'] = ['1275']
records['5000m']['female']['wr_score'] = '1275'
records['5000m']['male']['cr_performance'] = ['12:52.80']
records['5000m']['male']['cr_score'] = ['1246']
records['5000m']['male']['wr_performance'] = ['12:37.40']
records['5000m']['male']['wr_performance'] = '12:37.40'
records['5000m']['male']['wr_score'] = ['1305']
records['5000m']['male']['wr_score'] = '1305'
records['800m']['female']['cr_performance'] = ['01:54.70']
records['800m']['female']['cr_score'] = ['1250']
records['800m']['female']['wr_performance'] = ['01:53.30']
records['800m']['female']['wr_score'] = ['1276']
records['800m']['female']['wr_score'] = '1276'
records['800m']['male']['cr_performance'] = ['01:43.10']
records['800m']['male']['cr_score'] = ['1229']
records['800m']['male']['wr_performance'] = ['01:41.10']
records['800m']['male']['wr_performance'] = '01:41.10'
records['800m']['male']['wr_score'] = ['1291']
records['800m']['male']['wr_score'] = '1291'
records['decathlon']['male']['cr_performance'] = ['8902']
records['decathlon']['male']['cr_score'] = ['1249']
records['decathlon']['male']['wr_performance'] = ['9026']
records['decathlon']['male']['wr_score'] = ['1268']
records['decathlon']['male']['wr_score'] = '1268'
records['dt']['female']['cr_performance'] = ['71.62']
records['dt']['female']['cr_score'] = ['1258']
records['dt']['female']['wr_performance'] = ['76.8']
records['dt']['female']['wr_score'] = ['1355']
records['dt']['female']['wr_score'] = '1355'
records['dt']['male']['cr_performance'] = ['70.17']
records['dt']['male']['cr_score'] = ['1243']
records['dt']['male']['wr_performance'] = ['74.08']
records['dt']['male']['wr_score'] = ['1317']
records['dt']['male']['wr_score'] = '1317'
records['heptathlon']['female']['cr_performance'] = ['7128']
records['heptathlon']['female']['cr_score'] = ['1317']
records['heptathlon']['female']['wr_performance'] = ['7291']
records['heptathlon']['female']['wr_score'] = ['1349']
records['heptathlon']['female']['wr_score'] = '1349'
records['hj']['female']['cr_performance'] = ['2.09']
records['hj']['female']['cr_score'] = ['1292']
records['hj']['female']['wr_performance'] = ['2.09']
records['hj']['female']['wr_score'] = ['1292']
records['hj']['female']['wr_score'] = '1292'
records['hj']['male']['cr_performance'] = ['2.4']
records['hj']['male']['cr_score'] = ['1256']
records['hj']['male']['wr_performance'] = ['2.45']
records['hj']['male']['wr_score'] = ['1306']
records['hj']['male']['wr_score'] = '1306'
records['ht']['female']['cr_performance'] = ['75.2']
records['ht']['female']['wr_score'] = '1245'
records['ht']['male']['wr_score'] = '1286'
records['jt']['female']['wr_score'] = '1269'
records['jt']['male']['wr_score'] = '1346'
records['lj']['female']['wr_score'] = '1308'
records['lj']['male']['wr_score'] = '1328'
records['pv']['female']['wr_score'] = '1263'
records['pv']['male']['wr_score'] = '1297'
records['sp']['female']['wr_score'] = '1327'
records['sp']['male']['wr_score'] = '1308'
records['tj']['female']['wr_score'] = '1254'
records['tj']['male']['wr_score'] = '1296'

  return records

end


def Iaaf.event_to_day(event)
  
  event_day = {}
  
event_day['Marathon'] = 1
event_day['Shot Put'] = 1
event_day['10,000 Meters'] = 1

event_day['20 Kilometres Race Walk'] = 2
event_day['Shot Put'] = 2
event_day['100 Metres'] = 2
event_day['Heptathlon'] = 2

event_day['Hammer Throw'] = 3
event_day['3000 Metres Steeplechase'] = 3
event_day['Triple Jump'] = 3
event_day['10,000 Metres'] = 3
event_day['100 Metres'] = 3

event_day['Pole Vault'] = 4
event_day['Discus Throw'] = 4
event_day['Long Jump'] = 4
event_day['3000 Metres Steeplechase'] = 4
event_day['800 Metres'] = 4
event_day['400 Metres Hurdles'] = 4

event_day['Discus Throw'] = 5
event_day['High Jump'] = 5
event_day['100 Metres Hurdles'] = 5
event_day['400 Metres'] = 5
event_day['1500 Metres'] = 5

#event_day['Day 6'] = ''
event_day['Hammer Throw'] = 6
event_day['400 Metres Hurdles'] = 6
event_day['Long Jump'] = 6
event_day['200 Metres'] = 6

#event_day['Day 7'] = ''
event_day['20 Kilometres Race Walk'] = 7
event_day['Triple Jump'] = 7
event_day['Javelin Throw'] = 7
event_day['200 Metres'] = 7
event_day['400 Metres'] = 7
event_day['110 Metres Hurdles'] = 7

#event_day['Day 8'] = ''
event_day['50 Kilometres Race Walk'] = 8
event_day['1500Wheelchair'] = 8
event_day['1500Wheelchair'] = 8
event_day['Pole Vault'] = 8
event_day['5000 Metres'] = 8
event_day['4x100 Metres Relay'] = 8
event_day['4x100 Metres Relay'] = 8
event_day['Decathlon'] = 8

#event_day['Day 9'] = ''
event_day['Marathon'] = 9
event_day['High Jump'] = 9
event_day['5000 Metres'] = 9
event_day['Javelin Throw'] = 9
event_day['800 Metres'] = 9
event_day['1500 Metres'] = 9
event_day['4x400 Metres Relay'] = 9
event_day['4x400 Metres Relay'] = 9

return event_day[event]

end


def Iaaf.place_to_points(place)
  
  points = []
  
  points[0] = 100
  points[1] = 75
  points[2] = 50
  points[3] = 40
  points[4] = 30
  points[5] = 20
  points[6] = 10
  points[7] = 5
  
  return points[place]

end


def Iaaf.long_to_short_name(event)

iaaf_event_names  = {}

iaaf_event_names['10,000 Meters'] = '1000m'
iaaf_event_names['100 Metres'] = '100m'
iaaf_event_names['100 Metres Hurdles'] = '100mH'
iaaf_event_names['110 Metres Hurdles'] = '110mH'
iaaf_event_names['1500 Metres'] = '1500m'
iaaf_event_names['20 Kilometres Race Walk'] = ''
iaaf_event_names['200 Metres'] = '200m'
iaaf_event_names['3000 Metres Steeplechase'] = '3000mSC'
iaaf_event_names['400 Metres'] = '400m'
iaaf_event_names['400 Metres Hurdles'] = '400mH'
iaaf_event_names['4x100 Metres Relay'] = '4x100'
iaaf_event_names['4x400 Metres Relay'] = '4x400'
iaaf_event_names['50 Kilometres Race Walk'] = ''
iaaf_event_names['5000 Metres'] = '5000m'
iaaf_event_names['800 Metres'] = '800m'
iaaf_event_names['Decathlon'] = 'decathlon'
iaaf_event_names['Discus Throw'] = 'dt'
iaaf_event_names['Hammer Throw'] = 'ht'
iaaf_event_names['Heptathlon'] = 'heptathlon'
iaaf_event_names['High Jump'] = 'hj'
iaaf_event_names['Javelin Throw'] = 'jt'
iaaf_event_names['Long Jump'] = 'lj'
iaaf_event_names['Marathon'] = ''
iaaf_event_names['Pole Vault'] = 'pv'
iaaf_event_names['Shot Put'] = 'sp'
iaaf_event_names['Triple Jump'] = 'tj'
  
  return iaaf_event_names[event]
  
end



# All possible event names and their type
EVENT_NAMES = {
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
  '100mH' => 'sprints',
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
EVENT_COLUMNS = {
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
  '100mH' => 2,
  '110mH' => 2,
  '200m' => 3,
  '300m' => 4,
  '400m' => 5,
  '400mH' => 6,
  '4x100m' => 7,
  '4x200m' => 8,
  '4x400m' => 9
}

  



xpoints = ["points", "hj", "pv", "lj", "tj", "sp", "dt", "ht", "jt", "heptathlon"]
x1400 = ["1400", "-", "5.40", "-", "16.86", "23.79", "79.19", "87.77", "78.61", "7547"]
x1399 = ["1399", "-", "-", "7.93", "16.85", "23.77", "79.13", "87.71", "78.56", "7542"]
x1398 = ["1398", "-", "-", "-", "-", "23.75", "79.08", "87.65", "78.51", "7537"]
x1397 = ["1397", "-", "5.39", "-", "16.84", "23.74", "79.03", "87.60", "78.45", "7532"]
x1396 = ["1396", "-", "-", "7.92", "16.83", "23.72", "78.97", "87.54", "78.40", "7527"]
x1395 = ["1395", "-", "-", "-", "16.82", "23.71", "78.92", "87.48", "78.35", "7522"]
x1394 = ["1394", "-", "-", "7.91", "16.81", "23.69", "78.87", "87.42", "78.30", "7517"]
x1393 = ["1393", "-", "5.38", "-", "16.80", "23.68", "78.81", "87.36", "78.24", "7512"]
x1392 = ["1392", "2.18", "-", "7.90", "16.79", "23.66", "78.76", "87.30", "78.19", "7507"]
x1391 = ["1391", "-", "-", "-", "16.78", "23.64", "78.71", "87.24", "78.14", "7502"]
x1350 = ["1350", "-", "-", "7.71", "16.40", "22.99", "76.53", "84.83", "75.97", "7294"]
x1349 = ["1349", "-", "-", "-", "16.39", "22.98", "76.48", "84.77", "75.92", "7289"]
x1348 = ["1348", "2.14", "-", "7.70", "16.38", "22.96", "76.43", "84.71", "75.87", "7284"]
x1347 = ["1347", "-", "5.25", "-", "16.37", "22.94", "76.37", "84.65", "75.81", "7279"]
x1346 = ["1346", "-", "-", "7.69", "16.36", "22.93", "76.32", "84.59", "75.76", "7274"]
x1345 = ["1345", "-", "-", "-", "16.35", "22.91", "76.27", "84.54", "75.71", "7269"]
x1344 = ["1344", "-", "5.24", "7.68", "16.34", "22.90", "76.21", "84.48", "75.66", "7264"]
x1343 = ["1343", "-", "-", "-", "16.33", "22.88", "76.16", "84.42", "75.60", "7259"]
x1342 = ["1342", "-", "-", "-", "16.32", "22.86", "76.11", "84.36", "75.55", "7254"]
x1341 = ["1341", "-", "-", "7.67", "16.31", "22.85", "76.06", "84.30", "75.50", "7249"]
x1250 = ["1250", "-", "-", "-", "15.46", "21.40", "71.22", "78.94", "70.68", "6786"]
x1249 = ["1249", "-", "4.97", "7.25", "15.45", "21.38", "71.17", "78.88", "70.63", "6781"]
x1248 = ["1248", "2.05", "-", "-", "15.44", "21.37", "71.11", "78.82", "70.58", "6776"]
x1247 = ["1247", "-", "-", "7.24", "15.43", "21.35", "71.06", "78.76", "70.52", "6771"]
x1246 = ["1246", "-", "4.96", "-", "15.42", "21.34", "71.01", "78.70", "70.47", "6765"]
x1245 = ["1245", "-", "-", "7.23", "15.41", "21.32", "70.95", "78.64", "70.42", "6760"]
x1244 = ["1244", "-", "-", "-", "15.40", "21.30", "70.90", "78.58", "70.37", "6755"]
x1243 = ["1243", "-", "-", "7.22", "15.39", "21.29", "70.85", "78.52", "70.31", "6750"]
x1242 = ["1242", "-", "4.95", "-", "15.38", "21.27", "70.79", "78.46", "70.26", "6745"]
x1241 = ["1241", "-", "-", "7.21", "15.37", "21.26", "70.74", "78.40", "70.21", "6740"]
x1150 = ["1150", "1.96", "-", "6.79", "14.51", "19.80", "65.89", "73.03", "65.38", "6273"]
x1149 = ["1149", "-", "-", "-", "14.50", "19.79", "65.84", "72.97", "65.33", "6268"]
x1148 = ["1148", "-", "4.68", "-", "14.49", "19.77", "65.79", "72.91", "65.28", "6263"]
x1147 = ["1147", "-", "-", "6.78", "14.48", "19.76", "65.73", "72.85", "65.22", "6258"]
x1146 = ["1146", "-", "-", "-", "14.47", "19.74", "65.68", "72.79", "65.17", "6253"]
x1145 = ["1145", "-", "4.67", "6.77", "14.46", "19.72", "65.63", "72.73", "65.12", "6247"]
x1144 = ["1144", "-", "-", "-", "14.45", "19.71", "65.57", "72.67", "65.06", "6242"]
x1143 = ["1143", "-", "-", "6.76", "14.44", "19.69", "65.52", "72.61", "65.01", "6237"]
x1142 = ["1142", "-", "-", "-", "14.43", "19.68", "65.47", "72.55", "64.96", "6232"]
x1141 = ["1141", "-", "4.66", "6.75", "14.42", "19.66", "65.41", "72.50", "64.90", "6227"]
x1050 = ["1050", "-", "-", "6.33", "13.55", "18.20", "60.55", "67.11", "60.07", "5756"]
x1049 = ["1049", "-", "-", "-", "13.54", "18.19", "60.50", "67.05", "60.01", "5751"]
x1048 = ["1048", "-", "4.39", "6.32", "-", "18.17", "60.45", "66.99", "59.96", "5746"]
x1047 = ["1047", "-", "-", "-", "13.53", "18.16", "60.39", "66.93", "59.91", "5741"]
x1046 = ["1046", "-", "-", "6.31", "13.52", "18.14", "60.34", "66.87", "59.85", "5736"]
x1045 = ["1045", "-", "4.38", "-", "13.51", "18.12", "60.29", "66.81", "59.80", "5730"]
x1044 = ["1044", "-", "-", "6.30", "13.50", "18.11", "60.23", "66.75", "59.75", "5725"]
x1043 = ["1043", "-", "-", "-", "13.49", "18.09", "60.18", "66.69", "59.69", "5720"]
x1042 = ["1042", "-", "-", "6.29", "13.48", "18.08", "60.13", "66.63", "59.64", "5715"]
x1041 = ["1041", "1.86", "4.37", "-", "13.47", "18.06", "60.07", "66.57", "59.59", "5710"]
x950 = ["950", "-", "-", "5.86", "12.59", "16.60", "55.20", "61.17", "54.74", "5235"]
x949 = ["949", "-", "4.10", "-", "12.58", "16.59", "55.15", "61.11", "54.69", "5230"]
x948 = ["948", "-", "-", "5.85", "12.57", "16.57", "55.09", "61.05", "54.63", "5225"]
x947 = ["947", "-", "-", "-", "12.56", "16.55", "55.04", "60.99", "54.58", "5219"]
x946 = ["946", "-", "4.09", "5.84", "12.55", "16.54", "54.99", "60.93", "54.53", "5214"]
x945 = ["945", "1.77", "-", "-", "12.54", "16.52", "54.93", "60.87", "54.47", "5209"]
x944 = ["944", "-", "-", "5.83", "12.53", "16.51", "54.88", "60.81", "54.42", "5204"]
x943 = ["943", "-", "-", "-", "12.52", "16.49", "54.83", "60.75", "54.37", "5198"]
x942 = ["942", "-", "4.08", "-", "12.51", "16.47", "54.77", "60.70", "54.31", "5193"]
x941 = ["941", "-", "-", "5.82", "12.50", "16.46", "54.72", "60.64", "54.26", "5188"]
x850 = ["850", "-", "-", "5.39", "11.62", "14.99", "49.84", "55.22", "49.40", "4710"]
x849 = ["849", "-", "-", "-", "11.61", "14.98", "49.78", "55.16", "49.35", "4704"]
x848 = ["848", "1.68", "-", "5.38", "11.60", "14.96", "49.73", "55.10", "49.29", "4699"]
x847 = ["847", "-", "3.80", "-", "11.59", "14.95", "49.67", "55.04", "49.24", "4694"]
x846 = ["846", "-", "-", "5.37", "11.58", "14.93", "49.62", "54.98", "49.19", "4688"]
x845 = ["845", "-", "-", "-", "11.57", "14.91", "49.57", "54.92", "49.13", "4683"]
x844 = ["844", "-", "3.79", "5.36", "11.56", "14.90", "49.51", "54.86", "49.08", "4678"]
x843 = ["843", "-", "-", "-", "11.55", "14.88", "49.46", "54.80", "49.03", "4673"]
x842 = ["842", "-", "-", "5.35", "11.54", "14.87", "49.41", "54.74", "48.97", "4667"]
x841 = ["841", "-", "3.78", "-", "11.53", "14.85", "49.35", "54.68", "48.92", "4662"]
x750 = ["750", "-", "3.51", "-", "10.64", "13.38", "44.46", "49.26", "44.05", "4179"]
x749 = ["749", "-", "-", "4.91", "10.63", "13.37", "44.40", "49.20", "43.99", "4174"]
x748 = ["748", "-", "-", "-", "10.62", "13.35", "44.35", "49.14", "43.94", "4169"]
x747 = ["747", "-", "3.50", "4.90", "10.61", "13.33", "44.30", "49.08", "43.89", "4163"]
x746 = ["746", "-", "-", "-", "10.60", "13.32", "44.24", "49.02", "43.83", "4158"]
x745 = ["745", "-", "-", "4.89", "10.59", "13.30", "44.19", "48.96", "43.78", "4153"]
x744 = ["744", "-", "-", "-", "10.58", "13.29", "44.14", "48.90", "43.73", "4147"]
x743 = ["743", "1.58", "3.49", "4.88", "10.57", "13.27", "44.08", "48.84", "43.67", "4142"]
x742 = ["742", "-", "-", "-", "10.56", "13.25", "44.03", "48.78", "43.62", "4137"]
x741 = ["741", "-", "-", "4.87", "10.55", "13.24", "43.97", "48.72", "43.57", "4132"]
x650 = ["650", "-", "3.21", "-", "9.65", "11.77", "39.07", "43.28", "38.68", "3645"]
x649 = ["649", "-", "-", "4.43", "9.64", "11.75", "39.01", "43.22", "38.63", "3639"]
x648 = ["648", "1.49", "-", "-", "9.63", "11.74", "38.96", "43.16", "38.57", "3634"]
x647 = ["647", "-", "3.20", "4.42", "9.62", "11.72", "38.91", "43.10", "38.52", "3629"]
x646 = ["646", "-", "-", "-", "9.61", "11.70", "38.85", "43.04", "38.47", "3623"]
x645 = ["645", "-", "-", "4.41", "9.60", "11.69", "38.80", "42.98", "38.41", "3618"]
x644 = ["644", "-", "-", "-", "9.59", "11.67", "38.74", "42.92", "38.36", "3612"]
x643 = ["643", "-", "3.19", "4.40", "9.58", "11.66", "38.69", "42.86", "38.31", "3607"]
x642 = ["642", "-", "-", "-", "9.57", "11.64", "38.64", "42.80", "38.25", "3602"]
x641 = ["641", "-", "-", "4.39", "9.56", "11.62", "38.58", "42.74", "38.20", "3596"]
x550 = ["550", "-", "-", "3.95", "8.66", "10.15", "33.66", "37.28", "33.30", "3105"]
x549 = ["549", "-", "-", "-", "8.65", "10.13", "33.61", "37.22", "33.25", "3100"]
x548 = ["548", "-", "2.90", "3.94", "8.64", "10.12", "33.56", "37.16", "33.20", "3094"]
x547 = ["547", "-", "-", "-", "8.63", "10.10", "33.50", "37.10", "33.14", "3089"]
x546 = ["546", "-", "-", "3.93", "8.62", "10.08", "33.45", "37.04", "33.09", "3084"]
x545 = ["545", "-", "-", "-", "8.61", "10.07", "33.39", "36.98", "33.03", "3078"]
x544 = ["544", "1.39", "2.89", "3.92", "8.60", "10.05", "33.34", "36.92", "32.98", "3073"]
x543 = ["543", "-", "-", "-", "8.59", "10.04", "33.29", "36.86", "32.93", "3067"]
x542 = ["542", "-", "-", "3.91", "8.58", "10.02", "33.23", "36.80", "32.87", "3062"]
x541 = ["541", "-", "2.88", "-", "8.57", "10.00", "33.18", "36.74", "32.82", "3056"]
x450 = ["450", "-", "-", "3.46", "7.65", "8.53", "28.25", "31.28", "27.91", "2561"]
x449 = ["449", "-", "2.60", "-", "7.64", "8.51", "28.19", "31.22", "27.86", "2555"]
x448 = ["448", "-", "-", "3.45", "7.63", "8.49", "28.14", "31.16", "27.80", "2550"]
x447 = ["447", "-", "-", "-", "7.62", "8.48", "28.08", "31.10", "27.75", "2544"]
x446 = ["446", "-", "2.59", "3.44", "7.61", "8.46", "28.03", "31.04", "27.70", "2539"]
x445 = ["445", "-", "-", "-", "7.60", "8.45", "27.98", "30.98", "27.64", "2534"]
x444 = ["444", "-", "-", "3.43", "7.59", "8.43", "27.92", "30.92", "27.59", "2528"]
x443 = ["443", "-", "2.58", "-", "7.58", "8.41", "27.87", "30.86", "27.53", "2523"]
x442 = ["442", "-", "-", "3.42", "7.57", "8.40", "27.81", "30.80", "27.48", "2517"]
x441 = ["441", "1.29", "-", "-", "7.56", "8.38", "27.76", "30.74", "27.43", "2512"]
x350 = ["350", "-", "-", "-", "6.63", "6.90", "22.82", "25.25", "22.51", "2012"]
x349 = ["349", "1.20", "2.29", "2.96", "6.62", "6.88", "22.76", "25.19", "22.45", "2006"]
x348 = ["348", "-", "-", "-", "6.61", "6.87", "22.71", "25.13", "22.40", "2000"]
x347 = ["347", "-", "-", "2.95", "6.60", "6.85", "22.65", "25.07", "22.34", "1995"]
x346 = ["346", "-", "2.28", "-", "6.59", "6.83", "22.60", "25.01", "22.29", "1989"]
x345 = ["345", "-", "-", "2.94", "6.58", "6.82", "22.54", "24.95", "22.24", "1984"]
x344 = ["344", "-", "-", "-", "6.57", "6.80", "22.49", "24.89", "22.18", "1978"]
x343 = ["343", "-", "-", "2.93", "6.56", "6.79", "22.44", "24.83", "22.13", "1973"]
x342 = ["342", "-", "2.27", "-", "6.55", "6.77", "22.38", "24.77", "22.07", "1967"]
x341 = ["341", "-", "-", "2.92", "6.54", "6.75", "22.33", "24.71", "22.02", "1962"]
x250 = ["250", "-", "-", "2.47", "5.61", "5.27", "17.37", "19.22", "17.09", "1457"]
x249 = ["249", "-", "1.98", "-", "5.60", "5.25", "17.32", "19.16", "17.03", "1451"]
x248 = ["248", "1.10", "-", "2.46", "5.59", "5.24", "17.26", "19.10", "16.98", "1446"]
x247 = ["247", "-", "-", "-", "5.58", "5.22", "17.21", "19.04", "16.93", "1440"]
x246 = ["246", "-", "1.97", "2.45", "5.57", "5.20", "17.15", "18.98", "16.87", "1435"]
x245 = ["245", "-", "-", "-", "5.56", "5.19", "17.10", "18.91", "16.82", "1429"]
x244 = ["244", "-", "-", "2.44", "5.55", "5.17", "17.05", "18.85", "16.76", "1424"]
x243 = ["243", "-", "1.96", "-", "5.54", "5.16", "16.99", "18.79", "16.71", "1418"]
x242 = ["242", "-", "-", "2.43", "5.53", "5.14", "16.94", "18.73", "16.65", "1412"]
x241 = ["241", "-", "-", "-", "5.52", "5.12", "16.88", "18.67", "16.60", "1407"]
x150 = ["150", "-", "-", "-", "4.58", "3.63", "11.92", "13.16", "11.66", "897"]
x149 = ["149", "-", "-", "1.96", "4.57", "3.62", "11.86", "13.10", "11.60", "892"]
x148 = ["148", "1.00", "-", "-", "4.55", "3.60", "11.81", "13.04", "11.55", "886"]
x147 = ["147", "-", "1.66", "1.95", "4.54", "3.59", "11.75", "12.98", "11.49", "880"]
x146 = ["146", "-", "-", "-", "4.53", "3.57", "11.70", "12.92", "11.44", "875"]
x145 = ["145", "-", "-", "1.94", "4.52", "3.55", "11.64", "12.86", "11.38", "869"]
x144 = ["144", "-", "1.65", "-", "4.51", "3.54", "11.59", "12.80", "11.33", "863"]
x143 = ["143", "-", "-", "1.93", "4.50", "3.52", "11.53", "12.74", "11.28", "858"]
x142 = ["142", "-", "-", "-", "4.49", "3.50", "11.48", "12.68", "11.22", "852"]
x141 = ["141", "-", "1.64", "1.92", "4.48", "3.49", "11.42", "12.62", "11.17", "847"]
x50 = ["50", "-", "1.35", "1.46", "3.53", "2.00", "6.45", "7.10", "6.21", "332"]
x49 = ["49", "0.90", "-", "-", "3.52", "1.98", "6.39", "7.04", "6.16", "326"]
x48 = ["48", "-", "-", "1.45", "3.51", "1.96", "6.34", "6.98", "6.10", "320"]
x47 = ["47", "-", "-", "-", "3.50", "1.95", "6.28", "6.92", "6.05", "315"]
x46 = ["46", "-", "1.34", "1.44", "3.49", "1.93", "6.23", "6.85", "5.99", "309"]
x45 = ["45", "-", "-", "-", "3.48", "1.91", "6.17", "6.79", "5.94", "303"]
x44 = ["44", "-", "-", "1.43", "3.47", "1.90", "6.12", "6.73", "5.88", "298"]
x43 = ["43", "-", "1.33", "1.42", "3.46", "1.88", "6.06", "6.67", "5.83", "292"]
x42 = ["42", "-", "-", "-", "3.45", "1.86", "6.01", "6.61", "5.78", "286"]
x41 = ["41", "-", "-", "1.41", "3.44", "1.85", "5.95", "6.55", "5.72", "281"]
x10 = ["10", "-", "-", "-", "3.11", "1.34", "4.25", "4.67", "4.03", "104"]
x9 = ["9", "0.86", "1.22", "1.25", "3.10", "1.32", "4.20", "4.61", "3.98", "98"]
x8 = ["8", "-", "-", "-", "3.09", "1.31", "4.14", "4.54", "3.92", "93"]
x7 = ["7", "-", "-", "1.24", "3.08", "1.29", "4.09", "4.48", "3.87", "87"]
x6 = ["6", "-", "1.21", "-", "3.07", "1.27", "4.03", "4.42", "3.81", "81"]
x5 = ["5", "-", "-", "1.23", "3.06", "1.26", "3.98", "4.36", "3.76", "76"]
x4 = ["4", "-", "-", "-", "3.05", "1.24", "3.92", "4.30", "3.70", "70"]
x3 = ["3", "-", "1.20", "1.22", "3.04", "1.22", "3.87", "4.24", "3.65", "64"]
x2 = ["2", "-", "-", "-", "3.03", "1.21", "3.81", "4.18", "3.59", "59"]
x1 = ["1", "-", "-", "1.21", "3.02", "1.19", "3.76", "4.12", "3.54", "53"]
WOMENS_FIELD = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x650, x649, x648, x647, x646, x645, x644, x643, x642, x641, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x341, x250, x249, x248, x247, x246, x245, x244, x243, x242, x241, x150, x149, x148, x147, x146, x145, x144, x143, x142, x141, x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1]



xpoints = ["points", "100m", "100mH", "200m", "300m", "400m", "400mH", "4x100m", "4x200m", "4x400m"]
x1400 = ["1400", "9.90", "11.12", "19.94", "31.52", "44.45", "48.07", "38.49", "1:18.53", "3:00.61"]
x1399 = ["1399", "-", "11.13", "19.95", "31.54", "44.48", "48.09", "38.51", "1:18.57", "3:00.72"]
x1398 = ["1398", "9.91", "11.14", "19.96", "31.55", "44.50", "48.12", "38.53", "1:18.62", "3:00.83"]
x1397 = ["1397", "-", "-", "19.97", "31.57", "44.53", "48.15", "38.55", "1:18.67", "3:00.94"]
x1396 = ["1396", "9.92", "11.15", "19.98", "31.59", "44.56", "48.18", "38.58", "1:18.72", "3:01.04"]
x1395 = ["1395", "-", "11.16", "20.00", "31.61", "44.58", "48.21", "38.60", "1:18.76", "3:01.15"]
x1394 = ["1394", "9.93", "-", "20.01", "31.63", "44.61", "48.24", "38.62", "1:18.81", "3:01.26"]
x1393 = ["1393", "9.94", "11.17", "20.02", "31.65", "44.64", "48.27", "38.64", "1:18.86", "3:01.36"]
x1392 = ["1392", "-", "11.18", "20.03", "31.67", "44.66", "48.30", "38.66", "1:18.91", "3:01.47"]
x1391 = ["1391", "9.95", "11.19", "20.04", "31.69", "44.69", "48.33", "38.68", "1:18.96", "3:01.58"]
x1350 = ["1350", "-", "11.49", "20.53", "32.50", "45.81", "49.54", "39.56", "1:20.93", "3:06.01"]
x1349 = ["1349", "10.17", "-", "20.54", "32.52", "45.84", "49.57", "39.58", "1:20.98", "3:06.12"]
x1348 = ["1348", "-", "11.50", "20.56", "32.54", "45.86", "49.60", "39.61", "1:21.03", "3:06.23"]
x1347 = ["1347", "10.18", "11.51", "20.57", "32.56", "45.89", "49.63", "39.63", "1:21.08", "3:06.34"]
x1346 = ["1346", "-", "11.52", "20.58", "32.58", "45.92", "49.66", "39.65", "1:21.13", "3:06.45"]
x1345 = ["1345", "10.19", "-", "20.59", "32.60", "45.95", "49.69", "39.67", "1:21.17", "3:06.55"]
x1344 = ["1344", "-", "11.53", "20.60", "32.62", "45.97", "49.72", "39.69", "1:21.22", "3:06.66"]
x1343 = ["1343", "10.20", "11.54", "20.62", "32.64", "46.00", "49.75", "39.71", "1:21.27", "3:06.77"]
x1342 = ["1342", "-", "11.55", "20.63", "32.66", "46.03", "49.78", "39.74", "1:21.32", "3:06.88"]
x1341 = ["1341", "10.21", "-", "20.64", "32.68", "46.06", "49.81", "39.76", "1:21.37", "3:06.99"]
x1250 = ["1250", "-", "12.24", "21.76", "34.52", "48.61", "52.58", "41.77", "1:25.88", "3:17.11"]
x1249 = ["1249", "10.71", "12.25", "21.77", "34.54", "48.64", "52.61", "41.79", "1:25.93", "3:17.22"]
x1248 = ["1248", "-", "-", "21.78", "34.56", "48.67", "52.64", "41.81", "1:25.98", "3:17.33"]
x1247 = ["1247", "10.72", "12.26", "21.79", "34.58", "48.70", "52.67", "41.84", "1:26.03", "3:17.45"]
x1246 = ["1246", "10.73", "12.27", "21.81", "34.60", "48.72", "52.70", "41.86", "1:26.08", "3:17.56"]
x1245 = ["1245", "-", "12.28", "21.82", "34.62", "48.75", "52.73", "41.88", "1:26.13", "3:17.67"]
x1244 = ["1244", "10.74", "-", "21.83", "34.64", "48.78", "52.76", "41.90", "1:26.18", "3:17.79"]
x1243 = ["1243", "-", "12.29", "21.84", "34.66", "48.81", "52.80", "41.93", "1:26.23", "3:17.90"]
x1242 = ["1242", "10.75", "12.30", "21.86", "34.68", "48.84", "52.83", "41.95", "1:26.28", "3:18.01"]
x1241 = ["1241", "-", "12.31", "21.87", "34.70", "48.87", "52.86", "41.97", "1:26.33", "3:18.13"]
x1150 = ["1150", "11.27", "13.02", "23.03", "36.62", "51.53", "55.74", "44.06", "1:31.03", "3:28.66"]
x1149 = ["1149", "-", "13.03", "23.05", "36.64", "51.55", "55.77", "44.09", "1:31.08", "3:28.78"]
x1148 = ["1148", "11.28", "13.04", "23.06", "36.66", "51.58", "55.80", "44.11", "1:31.13", "3:28.89"]
x1147 = ["1147", "-", "-", "23.07", "36.68", "51.61", "55.84", "44.14", "1:31.19", "3:29.01"]
x1146 = ["1146", "11.29", "13.05", "23.08", "36.70", "51.64", "55.87", "44.16", "1:31.24", "3:29.13"]
x1145 = ["1145", "-", "13.06", "23.10", "36.73", "51.67", "55.90", "44.18", "1:31.29", "3:29.25"]
x1144 = ["1144", "11.30", "13.07", "23.11", "36.75", "51.70", "55.93", "44.21", "1:31.34", "3:29.37"]
x1143 = ["1143", "11.31", "13.08", "23.12", "36.77", "51.73", "55.97", "44.23", "1:31.40", "3:29.49"]
x1142 = ["1142", "-", "-", "23.14", "36.79", "51.76", "56.00", "44.25", "1:31.45", "3:29.60"]
x1141 = ["1141", "11.32", "13.09", "23.15", "36.81", "51.79", "56.03", "44.28", "1:31.50", "3:29.72"]
x1050 = ["1050", "-", "13.84", "24.37", "38.81", "54.57", "59.04", "46.46", "1:36.41", "3:40.72"]
x1049 = ["1049", "11.86", "13.85", "24.38", "38.84", "54.60", "59.08", "46.49", "1:36.46", "3:40.85"]
x1048 = ["1048", "11.87", "-", "24.39", "38.86", "54.63", "59.11", "46.51", "1:36.52", "3:40.97"]
x1047 = ["1047", "-", "13.86", "24.41", "38.88", "54.66", "59.14", "46.54", "1:36.57", "3:41.09"]
x1046 = ["1046", "11.88", "13.87", "24.42", "38.90", "54.69", "59.18", "46.56", "1:36.63", "3:41.22"]
x1045 = ["1045", "-", "13.88", "24.43", "38.93", "54.73", "59.21", "46.59", "1:36.68", "3:41.34"]
x1044 = ["1044", "11.89", "13.89", "24.45", "38.95", "54.76", "59.24", "46.61", "1:36.74", "3:41.47"]
x1043 = ["1043", "11.90", "13.90", "24.46", "38.97", "54.79", "59.28", "46.64", "1:36.79", "3:41.59"]
x1042 = ["1042", "-", "-", "24.47", "38.99", "54.82", "59.31", "46.66", "1:36.85", "3:41.71"]
x1041 = ["1041", "11.91", "13.91", "24.49", "39.02", "54.85", "59.35", "46.68", "1:36.90", "3:41.84"]
x950 = ["950", "-", "-", "25.76", "41.12", "57.76", "1:02.51", "48.98", "1:42.05", "3:53.38"]
x949 = ["949", "12.48", "14.70", "25.78", "41.14", "57.80", "1:02.54", "49.00", "1:42.11", "3:53.51"]
x948 = ["948", "-", "14.71", "25.79", "41.16", "57.83", "1:02.58", "49.03", "1:42.17", "3:53.64"]
x947 = ["947", "12.49", "14.72", "25.81", "41.19", "57.86", "1:02.61", "49.06", "1:42.22", "3:53.77"]
x946 = ["946", "12.50", "14.73", "25.82", "41.21", "57.89", "1:02.65", "49.08", "1:42.28", "3:53.90"]
x945 = ["945", "-", "14.74", "25.83", "41.24", "57.93", "1:02.68", "49.11", "1:42.34", "3:54.03"]
x944 = ["944", "12.51", "14.75", "25.85", "41.26", "57.96", "1:02.72", "49.13", "1:42.40", "3:54.16"]
x943 = ["943", "12.52", "14.76", "25.86", "41.28", "57.99", "1:02.75", "49.16", "1:42.46", "3:54.29"]
x942 = ["942", "-", "-", "25.88", "41.31", "58.03", "1:02.79", "49.19", "1:42.51", "3:54.42"]
x941 = ["941", "12.53", "14.77", "25.89", "41.33", "58.06", "1:02.83", "49.21", "1:42.57", "3:54.55"]
x850 = ["850", "-", "15.60", "27.24", "43.55", "1:01.13", "1:06.16", "51.63", "1:48.00", "4:06.72"]
x849 = ["849", "13.13", "15.61", "27.25", "43.57", "1:01.16", "1:06.19", "51.66", "1:48.06", "4:06.86"]
x848 = ["848", "13.14", "15.62", "27.27", "43.60", "1:01.20", "1:06.23", "51.68", "1:48.12", "4:06.99"]
x847 = ["847", "-", "15.63", "27.28", "43.62", "1:01.23", "1:06.27", "51.71", "1:48.18", "4:07.13"]
x846 = ["846", "13.15", "-", "27.30", "43.65", "1:01.27", "1:06.31", "51.74", "1:48.24", "4:07.27"]
x845 = ["845", "13.16", "15.64", "27.31", "43.67", "1:01.30", "1:06.34", "51.77", "1:48.30", "4:07.41"]
x844 = ["844", "-", "15.65", "27.33", "43.70", "1:01.34", "1:06.38", "51.79", "1:48.36", "4:07.54"]
x843 = ["843", "13.17", "15.66", "27.34", "43.72", "1:01.37", "1:06.42", "51.82", "1:48.43", "4:07.68"]
x842 = ["842", "13.18", "15.67", "27.36", "43.75", "1:01.41", "1:06.46", "51.85", "1:48.49", "4:07.82"]
x841 = ["841", "-", "15.68", "27.37", "43.77", "1:01.44", "1:06.49", "51.88", "1:48.55", "4:07.96"]
x750 = ["750", "13.81", "16.56", "28.80", "46.12", "1:04.70", "1:10.03", "54.44", "1:54.31", "4:20.87"]
x749 = ["749", "13.82", "16.57", "28.81", "46.15", "1:04.74", "1:10.07", "54.47", "1:54.37", "4:21.02"]
x748 = ["748", "13.83", "16.58", "28.83", "46.17", "1:04.77", "1:10.11", "54.50", "1:54.44", "4:21.16"]
x747 = ["747", "-", "16.59", "28.85", "46.20", "1:04.81", "1:10.15", "54.53", "1:54.50", "4:21.31"]
x746 = ["746", "13.84", "16.60", "28.86", "46.23", "1:04.85", "1:10.19", "54.56", "1:54.57", "4:21.46"]
x745 = ["745", "13.85", "16.61", "28.88", "46.25", "1:04.89", "1:10.23", "54.59", "1:54.63", "4:21.60"]
x744 = ["744", "-", "16.62", "28.90", "46.28", "1:04.92", "1:10.27", "54.62", "1:54.70", "4:21.75"]
x743 = ["743", "13.86", "16.63", "28.91", "46.31", "1:04.96", "1:10.31", "54.65", "1:54.76", "4:21.90"]
x742 = ["742", "13.87", "16.64", "28.93", "46.33", "1:05.00", "1:10.35", "54.68", "1:54.83", "4:22.04"]
x741 = ["741", "13.88", "16.65", "28.94", "46.36", "1:05.03", "1:10.39", "54.70", "1:54.89", "4:22.19"]
x650 = ["650", "14.55", "17.58", "30.47", "48.87", "1:08.52", "1:14.17", "57.45", "2:01.05", "4:36.00"]
x649 = ["649", "14.56", "17.59", "30.49", "48.90", "1:08.56", "1:14.21", "57.48", "2:01.12", "4:36.16"]
x648 = ["648", "-", "17.60", "30.50", "48.93", "1:08.60", "1:14.26", "57.51", "2:01.19", "4:36.32"]
x647 = ["647", "14.57", "17.61", "30.52", "48.96", "1:08.64", "1:14.30", "57.54", "2:01.26", "4:36.47"]
x646 = ["646", "14.58", "17.62", "30.54", "48.99", "1:08.68", "1:14.34", "57.57", "2:01.33", "4:36.63"]
x645 = ["645", "14.59", "17.63", "30.56", "49.02", "1:08.72", "1:14.38", "57.61", "2:01.40", "4:36.79"]
x644 = ["644", "14.60", "17.64", "30.57", "49.05", "1:08.76", "1:14.43", "57.64", "2:01.47", "4:36.95"]
x643 = ["643", "-", "17.66", "30.59", "49.07", "1:08.80", "1:14.47", "57.67", "2:01.54", "4:37.10"]
x642 = ["642", "14.61", "17.67", "30.61", "49.10", "1:08.84", "1:14.51", "57.70", "2:01.61", "4:37.26"]
x641 = ["641", "14.62", "17.68", "30.63", "49.13", "1:08.88", "1:14.56", "57.73", "2:01.68", "4:37.42"]
x550 = ["550", "15.35", "18.69", "32.27", "51.85", "1:12.64", "1:18.64", "1:00.70", "2:08.34", "4:52.35"]
x549 = ["549", "-", "18.70", "32.29", "51.88", "1:12.69", "1:18.69", "1:00.73", "2:08.41", "4:52.52"]
x548 = ["548", "15.36", "18.71", "32.31", "51.91", "1:12.73", "1:18.74", "1:00.77", "2:08.49", "4:52.69"]
x547 = ["547", "15.37", "18.72", "32.33", "51.94", "1:12.77", "1:18.78", "1:00.80", "2:08.57", "4:52.86"]
x546 = ["546", "15.38", "18.73", "32.35", "51.97", "1:12.82", "1:18.83", "1:00.83", "2:08.64", "4:53.03"]
x545 = ["545", "15.39", "18.75", "32.37", "52.00", "1:12.86", "1:18.88", "1:00.87", "2:08.72", "4:53.20"]
x544 = ["544", "15.40", "18.76", "32.39", "52.04", "1:12.90", "1:18.92", "1:00.90", "2:08.80", "4:53.37"]
x543 = ["543", "-", "18.77", "32.41", "52.07", "1:12.95", "1:18.97", "1:00.94", "2:08.87", "4:53.55"]
x542 = ["542", "15.41", "18.78", "32.43", "52.10", "1:12.99", "1:19.02", "1:00.97", "2:08.95", "4:53.72"]
x541 = ["541", "15.42", "18.79", "32.44", "52.13", "1:13.03", "1:19.06", "1:01.01", "2:09.03", "4:53.89"]
x450 = ["450", "16.22", "19.90", "34.25", "55.11", "1:17.16", "1:23.55", "1:04.26", "2:16.33", "5:10.26"]
x449 = ["449", "16.23", "19.91", "34.27", "55.14", "1:17.21", "1:23.60", "1:04.30", "2:16.41", "5:10.45"]
x448 = ["448", "16.24", "19.93", "34.29", "55.18", "1:17.26", "1:23.65", "1:04.33", "2:16.49", "5:10.64"]
x447 = ["447", "16.25", "19.94", "34.31", "55.21", "1:17.31", "1:23.70", "1:04.37", "2:16.58", "5:10.83"]
x446 = ["446", "16.26", "19.95", "34.34", "55.25", "1:17.35", "1:23.75", "1:04.41", "2:16.66", "5:11.02"]
x445 = ["445", "16.27", "19.96", "34.36", "55.28", "1:17.40", "1:23.80", "1:04.45", "2:16.75", "5:11.21"]
x444 = ["444", "16.28", "19.98", "34.38", "55.31", "1:17.45", "1:23.86", "1:04.49", "2:16.83", "5:11.40"]
x443 = ["443", "-", "19.99", "34.40", "55.35", "1:17.50", "1:23.91", "1:04.52", "2:16.92", "5:11.59"]
x442 = ["442", "16.29", "20.00", "34.42", "55.38", "1:17.55", "1:23.96", "1:04.56", "2:17.00", "5:11.78"]
x441 = ["441", "16.30", "20.02", "34.44", "55.42", "1:17.59", "1:24.01", "1:04.60", "2:17.09", "5:11.97"]
x350 = ["350", "17.20", "21.26", "36.47", "58.76", "1:22.22", "1:29.03", "1:08.24", "2:25.26", "5:30.30"]
x349 = ["349", "17.21", "21.27", "36.49", "58.79", "1:22.28", "1:29.09", "1:08.29", "2:25.36", "5:30.52"]
x348 = ["348", "17.22", "21.29", "36.51", "58.83", "1:22.33", "1:29.15", "1:08.33", "2:25.45", "5:30.73"]
x347 = ["347", "17.23", "21.30", "36.54", "58.87", "1:22.38", "1:29.21", "1:08.37", "2:25.55", "5:30.95"]
x346 = ["346", "17.24", "21.32", "36.56", "58.91", "1:22.44", "1:29.26", "1:08.41", "2:25.64", "5:31.16"]
x345 = ["345", "17.25", "21.33", "36.58", "58.95", "1:22.49", "1:29.32", "1:08.46", "2:25.74", "5:31.38"]
x344 = ["344", "17.26", "21.35", "36.61", "58.99", "1:22.55", "1:29.38", "1:08.50", "2:25.83", "5:31.59"]
x343 = ["343", "17.27", "21.36", "36.63", "59.03", "1:22.60", "1:29.44", "1:08.54", "2:25.93", "5:31.81"]
x342 = ["342", "17.28", "21.37", "36.66", "59.07", "1:22.66", "1:29.50", "1:08.59", "2:26.03", "5:32.03"]
x250 = ["250", "18.33", "22.83", "39.03", "1:02.97", "1:28.07", "1:35.37", "1:12.85", "2:35.59", "5:53.48"]
x249 = ["249", "18.34", "22.84", "39.05", "1:03.02", "1:28.13", "1:35.44", "1:12.90", "2:35.71", "5:53.74"]
x248 = ["248", "18.35", "22.86", "39.08", "1:03.07", "1:28.20", "1:35.51", "1:12.95", "2:35.82", "5:53.99"]
x247 = ["247", "18.36", "22.88", "39.11", "1:03.11", "1:28.26", "1:35.58", "1:13.00", "2:35.93", "5:54.25"]
x246 = ["246", "18.38", "22.90", "39.14", "1:03.16", "1:28.33", "1:35.65", "1:13.05", "2:36.05", "5:54.50"]
x245 = ["245", "18.39", "22.91", "39.17", "1:03.20", "1:28.39", "1:35.72", "1:13.10", "2:36.16", "5:54.76"]
x244 = ["244", "18.40", "22.93", "39.19", "1:03.25", "1:28.46", "1:35.79", "1:13.15", "2:36.27", "5:55.01"]
x243 = ["243", "18.41", "22.95", "39.22", "1:03.30", "1:28.52", "1:35.86", "1:13.20", "2:36.39", "5:55.27"]
x242 = ["242", "18.43", "22.97", "39.25", "1:03.34", "1:28.59", "1:35.93", "1:13.26", "2:36.50", "5:55.52"]
x150 = ["150", "19.72", "24.76", "42.17", "1:08.16", "1:35.27", "1:43.18", "1:18.52", "2:48.31", "6:22.00"]
x149 = ["149", "19.73", "24.78", "42.21", "1:08.22", "1:35.35", "1:43.27", "1:18.58", "2:48.45", "6:22.33"]
x148 = ["148", "19.75", "24.80", "42.25", "1:08.28", "1:35.43", "1:43.36", "1:18.65", "2:48.60", "6:22.66"]
x147 = ["147", "19.77", "24.83", "42.28", "1:08.34", "1:35.52", "1:43.45", "1:18.71", "2:48.75", "6:22.98"]
x146 = ["146", "19.78", "24.85", "42.32", "1:08.40", "1:35.60", "1:43.54", "1:18.78", "2:48.89", "6:23.32"]
x145 = ["145", "19.80", "24.87", "42.36", "1:08.46", "1:35.68", "1:43.63", "1:18.85", "2:49.04", "6:23.65"]
x144 = ["144", "19.81", "24.89", "42.39", "1:08.52", "1:35.77", "1:43.72", "1:18.91", "2:49.19", "6:23.98"]
x143 = ["143", "19.83", "24.92", "42.43", "1:08.58", "1:35.85", "1:43.81", "1:18.98", "2:49.34", "6:24.31"]
x142 = ["142", "19.85", "24.94", "42.47", "1:08.64", "1:35.94", "1:43.90", "1:19.04", "2:49.49", "6:24.65"]
x50 = ["50", "21.74", "27.56", "46.75", "1:15.70", "1:45.72", "1:54.51", "1:26.75", "3:06.77", "7:03.42"]
x49 = ["49", "21.76", "27.60", "46.81", "1:15.80", "1:45.86", "1:54.67", "1:26.86", "3:07.03", "7:03.99"]
x48 = ["48", "21.79", "27.64", "46.87", "1:15.91", "1:46.01", "1:54.82", "1:26.98", "3:07.28", "7:04.56"]
x47 = ["47", "21.82", "27.68", "46.94", "1:16.01", "1:46.15", "1:54.98", "1:27.09", "3:07.54", "7:05.14"]
x46 = ["46", "21.85", "27.72", "47.00", "1:16.12", "1:46.30", "1:55.14", "1:27.21", "3:07.80", "7:05.73"]
x45 = ["45", "21.88", "27.76", "47.07", "1:16.23", "1:46.45", "1:55.31", "1:27.33", "3:08.07", "7:06.32"]
x44 = ["44", "21.91", "27.80", "47.13", "1:16.34", "1:46.60", "1:55.47", "1:27.45", "3:08.33", "7:06.92"]
x43 = ["43", "21.94", "27.84", "47.20", "1:16.45", "1:46.76", "1:55.64", "1:27.57", "3:08.60", "7:07.53"]
x42 = ["42", "21.97", "27.88", "47.27", "1:16.56", "1:46.91", "1:55.80", "1:27.69", "3:08.88", "7:08.14"]
x10 = ["10", "23.26", "29.68", "50.20", "1:21.39", "1:53.61", "2:03.07", "1:32.97", "3:20.71", "7:34.69"]
x9 = ["9", "23.32", "29.77", "50.34", "1:21.63", "1:53.94", "2:03.43", "1:33.22", "3:21.29", "7:35.99"]
x8 = ["8", "23.39", "29.86", "50.50", "1:21.88", "1:54.28", "2:03.80", "1:33.50", "3:21.91", "7:37.36"]
x7 = ["7", "23.46", "29.96", "50.66", "1:22.14", "1:54.65", "2:04.20", "1:33.79", "3:22.56", "7:38.83"]
x6 = ["6", "23.54", "30.07", "50.83", "1:22.43", "1:55.05", "2:04.63", "1:34.10", "3:23.26", "7:40.40"]
x5 = ["5", "23.62", "30.18", "51.02", "1:22.74", "1:55.48", "2:05.10", "1:34.44", "3:24.02", "7:42.10"]
x4 = ["4", "23.71", "30.31", "51.23", "1:23.08", "1:55.96", "2:05.62", "1:34.81", "3:24.86", "7:43.99"]
x3 = ["3", "23.82", "30.46", "51.46", "1:23.47", "1:56.50", "2:06.20", "1:35.24", "3:25.82", "7:46.14"]
x2 = ["2", "23.94", "30.63", "51.75", "1:23.94", "1:57.14", "2:06.90", "1:35.75", "3:26.95", "7:48.68"]
WOMENS_SPRINTS = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x650, x649, x648, x647, x646, x645, x644, x643, x642, x641, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x250, x249, x248, x247, x246, x245, x244, x243, x242, x150, x149, x148, x147, x146, x145, x144, x143, x142, x50, x49, x48, x47, x46, x45, x44, x43, x42, x10, x9, x8, x7, x6, x5, x4, x3, x2]



xpoints = ["points", "600m", "800m", "1000m", "1500m", "mile", "2000m"]
x1400 = ["1400", "1:16.06", "1:46.78", "2:18.56", "3:36.77", "3:53.34", "4:55.11"]
x1399 = ["1399", "1:16.10", "1:46.83", "2:18.62", "3:36.88", "3:53.46", "4:55.28"]
x1398 = ["1398", "1:16.14", "1:46.88", "2:18.69", "3:37.00", "3:53.58", "4:55.44"]
x1397 = ["1397", "1:16.18", "1:46.94", "2:18.76", "3:37.11", "3:53.71", "4:55.60"]
x1396 = ["1396", "1:16.22", "1:46.99", "2:18.83", "3:37.23", "3:53.83", "4:55.76"]
x1395 = ["1395", "1:16.26", "1:47.04", "2:18.90", "3:37.34", "3:53.96", "4:55.93"]
x1394 = ["1394", "1:16.30", "1:47.09", "2:18.97", "3:37.46", "3:54.08", "4:56.09"]
x1393 = ["1393", "1:16.33", "1:47.14", "2:19.03", "3:37.57", "3:54.20", "4:56.25"]
x1392 = ["1392", "1:16.37", "1:47.19", "2:19.10", "3:37.69", "3:54.33", "4:56.42"]
x1391 = ["1391", "1:16.41", "1:47.24", "2:19.17", "3:37.81", "3:54.45", "4:56.58"]
x1350 = ["1350", "1:18.01", "1:49.36", "2:22.00", "3:42.59", "3:59.58", "5:03.31"]
x1349 = ["1349", "1:18.05", "1:49.42", "2:22.07", "3:42.71", "3:59.71", "5:03.48"]
x1348 = ["1348", "1:18.09", "1:49.47", "2:22.14", "3:42.82", "3:59.84", "5:03.64"]
x1347 = ["1347", "1:18.13", "1:49.52", "2:22.21", "3:42.94", "3:59.96", "5:03.81"]
x1346 = ["1346", "1:18.17", "1:49.57", "2:22.28", "3:43.06", "4:00.09", "5:03.97"]
x1345 = ["1345", "1:18.20", "1:49.62", "2:22.35", "3:43.18", "4:00.21", "5:04.14"]
x1344 = ["1344", "1:18.24", "1:49.68", "2:22.42", "3:43.30", "4:00.34", "5:04.30"]
x1343 = ["1343", "1:18.28", "1:49.73", "2:22.49", "3:43.41", "4:00.47", "5:04.47"]
x1342 = ["1342", "1:18.32", "1:49.78", "2:22.56", "3:43.53", "4:00.59", "5:04.64"]
x1341 = ["1341", "1:18.36", "1:49.83", "2:22.63", "3:43.65", "4:00.72", "5:04.80"]
x1250 = ["1250", "1:22.01", "1:54.67", "2:29.10", "3:54.57", "4:12.43", "5:20.17"]
x1249 = ["1249", "1:22.05", "1:54.73", "2:29.17", "3:54.69", "4:12.57", "5:20.34"]
x1248 = ["1248", "1:22.09", "1:54.78", "2:29.25", "3:54.82", "4:12.70", "5:20.52"]
x1247 = ["1247", "1:22.13", "1:54.83", "2:29.32", "3:54.94", "4:12.83", "5:20.69"]
x1246 = ["1246", "1:22.17", "1:54.89", "2:29.39", "3:55.06", "4:12.96", "5:20.86"]
x1245 = ["1245", "1:22.21", "1:54.94", "2:29.46", "3:55.18", "4:13.09", "5:21.03"]
x1244 = ["1244", "1:22.25", "1:55.00", "2:29.54", "3:55.31", "4:13.22", "5:21.21"]
x1243 = ["1243", "1:22.30", "1:55.05", "2:29.61", "3:55.43", "4:13.35", "5:21.38"]
x1242 = ["1242", "1:22.34", "1:55.11", "2:29.68", "3:55.55", "4:13.48", "5:21.55"]
x1241 = ["1241", "1:22.38", "1:55.16", "2:29.75", "3:55.67", "4:13.62", "5:21.72"]
x1150 = ["1150", "1:26.17", "2:00.20", "2:36.49", "4:07.04", "4:25.81", "5:37.72"]
x1149 = ["1149", "1:26.22", "2:00.25", "2:36.56", "4:07.17", "4:25.95", "5:37.90"]
x1148 = ["1148", "1:26.26", "2:00.31", "2:36.64", "4:07.30", "4:26.08", "5:38.08"]
x1147 = ["1147", "1:26.30", "2:00.37", "2:36.71", "4:07.43", "4:26.22", "5:38.26"]
x1146 = ["1146", "1:26.34", "2:00.42", "2:36.79", "4:07.55", "4:26.36", "5:38.44"]
x1145 = ["1145", "1:26.39", "2:00.48", "2:36.87", "4:07.68", "4:26.49", "5:38.62"]
x1144 = ["1144", "1:26.43", "2:00.54", "2:36.94", "4:07.81", "4:26.63", "5:38.80"]
x1143 = ["1143", "1:26.47", "2:00.59", "2:37.02", "4:07.94", "4:26.77", "5:38.98"]
x1142 = ["1142", "1:26.51", "2:00.65", "2:37.09", "4:08.06", "4:26.90", "5:39.16"]
x1141 = ["1141", "1:26.56", "2:00.71", "2:37.17", "4:08.19", "4:27.04", "5:39.34"]
x1050 = ["1050", "1:30.52", "2:05.97", "2:44.20", "4:20.07", "4:39.78", "5:56.06"]
x1049 = ["1049", "1:30.57", "2:06.03", "2:44.28", "4:20.20", "4:39.92", "5:56.24"]
x1048 = ["1048", "1:30.61", "2:06.09", "2:44.36", "4:20.34", "4:40.07", "5:56.43"]
x1047 = ["1047", "1:30.66", "2:06.15", "2:44.44", "4:20.47", "4:40.21", "5:56.62"]
x1046 = ["1046", "1:30.70", "2:06.21", "2:44.52", "4:20.60", "4:40.35", "5:56.81"]
x1045 = ["1045", "1:30.75", "2:06.27", "2:44.60", "4:20.74", "4:40.50", "5:57.00"]
x1044 = ["1044", "1:30.79", "2:06.32", "2:44.68", "4:20.87", "4:40.64", "5:57.18"]
x1043 = ["1043", "1:30.84", "2:06.38", "2:44.76", "4:21.00", "4:40.78", "5:57.37"]
x1042 = ["1042", "1:30.88", "2:06.44", "2:44.84", "4:21.14", "4:40.93", "5:57.56"]
x1041 = ["1041", "1:30.93", "2:06.50", "2:44.92", "4:21.27", "4:41.07", "5:57.75"]
x950 = ["950", "1:35.09", "2:12.02", "2:52.30", "4:33.73", "4:54.43", "6:15.28"]
x949 = ["949", "1:35.13", "2:12.09", "2:52.38", "4:33.87", "4:54.58", "6:15.48"]
x948 = ["948", "1:35.18", "2:12.15", "2:52.46", "4:34.01", "4:54.73", "6:15.68"]
x947 = ["947", "1:35.23", "2:12.21", "2:52.54", "4:34.15", "4:54.89", "6:15.88"]
x946 = ["946", "1:35.27", "2:12.27", "2:52.63", "4:34.29", "4:55.04", "6:16.07"]
x945 = ["945", "1:35.32", "2:12.33", "2:52.71", "4:34.43", "4:55.19", "6:16.27"]
x944 = ["944", "1:35.37", "2:12.40", "2:52.79", "4:34.58", "4:55.34", "6:16.47"]
x943 = ["943", "1:35.41", "2:12.46", "2:52.88", "4:34.72", "4:55.49", "6:16.67"]
x942 = ["942", "1:35.46", "2:12.52", "2:52.96", "4:34.86", "4:55.64", "6:16.87"]
x941 = ["941", "1:35.51", "2:12.58", "2:53.04", "4:35.00", "4:55.79", "6:17.06"]
x850 = ["850", "1:39.90", "2:18.40", "3:00.83", "4:48.14", "5:09.88", "6:35.55"]
x849 = ["849", "1:39.94", "2:18.47", "3:00.91", "4:48.28", "5:10.04", "6:35.76"]
x848 = ["848", "1:39.99", "2:18.54", "3:01.00", "4:48.43", "5:10.20", "6:35.97"]
x847 = ["847", "1:40.04", "2:18.60", "3:01.09", "4:48.58", "5:10.36", "6:36.18"]
x846 = ["846", "1:40.09", "2:18.67", "3:01.18", "4:48.73", "5:10.52", "6:36.39"]
x845 = ["845", "1:40.14", "2:18.73", "3:01.27", "4:48.88", "5:10.68", "6:36.60"]
x844 = ["844", "1:40.19", "2:18.80", "3:01.35", "4:49.03", "5:10.84", "6:36.81"]
x843 = ["843", "1:40.24", "2:18.87", "3:01.44", "4:49.18", "5:11.00", "6:37.02"]
x842 = ["842", "1:40.29", "2:18.93", "3:01.53", "4:49.32", "5:11.16", "6:37.23"]
x841 = ["841", "1:40.34", "2:19.00", "3:01.62", "4:49.47", "5:11.32", "6:37.44"]
x750 = ["750", "1:45.00", "2:25.17", "3:09.88", "5:03.41", "5:26.27", "6:57.06"]
x749 = ["749", "1:45.05", "2:25.24", "3:09.97", "5:03.57", "5:26.44", "6:57.28"]
x748 = ["748", "1:45.10", "2:25.31", "3:10.06", "5:03.73", "5:26.61", "6:57.50"]
x747 = ["747", "1:45.16", "2:25.38", "3:10.16", "5:03.89", "5:26.78", "6:57.72"]
x746 = ["746", "1:45.21", "2:25.45", "3:10.25", "5:04.05", "5:26.94", "6:57.95"]
x745 = ["745", "1:45.26", "2:25.52", "3:10.34", "5:04.20", "5:27.11", "6:58.17"]
x744 = ["744", "1:45.31", "2:25.59", "3:10.44", "5:04.36", "5:27.28", "6:58.39"]
x743 = ["743", "1:45.37", "2:25.66", "3:10.53", "5:04.52", "5:27.45", "6:58.61"]
x742 = ["742", "1:45.42", "2:25.73", "3:10.62", "5:04.68", "5:27.62", "6:58.84"]
x741 = ["741", "1:45.47", "2:25.81", "3:10.72", "5:04.84", "5:27.79", "6:59.06"]
x650 = ["650", "1:50.45", "2:32.41", "3:19.55", "5:19.75", "5:43.79", "7:20.05"]
x649 = ["649", "1:50.51", "2:32.49", "3:19.65", "5:19.92", "5:43.97", "7:20.28"]
x648 = ["648", "1:50.57", "2:32.56", "3:19.75", "5:20.09", "5:44.15", "7:20.52"]
x647 = ["647", "1:50.62", "2:32.64", "3:19.85", "5:20.26", "5:44.33", "7:20.76"]
x646 = ["646", "1:50.68", "2:32.71", "3:19.95", "5:20.43", "5:44.52", "7:21.00"]
x645 = ["645", "1:50.74", "2:32.79", "3:20.05", "5:20.60", "5:44.70", "7:21.24"]
x644 = ["644", "1:50.79", "2:32.86", "3:20.15", "5:20.77", "5:44.88", "7:21.48"]
x643 = ["643", "1:50.85", "2:32.94", "3:20.26", "5:20.94", "5:45.06", "7:21.72"]
x642 = ["642", "1:50.91", "2:33.01", "3:20.36", "5:21.11", "5:45.25", "7:21.96"]
x641 = ["641", "1:50.96", "2:33.09", "3:20.46", "5:21.28", "5:45.43", "7:22.20"]
x550 = ["550", "1:56.35", "2:40.23", "3:30.00", "5:37.40", "6:02.72", "7:44.88"]
x549 = ["549", "1:56.41", "2:40.31", "3:30.11", "5:37.58", "6:02.91", "7:45.14"]
x548 = ["548", "1:56.47", "2:40.40", "3:30.22", "5:37.77", "6:03.11", "7:45.40"]
x547 = ["547", "1:56.53", "2:40.48", "3:30.33", "5:37.95", "6:03.31", "7:45.66"]
x546 = ["546", "1:56.59", "2:40.56", "3:30.44", "5:38.14", "6:03.51", "7:45.92"]
x545 = ["545", "1:56.65", "2:40.64", "3:30.55", "5:38.32", "6:03.71", "7:46.18"]
x544 = ["544", "1:56.72", "2:40.72", "3:30.66", "5:38.51", "6:03.90", "7:46.44"]
x543 = ["543", "1:56.78", "2:40.80", "3:30.77", "5:38.69", "6:04.10", "7:46.70"]
x542 = ["542", "1:56.84", "2:40.89", "3:30.88", "5:38.88", "6:04.30", "7:46.96"]
x541 = ["541", "1:56.90", "2:40.97", "3:30.99", "5:39.06", "6:04.50", "7:47.23"]
x450 = ["450", "2:02.80", "2:48.80", "3:41.46", "5:56.74", "6:23.46", "8:12.10"]
x449 = ["449", "2:02.87", "2:48.89", "3:41.58", "5:56.94", "6:23.68", "8:12.39"]
x448 = ["448", "2:02.94", "2:48.98", "3:41.70", "5:57.15", "6:23.90", "8:12.68"]
x447 = ["447", "2:03.01", "2:49.07", "3:41.82", "5:57.35", "6:24.11", "8:12.96"]
x446 = ["446", "2:03.08", "2:49.16", "3:41.94", "5:57.56", "6:24.33", "8:13.25"]
x445 = ["445", "2:03.14", "2:49.25", "3:42.06", "5:57.76", "6:24.55", "8:13.54"]
x444 = ["444", "2:03.21", "2:49.34", "3:42.18", "5:57.97", "6:24.77", "8:13.83"]
x443 = ["443", "2:03.28", "2:49.44", "3:42.31", "5:58.17", "6:24.99", "8:14.12"]
x442 = ["442", "2:03.35", "2:49.53", "3:42.43", "5:58.38", "6:25.21", "8:14.40"]
x441 = ["441", "2:03.42", "2:49.62", "3:42.55", "5:58.58", "6:25.43", "8:14.69"]
x350 = ["350", "2:10.03", "2:58.39", "3:54.28", "6:18.38", "6:46.67", "8:42.55"]
x349 = ["349", "2:10.11", "2:58.49", "3:54.41", "6:18.61", "6:46.91", "8:42.88"]
x348 = ["348", "2:10.18", "2:58.59", "3:54.55", "6:18.84", "6:47.16", "8:43.21"]
x347 = ["347", "2:10.26", "2:58.70", "3:54.69", "6:19.07", "6:47.41", "8:43.53"]
x346 = ["346", "2:10.34", "2:58.80", "3:54.82", "6:19.31", "6:47.66", "8:43.86"]
x345 = ["345", "2:10.42", "2:58.90", "3:54.96", "6:19.54", "6:47.91", "8:44.18"]
x344 = ["344", "2:10.49", "2:59.01", "3:55.10", "6:19.77", "6:48.16", "8:44.51"]
x343 = ["343", "2:10.57", "2:59.11", "3:55.24", "6:20.00", "6:48.41", "8:44.84"]
x342 = ["342", "2:10.65", "2:59.21", "3:55.38", "6:20.24", "6:48.66", "8:45.17"]
x341 = ["341", "2:10.73", "2:59.32", "3:55.51", "6:20.47", "6:48.91", "8:45.50"]
x250 = ["250", "2:18.39", "3:09.48", "4:09.10", "6:43.41", "7:13.51", "9:17.77"]
x249 = ["249", "2:18.48", "3:09.60", "4:09.26", "6:43.68", "7:13.80", "9:18.16"]
x248 = ["248", "2:18.57", "3:09.72", "4:09.42", "6:43.95", "7:14.09", "9:18.54"]
x247 = ["247", "2:18.66", "3:09.84", "4:09.58", "6:44.23", "7:14.39", "9:18.93"]
x246 = ["246", "2:18.75", "3:09.96", "4:09.75", "6:44.50", "7:14.68", "9:19.32"]
x245 = ["245", "2:18.84", "3:10.08", "4:09.91", "6:44.78", "7:14.98", "9:19.70"]
x244 = ["244", "2:18.94", "3:10.21", "4:10.07", "6:45.05", "7:15.27", "9:20.09"]
x243 = ["243", "2:19.03", "3:10.33", "4:10.24", "6:45.33", "7:15.57", "9:20.48"]
x242 = ["242", "2:19.12", "3:10.45", "4:10.40", "6:45.61", "7:15.87", "9:20.87"]
x241 = ["241", "2:19.21", "3:10.58", "4:10.57", "6:45.89", "7:16.17", "9:21.26"]
x150 = ["150", "2:28.67", "3:23.12", "4:27.33", "7:14.19", "7:46.52", "10:01.10"]
x149 = ["149", "2:28.78", "3:23.27", "4:27.54", "7:14.55", "7:46.90", "10:01.60"]
x148 = ["148", "2:28.90", "3:23.43", "4:27.75", "7:14.90", "7:47.28", "10:02.10"]
x147 = ["147", "2:29.02", "3:23.59", "4:27.96", "7:15.26", "7:47.67", "10:02.60"]
x146 = ["146", "2:29.14", "3:23.75", "4:28.17", "7:15.61", "7:48.05", "10:03.10"]
x145 = ["145", "2:29.26", "3:23.91", "4:28.38", "7:15.97", "7:48.43", "10:03.60"]
x144 = ["144", "2:29.38", "3:24.06", "4:28.60", "7:16.33", "7:48.82", "10:04.11"]
x143 = ["143", "2:29.50", "3:24.22", "4:28.81", "7:16.69", "7:49.20", "10:04.62"]
x142 = ["142", "2:29.62", "3:24.38", "4:29.03", "7:17.05", "7:49.59", "10:05.13"]
x141 = ["141", "2:29.74", "3:24.55", "4:29.24", "7:17.42", "7:49.98", "10:05.64"]
x50 = ["50", "2:43.60", "3:42.93", "4:53.82", "7:58.91", "8:34.48", "11:04.03"]
x49 = ["49", "2:43.80", "3:43.20", "4:54.18", "7:59.52", "8:35.14", "11:04.89"]
x48 = ["48", "2:44.01", "3:43.48", "4:54.55", "8:00.14", "8:35.81", "11:05.77"]
x47 = ["47", "2:44.22", "3:43.75", "4:54.92", "8:00.77", "8:36.48", "11:06.65"]
x46 = ["46", "2:44.43", "3:44.04", "4:55.29", "8:01.40", "8:37.16", "11:07.54"]
x45 = ["45", "2:44.64", "3:44.32", "4:55.67", "8:02.04", "8:37.84", "11:08.44"]
x44 = ["44", "2:44.86", "3:44.61", "4:56.06", "8:02.69", "8:38.54", "11:09.35"]
x43 = ["43", "2:45.08", "3:44.90", "4:56.44", "8:03.35", "8:39.24", "11:10.27"]
x42 = ["42", "2:45.30", "3:45.19", "4:56.84", "8:04.01", "8:39.95", "11:11.21"]
x41 = ["41", "2:45.52", "3:45.49", "4:57.23", "8:04.68", "8:40.67", "11:12.15"]
x10 = ["10", "2:54.87", "3:57.89", "5:13.82", "8:32.68", "9:10.70", "11:51.55"]
x9 = ["9", "2:55.34", "3:58.51", "5:14.65", "8:34.08", "9:12.20", "11:53.52"]
x8 = ["8", "2:55.84", "3:59.17", "5:15.52", "8:35.56", "9:13.79", "11:55.61"]
x7 = ["7", "2:56.36", "3:59.87", "5:16.46", "8:37.14", "9:15.48", "11:57.83"]
x6 = ["6", "2:56.93", "4:00.62", "5:17.46", "8:38.83", "9:17.30", "12:00.22"]
x5 = ["5", "2:57.54", "4:01.44", "5:18.55", "8:40.68", "9:19.28", "12:02.81"]
x4 = ["4", "2:58.23", "4:02.34", "5:19.76", "8:42.72", "9:21.47", "12:05.68"]
x3 = ["3", "2:59.00", "4:03.37", "5:21.13", "8:45.03", "9:23.95", "12:08.94"]
x2 = ["2", "2:59.92", "4:04.58", "5:22.76", "8:47.78", "9:26.89", "12:12.80"]
x1 = ["1", "3:01.11", "4:06.17", "5:24.88", "8:51.36", "9:30.73", "12:17.84"]
WOMENS_MIDDLE = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x650, x649, x648, x647, x646, x645, x644, x643, x642, x641, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x341, x250, x249, x248, x247, x246, x245, x244, x243, x242, x241, x150, x149, x148, x147, x146, x145, x144, x143, x142, x141, x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1]


xpoints = ["points", "2000mSC", "3000m", "3000mSC", "2miles", "5000m", "10000m"]
x1400 = ["1400", "5:22.22", "7:37.43", "7:51.37", "8:21.80", "13:16.76", "27:45.08"]
x1399 = ["1399", "5:22.42", "7:37.70", "7:51.75", "8:22.08", "13:17.23", "27:46.09"]
x1398 = ["1398", "5:22.62", "7:37.96", "7:52.12", "8:22.36", "13:17.70", "27:47.11"]
x1397 = ["1397", "5:22.82", "7:38.23", "7:52.49", "8:22.64", "13:18.16", "27:48.12"]
x1396 = ["1396", "5:23.02", "7:38.49", "7:52.86", "8:22.92", "13:18.63", "27:49.13"]
x1395 = ["1395", "5:23.22", "7:38.76", "7:53.23", "8:23.21", "13:19.09", "27:50.15"]
x1394 = ["1394", "5:23.42", "7:39.03", "7:53.60", "8:23.49", "13:19.56", "27:51.16"]
x1393 = ["1393", "5:23.62", "7:39.29", "7:53.97", "8:23.77", "13:20.03", "27:52.18"]
x1392 = ["1392", "5:23.82", "7:39.56", "7:54.35", "8:24.05", "13:20.49", "27:53.19"]
x1391 = ["1391", "5:24.02", "7:39.82", "7:54.72", "8:24.33", "13:20.96", "27:54.21"]
x1350 = ["1350", "5:32.27", "7:50.81", "8:10.09", "8:35.97", "13:40.25", "28:36.16"]
x1349 = ["1349", "5:32.48", "7:51.08", "8:10.47", "8:36.25", "13:40.72", "28:37.20"]
x1348 = ["1348", "5:32.68", "7:51.35", "8:10.85", "8:36.54", "13:41.20", "28:38.23"]
x1347 = ["1347", "5:32.88", "7:51.62", "8:11.22", "8:36.83", "13:41.67", "28:39.26"]
x1346 = ["1346", "5:33.08", "7:51.89", "8:11.60", "8:37.11", "13:42.14", "28:40.29"]
x1345 = ["1345", "5:33.29", "7:52.17", "8:11.98", "8:37.40", "13:42.62", "28:41.32"]
x1344 = ["1344", "5:33.49", "7:52.44", "8:12.36", "8:37.69", "13:43.09", "28:42.36"]
x1343 = ["1343", "5:33.69", "7:52.71", "8:12.74", "8:37.97", "13:43.57", "28:43.39"]
x1342 = ["1342", "5:33.90", "7:52.98", "8:13.12", "8:38.26", "13:44.05", "28:44.43"]
x1341 = ["1341", "5:34.10", "7:53.25", "8:13.50", "8:38.55", "13:44.52", "28:45.46"]
x1250 = ["1250", "5:52.95", "8:18.34", "8:48.59", "9:05.11", "14:28.56", "30:21.25"]
x1249 = ["1249", "5:53.16", "8:18.62", "8:48.98", "9:05.41", "14:29.05", "30:22.32"]
x1248 = ["1248", "5:53.37", "8:18.90", "8:49.38", "9:05.71", "14:29.54", "30:23.40"]
x1247 = ["1247", "5:53.58", "8:19.18", "8:49.77", "9:06.00", "14:30.04", "30:24.47"]
x1246 = ["1246", "5:53.79", "8:19.46", "8:50.16", "9:06.30", "14:30.53", "30:25.54"]
x1245 = ["1245", "5:54.00", "8:19.74", "8:50.56", "9:06.60", "14:31.02", "30:26.62"]
x1244 = ["1244", "5:54.22", "8:20.03", "8:50.95", "9:06.90", "14:31.52", "30:27.69"]
x1243 = ["1243", "5:54.43", "8:20.31", "8:51.34", "9:07.19", "14:32.01", "30:28.76"]
x1242 = ["1242", "5:54.64", "8:20.59", "8:51.74", "9:07.49", "14:32.50", "30:29.84"]
x1241 = ["1241", "5:54.85", "8:20.87", "8:52.13", "9:07.79", "14:33.00", "30:30.91"]
x1150 = ["1150", "6:14.47", "8:46.99", "9:28.67", "9:35.45", "15:18.84", "32:10.64"]
x1149 = ["1149", "6:14.69", "8:47.28", "9:29.07", "9:35.76", "15:19.36", "32:11.75"]
x1148 = ["1148", "6:14.91", "8:47.58", "9:29.48", "9:36.07", "15:19.87", "32:12.87"]
x1147 = ["1147", "6:15.13", "8:47.87", "9:29.89", "9:36.38", "15:20.38", "32:13.99"]
x1146 = ["1146", "6:15.35", "8:48.16", "9:30.30", "9:36.69", "15:20.90", "32:15.11"]
x1145 = ["1145", "6:15.57", "8:48.46", "9:30.71", "9:37.00", "15:21.41", "32:16.23"]
x1144 = ["1144", "6:15.79", "8:48.75", "9:31.12", "9:37.31", "15:21.93", "32:17.35"]
x1143 = ["1143", "6:16.01", "8:49.04", "9:31.53", "9:37.62", "15:22.44", "32:18.47"]
x1142 = ["1142", "6:16.23", "8:49.34", "9:31.95", "9:37.93", "15:22.96", "32:19.59"]
x1141 = ["1141", "6:16.45", "8:49.63", "9:32.36", "9:38.24", "15:23.47", "32:20.71"]
x1050 = ["1050", "6:36.95", "9:16.92", "10:10.52", "10:07.13", "16:11.36", "34:04.89"]
x1049 = ["1049", "6:37.18", "9:17.22", "10:10.95", "10:07.46", "16:11.90", "34:06.06"]
x1048 = ["1048", "6:37.41", "9:17.53", "10:11.38", "10:07.78", "16:12.44", "34:07.23"]
x1047 = ["1047", "6:37.64", "9:17.84", "10:11.81", "10:08.10", "16:12.98", "34:08.40"]
x1046 = ["1046", "6:37.87", "9:18.14", "10:12.24", "10:08.43", "16:13.52", "34:09.57"]
x1045 = ["1045", "6:38.10", "9:18.45", "10:12.67", "10:08.75", "16:14.05", "34:10.74"]
x1044 = ["1044", "6:38.33", "9:18.76", "10:13.10", "10:09.08", "16:14.59", "34:11.91"]
x1043 = ["1043", "6:38.56", "9:19.06", "10:13.53", "10:09.40", "16:15.13", "34:13.08"]
x1042 = ["1042", "6:38.79", "9:19.37", "10:13.96", "10:09.73", "16:15.67", "34:14.26"]
x1041 = ["1041", "6:39.02", "9:19.68", "10:14.39", "10:10.05", "16:16.21", "34:15.43"]
x950 = ["950", "7:00.53", "9:48.31", "10:54.43", "10:40.36", "17:06.45", "36:04.72"]
x949 = ["949", "7:00.77", "9:48.63", "10:54.88", "10:40.70", "17:07.02", "36:05.95"]
x948 = ["948", "7:01.01", "9:48.95", "10:55.33", "10:41.05", "17:07.58", "36:07.18"]
x947 = ["947", "7:01.25", "9:49.27", "10:55.78", "10:41.39", "17:08.15", "36:08.41"]
x946 = ["946", "7:01.50", "9:49.60", "10:56.23", "10:41.73", "17:08.72", "36:09.64"]
x945 = ["945", "7:01.74", "9:49.92", "10:56.68", "10:42.07", "17:09.28", "36:10.88"]
x944 = ["944", "7:01.98", "9:50.24", "10:57.13", "10:42.41", "17:09.85", "36:12.11"]
x943 = ["943", "7:02.22", "9:50.56", "10:57.58", "10:42.75", "17:10.42", "36:13.34"]
x942 = ["942", "7:02.47", "9:50.89", "10:58.04", "10:43.10", "17:10.98", "36:14.58"]
x941 = ["941", "7:02.71", "9:51.21", "10:58.49", "10:43.44", "17:11.55", "36:15.81"]
x850 = ["850", "7:25.38", "10:21.40", "11:40.71", "11:15.40", "18:04.53", "38:11.05"]
x849 = ["849", "7:25.64", "10:21.74", "11:41.18", "11:15.76", "18:05.12", "38:12.35"]
x848 = ["848", "7:25.89", "10:22.08", "11:41.66", "11:16.12", "18:05.72", "38:13.65"]
x847 = ["847", "7:26.15", "10:22.42", "11:42.14", "11:16.48", "18:06.32", "38:14.95"]
x846 = ["846", "7:26.41", "10:22.76", "11:42.62", "11:16.84", "18:06.92", "38:16.25"]
x845 = ["845", "7:26.66", "10:23.10", "11:43.09", "11:17.20", "18:07.52", "38:17.55"]
x844 = ["844", "7:26.92", "10:23.44", "11:43.57", "11:17.56", "18:08.12", "38:18.86"]
x843 = ["843", "7:27.17", "10:23.78", "11:44.05", "11:17.92", "18:08.72", "38:20.16"]
x842 = ["842", "7:27.43", "10:24.12", "11:44.53", "11:18.29", "18:09.32", "38:21.47"]
x841 = ["841", "7:27.69", "10:24.47", "11:45.00", "11:18.65", "18:09.92", "38:22.77"]
x750 = ["750", "7:51.75", "10:56.50", "12:29.80", "11:52.56", "19:06.13", "40:25.05"]
x749 = ["749", "7:52.02", "10:56.86", "12:30.31", "11:52.94", "19:06.76", "40:26.43"]
x748 = ["748", "7:52.29", "10:57.22", "12:30.82", "11:53.33", "19:07.40", "40:27.82"]
x747 = ["747", "7:52.56", "10:57.58", "12:31.32", "11:53.71", "19:08.04", "40:29.20"]
x746 = ["746", "7:52.84", "10:57.95", "12:31.83", "11:54.10", "19:08.67", "40:30.59"]
x745 = ["745", "7:53.11", "10:58.31", "12:32.34", "11:54.48", "19:09.31", "40:31.98"]
x744 = ["744", "7:53.38", "10:58.67", "12:32.85", "11:54.87", "19:09.95", "40:33.37"]
x743 = ["743", "7:53.66", "10:59.04", "12:33.36", "11:55.25", "19:10.59", "40:34.76"]
x742 = ["742", "7:53.93", "10:59.40", "12:33.87", "11:55.64", "19:11.23", "40:36.15"]
x741 = ["741", "7:54.20", "10:59.77", "12:34.38", "11:56.02", "19:11.87", "40:37.54"]
x650 = ["650", "8:19.94", "11:34.02", "13:22.29", "12:32.29", "20:11.99", "42:48.33"]
x649 = ["649", "8:20.23", "11:34.41", "13:22.84", "12:32.71", "20:12.68", "42:49.81"]
x648 = ["648", "8:20.52", "11:34.80", "13:23.38", "12:33.12", "20:13.36", "42:51.30"]
x647 = ["647", "8:20.81", "11:35.19", "13:23.93", "12:33.53", "20:14.04", "42:52.79"]
x646 = ["646", "8:21.11", "11:35.58", "13:24.48", "12:33.94", "20:14.73", "42:54.28"]
x645 = ["645", "8:21.40", "11:35.97", "13:25.02", "12:34.36", "20:15.41", "42:55.77"]
x644 = ["644", "8:21.69", "11:36.37", "13:25.57", "12:34.77", "20:16.10", "42:57.26"]
x643 = ["643", "8:21.99", "11:36.76", "13:26.12", "12:35.19", "20:16.79", "42:58.76"]
x642 = ["642", "8:22.28", "11:37.15", "13:26.66", "12:35.60", "20:17.47", "43:00.25"]
x641 = ["641", "8:22.58", "11:37.54", "13:27.21", "12:36.02", "20:18.16", "43:01.75"]
x550 = ["550", "8:50.39", "12:14.57", "14:19.01", "13:15.22", "21:23.15", "45:23.12"]
x549 = ["549", "8:50.71", "12:14.99", "14:19.60", "13:15.67", "21:23.89", "45:24.73"]
x548 = ["548", "8:51.03", "12:15.42", "14:20.19", "13:16.12", "21:24.64", "45:26.35"]
x547 = ["547", "8:51.35", "12:15.84", "14:20.78", "13:16.57", "21:25.38", "45:27.97"]
x546 = ["546", "8:51.67", "12:16.27", "14:21.38", "13:17.02", "21:26.13", "45:29.59"]
x545 = ["545", "8:51.98", "12:16.69", "14:21.97", "13:17.47", "21:26.87", "45:31.21"]
x544 = ["544", "8:52.30", "12:17.12", "14:22.57", "13:17.92", "21:27.62", "45:32.84"]
x543 = ["543", "8:52.62", "12:17.54", "14:23.16", "13:18.37", "21:28.37", "45:34.46"]
x542 = ["542", "8:52.94", "12:17.97", "14:23.76", "13:18.82", "21:29.11", "45:36.09"]
x541 = ["541", "8:53.26", "12:18.39", "14:24.35", "13:19.27", "21:29.86", "45:37.72"]
x450 = ["450", "9:23.77", "12:59.00", "15:21.15", "14:02.26", "22:41.13", "48:12.75"]
x449 = ["449", "9:24.12", "12:59.47", "15:21.81", "14:02.76", "22:41.95", "48:14.54"]
x448 = ["448", "9:24.47", "12:59.94", "15:22.46", "14:03.26", "22:42.78", "48:16.33"]
x447 = ["447", "9:24.82", "13:00.41", "15:23.12", "14:03.75", "22:43.60", "48:18.12"]
x446 = ["446", "9:25.18", "13:00.88", "15:23.78", "14:04.25", "22:44.42", "48:19.91"]
x445 = ["445", "9:25.53", "13:01.35", "15:24.43", "14:04.75", "22:45.25", "48:21.70"]
x444 = ["444", "9:25.88", "13:01.82", "15:25.09", "14:05.25", "22:46.07", "48:23.50"]
x443 = ["443", "9:26.24", "13:02.29", "15:25.75", "14:05.75", "22:46.90", "48:25.30"]
x442 = ["442", "9:26.59", "13:02.76", "15:26.41", "14:06.24", "22:47.73", "48:27.10"]
x441 = ["441", "9:26.95", "13:03.23", "15:27.07", "14:06.74", "22:48.56", "48:28.90"]
x350 = ["350", "10:01.11", "13:48.71", "16:30.68", "14:54.90", "24:08.38", "51:22.54"]
x349 = ["349", "10:01.51", "13:49.24", "16:31.43", "14:55.46", "24:09.31", "51:24.56"]
x348 = ["348", "10:01.91", "13:49.78", "16:32.17", "14:56.02", "24:10.24", "51:26.59"]
x347 = ["347", "10:02.31", "13:50.31", "16:32.92", "14:56.59", "24:11.18", "51:28.63"]
x346 = ["346", "10:02.71", "13:50.84", "16:33.66", "14:57.15", "24:12.11", "51:30.66"]
x345 = ["345", "10:03.11", "13:51.38", "16:34.41", "14:57.72", "24:13.05", "51:32.70"]
x344 = ["344", "10:03.51", "13:51.91", "16:35.16", "14:58.28", "24:13.99", "51:34.74"]
x343 = ["343", "10:03.91", "13:52.45", "16:35.90", "14:58.85", "24:14.93", "51:36.78"]
x342 = ["342", "10:04.31", "13:52.98", "16:36.65", "14:59.42", "24:15.87", "51:38.83"]
x341 = ["341", "10:04.72", "13:53.52", "16:37.41", "14:59.98", "24:16.81", "51:40.88"]
x250 = ["250", "10:44.29", "14:46.21", "17:51.10", "15:55.77", "25:49.28", "55:02.03"]
x249 = ["249", "10:44.76", "14:46.83", "17:51.98", "15:56.43", "25:50.38", "55:04.42"]
x248 = ["248", "10:45.24", "14:47.46", "17:52.86", "15:57.10", "25:51.49", "55:06.83"]
x247 = ["247", "10:45.71", "14:48.09", "17:53.74", "15:57.77", "25:52.59", "55:09.23"]
x246 = ["246", "10:46.19", "14:48.73", "17:54.62", "15:58.44", "25:53.70", "55:11.65"]
x245 = ["245", "10:46.66", "14:49.36", "17:55.51", "15:59.11", "25:54.81", "55:14.07"]
x244 = ["244", "10:47.14", "14:49.99", "17:56.40", "15:59.78", "25:55.93", "55:16.49"]
x243 = ["243", "10:47.62", "14:50.63", "17:57.29", "16:00.45", "25:57.04", "55:18.92"]
x242 = ["242", "10:48.09", "14:51.27", "17:58.18", "16:01.13", "25:58.16", "55:21.35"]
x241 = ["241", "10:48.57", "14:51.91", "17:59.07", "16:01.80", "25:59.28", "55:23.79"]
x150 = ["150", "11:37.42", "15:56.93", "19:30.03", "17:10.65", "27:53.41", "59:32.05"]
x149 = ["149", "11:38.03", "15:57.75", "19:31.16", "17:11.51", "27:54.84", "59:35.15"]
x148 = ["148", "11:38.64", "15:58.56", "19:32.30", "17:12.37", "27:56.27", "59:38.26"]
x147 = ["147", "11:39.26", "15:59.38", "19:33.44", "17:13.24", "27:57.70", "59:41.38"]
x146 = ["146", "11:39.87", "16:00.20", "19:34.59", "17:14.11", "27:59.14", "59:44.51"]
x145 = ["145", "11:40.49", "16:01.02", "19:35.74", "17:14.98", "28:00.58", "59:47.65"]
x144 = ["144", "11:41.11", "16:01.85", "19:36.90", "17:15.85", "28:02.03", "59:50.80"]
x143 = ["143", "11:41.73", "16:02.67", "19:38.05", "17:16.73", "28:03.49", "59:53.96"]
x142 = ["142", "11:42.36", "16:03.50", "19:39.22", "17:17.61", "28:04.94", "59:57.14"]
x141 = ["141", "11:42.98", "16:04.34", "19:40.38", "17:18.49", "28:06.41", "1:00:00.32"]
x50 = ["50", "12:54.59", "17:39.66", "21:53.71", "18:59.42", "30:53.71", "1:06:04.25"]
x49 = ["49", "12:55.65", "17:41.07", "21:55.69", "19:00.91", "30:56.18", "1:06:09.63"]
x48 = ["48", "12:56.72", "17:42.50", "21:57.68", "19:02.42", "30:58.68", "1:06:15.07"]
x47 = ["47", "12:57.80", "17:43.94", "21:59.69", "19:03.94", "31:01.21", "1:06:20.57"]
x46 = ["46", "12:58.89", "17:45.39", "22:01.73", "19:05.49", "31:03.76", "1:06:26.12"]
x45 = ["45", "12:59.99", "17:46.87", "22:03.79", "19:07.04", "31:06.35", "1:06:31.74"]
x44 = ["44", "13:01.11", "17:48.35", "22:05.87", "19:08.62", "31:08.96", "1:06:37.42"]
x43 = ["43", "13:02.24", "17:49.86", "22:07.97", "19:10.21", "31:11.60", "1:06:43.16"]
x42 = ["42", "13:03.39", "17:51.38", "22:10.10", "19:11.82", "31:14.27", "1:06:48.97"]
x41 = ["41", "13:04.54", "17:52.92", "22:12.26", "19:13.45", "31:16.97", "1:06:54.85"]
x10 = ["10", "13:52.85", "18:57.24", "23:42.22", "20:21.55", "33:09.85", "1:11:00.40"]
x9 = ["9", "13:55.27", "19:00.46", "23:46.72", "20:24.96", "33:15.50", "1:11:12.70"]
x8 = ["8", "13:57.83", "19:03.86", "23:51.48", "20:28.56", "33:21.48", "1:11:25.70"]
x7 = ["7", "14:00.55", "19:07.49", "23:56.55", "20:32.40", "33:27.84", "1:11:39.54"]
x6 = ["6", "14:03.48", "19:11.38", "24:02.00", "20:36.53", "33:34.68", "1:11:54.41"]
x5 = ["5", "14:06.66", "19:15.62", "24:07.93", "20:41.01", "33:42.11", "1:12:10.58"]
x4 = ["4", "14:10.18", "19:20.30", "24:14.48", "20:45.97", "33:50.33", "1:12:28.46"]
x3 = ["3", "14:14.18", "19:25.62", "24:21.92", "20:51.60", "33:59.67", "1:12:48.76"]
x2 = ["2", "14:18.91", "19:31.93", "24:30.74", "20:58.28", "34:10.74", "1:13:12.85"]
x1 = ["1", "14:25.09", "19:40.15", "24:42.24", "21:06.98", "34:25.16", "1:13:44.23"]
WOMENS_LONG = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x650, x649, x648, x647, x646, x645, x644, x643, x642, x641, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x341, x250, x249, x248, x247, x246, x245, x244, x243, x242, x241, x150, x149, x148, x147, x146, x145, x144, x143, x142, x141, x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1]



xpoints = ["points", "hj", "pv", "lj", "tj", "sp", "dt", "ht", "jt", "decathlon"]
x1400 = ["1400", "-", "6.49", "-", "19.23", "24.63", "78.45", "93.92", "102.15", "9872"]
x1399 = ["1399", "-", "-", "9.28", "19.22", "24.61", "78.40", "93.86", "102.08", "9866"]
x1398 = ["1398", "-", "-", "-", "19.21", "24.60", "78.35", "93.80", "102.01", "9860"]
x1397 = ["1397", "-", "6.48", "9.27", "19.20", "24.58", "78.29", "93.73", "101.94", "9853"]
x1396 = ["1396", "2.54", "-", "-", "19.19", "24.56", "78.24", "93.67", "101.88", "9847"]
x1395 = ["1395", "-", "6.47", "9.26", "19.18", "24.55", "78.19", "93.61", "101.81", "9840"]
x1394 = ["1394", "-", "-", "-", "19.17", "24.53", "78.14", "93.54", "101.74", "9834"]
x1393 = ["1393", "-", "-", "9.25", "-", "24.51", "78.08", "93.48", "101.67", "9828"]
x1392 = ["1392", "-", "6.46", "-", "19.16", "24.50", "78.03", "93.42", "101.60", "9821"]
x1391 = ["1391", "-", "-", "9.24", "19.15", "24.48", "77.98", "93.36", "101.53", "9815"]
x1350 = ["1350", "-", "6.32", "9.05", "18.78", "23.80", "75.82", "90.77", "98.73", "9552"]
x1349 = ["1349", "-", "-", "-", "18.77", "23.79", "75.77", "90.71", "98.66", "9546"]
x1348 = ["1348", "-", "-", "9.04", "18.76", "23.77", "75.72", "90.65", "98.59", "9540"]
x1347 = ["1347", "-", "6.31", "-", "18.75", "23.76", "75.67", "90.58", "98.53", "9533"]
x1346 = ["1346", "2.49", "-", "-", "18.74", "23.74", "75.61", "90.52", "98.46", "9527"]
x1345 = ["1345", "-", "-", "9.03", "18.73", "23.72", "75.56", "90.46", "98.39", "9520"]
x1344 = ["1344", "-", "6.30", "-", "18.72", "23.71", "75.51", "90.39", "98.32", "9514"]
x1343 = ["1343", "-", "-", "9.02", "18.71", "23.69", "75.46", "90.33", "98.25", "9508"]
x1342 = ["1342", "-", "-", "-", "18.70", "23.67", "75.40", "90.27", "98.18", "9501"]
x1341 = ["1341", "-", "6.29", "9.01", "-", "23.66", "75.35", "90.21", "98.12", "9495"]
x1300 = ["1300", "-", "6.15", "8.82", "18.32", "22.98", "73.19", "87.62", "95.31", "9231"]
x1299 = ["1299", "-", "-", "-", "18.31", "22.96", "73.14", "87.56", "95.24", "9225"]
x1298 = ["1298", "-", "-", "8.81", "-", "22.95", "73.09", "87.49", "95.17", "9218"]
x1297 = ["1297", "-", "6.14", "-", "18.30", "22.93", "73.04", "87.43", "95.10", "9212"]
x1296 = ["1296", "2.44", "-", "8.80", "18.29", "22.91", "72.98", "87.37", "95.04", "9205"]
x1295 = ["1295", "-", "-", "-", "18.28", "22.90", "72.93", "87.31", "94.97", "9199"]
x1294 = ["1294", "-", "6.13", "8.79", "18.27", "22.88", "72.88", "87.24", "94.90", "9193"]
x1293 = ["1293", "-", "-", "-", "18.26", "22.86", "72.82", "87.18", "94.83", "9186"]
x1292 = ["1292", "-", "-", "8.78", "18.25", "22.85", "72.77", "87.12", "94.76", "9180"]
x1291 = ["1291", "-", "6.12", "-", "18.24", "22.83", "72.72", "87.05", "94.69", "9173"]
x1250 = ["1250", "-", "5.98", "-", "17.87", "22.15", "70.56", "84.46", "91.88", "8909"]
x1249 = ["1249", "-", "-", "8.58", "17.86", "22.14", "70.51", "84.40", "91.82", "8902"]
x1248 = ["1248", "-", "-", "-", "17.85", "22.12", "70.45", "84.34", "91.75", "8896"]
x1247 = ["1247", "-", "5.97", "8.57", "17.84", "22.10", "70.40", "84.27", "91.68", "8889"]
x1246 = ["1246", "2.39", "-", "-", "17.83", "22.09", "70.35", "84.21", "91.61", "8883"]
x1245 = ["1245", "-", "-", "8.56", "17.82", "22.07", "70.29", "84.15", "91.54", "8876"]
x1244 = ["1244", "-", "5.96", "-", "17.81", "22.05", "70.24", "84.09", "91.47", "8870"]
x1243 = ["1243", "-", "-", "8.55", "17.80", "22.04", "70.19", "84.02", "91.40", "8863"]
x1242 = ["1242", "-", "-", "-", "17.79", "22.02", "70.14", "83.96", "91.34", "8857"]
x1241 = ["1241", "-", "5.95", "-", "-", "22.00", "70.08", "83.90", "91.27", "8851"]
x1200 = ["1200", "-", "5.81", "8.35", "17.41", "21.32", "67.92", "81.30", "88.45", "8585"]
x1199 = ["1199", "-", "-", "-", "17.40", "21.31", "67.87", "81.24", "88.39", "8578"]
x1198 = ["1198", "-", "-", "8.34", "17.39", "21.29", "67.82", "81.18", "88.32", "8572"]
x1197 = ["1197", "2.34", "5.80", "-", "17.38", "21.27", "67.76", "81.11", "88.25", "8565"]
x1196 = ["1196", "-", "-", "8.33", "17.37", "21.26", "67.71", "81.05", "88.18", "8559"]
x1195 = ["1195", "-", "-", "-", "17.36", "21.24", "67.66", "80.99", "88.11", "8552"]
x1194 = ["1194", "-", "5.79", "8.32", "-", "21.23", "67.60", "80.92", "88.04", "8546"]
x1193 = ["1193", "-", "-", "-", "17.35", "21.21", "67.55", "80.86", "87.97", "8539"]
x1192 = ["1192", "-", "-", "8.31", "17.34", "21.19", "67.50", "80.80", "87.91", "8533"]
x1191 = ["1191", "-", "5.78", "-", "17.33", "21.18", "67.45", "80.73", "87.84", "8526"]
x1150 = ["1150", "-", "-", "-", "16.95", "20.50", "65.28", "78.14", "85.02", "8260"]
x1149 = ["1149", "-", "-", "8.11", "16.94", "20.48", "65.23", "78.08", "84.95", "8253"]
x1148 = ["1148", "2.29", "5.63", "-", "16.93", "20.46", "65.17", "78.01", "84.88", "8247"]
x1147 = ["1147", "-", "-", "8.10", "16.92", "20.45", "65.12", "77.95", "84.81", "8240"]
x1146 = ["1146", "-", "-", "-", "16.91", "20.43", "65.07", "77.89", "84.75", "8234"]
x1145 = ["1145", "-", "5.62", "8.09", "-", "20.41", "65.02", "77.82", "84.68", "8227"]
x1144 = ["1144", "-", "-", "-", "16.90", "20.40", "64.96", "77.76", "84.61", "8221"]
x1143 = ["1143", "-", "-", "8.08", "16.89", "20.38", "64.91", "77.70", "84.54", "8214"]
x1142 = ["1142", "-", "5.61", "-", "16.88", "20.36", "64.86", "77.63", "84.47", "8208"]
x1141 = ["1141", "-", "-", "8.07", "16.87", "20.35", "64.80", "77.57", "84.40", "8201"]
x1100 = ["1100", "-", "-", "-", "16.49", "19.67", "62.64", "74.97", "81.58", "7933"]
x1099 = ["1099", "-", "-", "-", "16.48", "19.65", "62.58", "74.91", "81.51", "7927"]
x1098 = ["1098", "2.24", "5.46", "7.87", "16.47", "19.63", "62.53", "74.85", "81.45", "7920"]
x1097 = ["1097", "-", "-", "-", "16.46", "19.62", "62.48", "74.78", "81.38", "7914"]
x1096 = ["1096", "-", "-", "7.86", "16.45", "19.60", "62.43", "74.72", "81.31", "7907"]
x1095 = ["1095", "-", "5.45", "-", "16.44", "19.58", "62.37", "74.66", "81.24", "7901"]
x1094 = ["1094", "-", "-", "7.85", "-", "19.57", "62.32", "74.59", "81.17", "7894"]
x1093 = ["1093", "-", "5.44", "-", "16.43", "19.55", "62.27", "74.53", "81.10", "7888"]
x1092 = ["1092", "-", "-", "7.84", "16.42", "19.53", "62.21", "74.47", "81.03", "7881"]
x1091 = ["1091", "-", "-", "-", "16.41", "19.52", "62.16", "74.40", "80.96", "7874"]
x1050 = ["1050", "2.19", "-", "7.64", "16.03", "18.84", "59.99", "71.80", "78.14", "7606"]
x1049 = ["1049", "-", "5.29", "-", "16.02", "18.82", "59.94", "71.74", "78.07", "7599"]
x1048 = ["1048", "-", "-", "7.63", "16.01", "18.80", "59.88", "71.67", "78.00", "7592"]
x1047 = ["1047", "-", "-", "-", "16.00", "18.79", "59.83", "71.61", "77.94", "7586"]
x1046 = ["1046", "-", "5.28", "7.62", "15.99", "18.77", "59.78", "71.55", "77.87", "7579"]
x1045 = ["1045", "-", "-", "-", "15.98", "18.75", "59.73", "71.48", "77.80", "7573"]
x1044 = ["1044", "-", "-", "7.61", "15.97", "18.74", "59.67", "71.42", "77.73", "7566"]
x1043 = ["1043", "-", "5.27", "-", "15.96", "18.72", "59.62", "71.36", "77.66", "7560"]
x1042 = ["1042", "-", "-", "7.60", "15.95", "18.70", "59.57", "71.29", "77.59", "7553"]
x1041 = ["1041", "-", "-", "-", "15.94", "18.69", "59.51", "71.23", "77.52", "7546"]
x1000 = ["1000", "-", "5.12", "7.40", "15.56", "18.00", "57.34", "68.63", "74.70", "7276"]
x999 = ["999", "-", "-", "-", "15.55", "17.99", "57.29", "68.56", "74.63", "7270"]
x998 = ["998", "-", "-", "7.39", "15.54", "17.97", "57.23", "68.50", "74.56", "7263"]
x997 = ["997", "-", "5.11", "-", "-", "17.95", "57.18", "68.44", "74.49", "7257"]
x996 = ["996", "-", "-", "7.38", "15.53", "17.94", "57.13", "68.37", "74.42", "7250"]
x995 = ["995", "-", "-", "-", "15.52", "17.92", "57.07", "68.31", "74.35", "7243"]
x994 = ["994", "-", "5.10", "7.37", "15.51", "17.90", "57.02", "68.25", "74.28", "7237"]
x993 = ["993", "-", "-", "-", "15.50", "17.89", "56.97", "68.18", "74.21", "7230"]
x992 = ["992", "-", "5.09", "-", "15.49", "17.87", "56.92", "68.12", "74.14", "7224"]
x991 = ["991", "2.13", "-", "7.36", "15.48", "17.85", "56.86", "68.05", "74.08", "7217"]
x950 = ["950", "-", "-", "7.16", "15.10", "17.17", "54.69", "65.45", "71.25", "6946"]
x949 = ["949", "-", "4.94", "-", "15.09", "17.15", "54.63", "65.38", "71.18", "6939"]
x948 = ["948", "-", "-", "7.15", "15.08", "17.14", "54.58", "65.32", "71.11", "6933"]
x947 = ["947", "-", "-", "-", "15.07", "17.12", "54.53", "65.26", "71.04", "6926"]
x946 = ["946", "-", "4.93", "7.14", "15.06", "17.10", "54.47", "65.19", "70.97", "6919"]
x945 = ["945", "-", "-", "-", "15.05", "17.09", "54.42", "65.13", "70.90", "6913"]
x944 = ["944", "-", "-", "-", "15.04", "17.07", "54.37", "65.07", "70.83", "6906"]
x943 = ["943", "2.08", "4.92", "7.13", "15.03", "17.05", "54.32", "65.00", "70.76", "6900"]
x942 = ["942", "-", "-", "-", "15.02", "17.04", "54.26", "64.94", "70.69", "6893"]
x941 = ["941", "-", "-", "7.12", "15.01", "17.02", "54.21", "64.88", "70.62", "6886"]
x850 = ["850", "-", "-", "6.68", "14.16", "15.50", "49.37", "59.08", "64.33", "6281"]
x849 = ["849", "-", "4.59", "-", "14.15", "15.49", "49.32", "59.01", "64.26", "6274"]
x848 = ["848", "-", "-", "6.67", "14.14", "15.47", "49.26", "58.95", "64.20", "6267"]
x847 = ["847", "-", "-", "-", "14.13", "15.45", "49.21", "58.89", "64.13", "6261"]
x846 = ["846", "1.98", "4.58", "6.66", "14.12", "15.44", "49.16", "58.82", "64.06", "6254"]
x845 = ["845", "-", "-", "-", "14.11", "15.42", "49.10", "58.76", "63.99", "6247"]
x844 = ["844", "-", "-", "6.65", "14.10", "15.40", "49.05", "58.70", "63.92", "6241"]
x843 = ["843", "-", "4.57", "-", "14.09", "15.39", "49.00", "58.63", "63.85", "6234"]
x842 = ["842", "-", "-", "6.64", "14.08", "15.37", "48.95", "58.57", "63.78", "6227"]
x841 = ["841", "-", "-", "-", "14.07", "15.35", "48.89", "58.50", "63.71", "6221"]
x750 = ["750", "-", "4.24", "-", "13.21", "13.83", "44.04", "52.69", "57.41", "5610"]
x749 = ["749", "-", "-", "6.19", "13.20", "13.81", "43.99", "52.63", "57.34", "5603"]
x748 = ["748", "-", "-", "-", "13.19", "13.80", "43.94", "52.57", "57.27", "5596"]
x747 = ["747", "-", "4.23", "6.18", "13.18", "13.78", "43.88", "52.50", "57.20", "5590"]
x746 = ["746", "-", "-", "-", "13.17", "13.76", "43.83", "52.44", "57.13", "5583"]
x745 = ["745", "-", "-", "6.17", "13.16", "13.75", "43.78", "52.37", "57.06", "5576"]
x744 = ["744", "-", "4.22", "-", "13.15", "13.73", "43.72", "52.31", "56.99", "5569"]
x743 = ["743", "-", "-", "6.16", "13.14", "13.71", "43.67", "52.25", "56.92", "5563"]
x742 = ["742", "-", "-", "-", "13.13", "13.70", "43.62", "52.18", "56.85", "5556"]
x741 = ["741", "1.87", "4.21", "6.15", "13.12", "13.68", "43.56", "52.12", "56.78", "5549"]
x650 = ["650", "-", "-", "5.70", "12.25", "12.15", "38.70", "46.29", "50.46", "4933"]
x649 = ["649", "-", "3.88", "-", "12.24", "12.14", "38.65", "46.23", "50.39", "4926"]
x648 = ["648", "-", "-", "5.69", "12.23", "12.12", "38.59", "46.17", "50.32", "4919"]
x647 = ["647", "-", "-", "-", "-", "12.10", "38.54", "46.10", "50.25", "4913"]
x646 = ["646", "1.77", "3.87", "5.68", "12.22", "12.09", "38.49", "46.04", "50.18", "4906"]
x645 = ["645", "-", "-", "-", "12.21", "12.07", "38.43", "45.97", "50.11", "4899"]
x644 = ["644", "-", "-", "5.67", "12.20", "12.05", "38.38", "45.91", "50.04", "4892"]
x643 = ["643", "-", "3.86", "-", "12.19", "12.04", "38.33", "45.85", "49.97", "4885"]
x642 = ["642", "-", "-", "5.66", "12.18", "12.02", "38.27", "45.78", "49.90", "4879"]
x641 = ["641", "-", "3.85", "-", "12.17", "12.00", "38.22", "45.72", "49.83", "4872"]
x550 = ["550", "-", "-", "-", "11.29", "10.47", "33.35", "39.88", "43.50", "4250"]
x549 = ["549", "-", "3.52", "5.20", "11.28", "10.46", "33.29", "39.82", "43.43", "4243"]
x548 = ["548", "-", "-", "-", "11.27", "10.44", "33.24", "39.75", "43.36", "4237"]
x547 = ["547", "-", "-", "5.19", "11.26", "10.42", "33.19", "39.69", "43.29", "4230"]
x546 = ["546", "-", "3.51", "-", "11.25", "10.41", "33.13", "39.62", "43.22", "4223"]
x545 = ["545", "-", "-", "5.18", "11.24", "10.39", "33.08", "39.56", "43.15", "4216"]
x544 = ["544", "-", "3.50", "-", "11.23", "10.37", "33.02", "39.49", "43.08", "4209"]
x543 = ["543", "1.66", "-", "5.17", "11.22", "10.36", "32.97", "39.43", "43.01", "4202"]
x542 = ["542", "-", "-", "-", "11.21", "10.34", "32.92", "39.37", "42.94", "4195"]
x541 = ["541", "-", "3.49", "5.16", "11.20", "10.32", "32.86", "39.30", "42.87", "4189"]
x450 = ["450", "1.56", "3.16", "-", "10.32", "8.79", "27.98", "33.45", "36.52", "3561"]
x449 = ["449", "-", "-", "4.70", "10.31", "8.77", "27.93", "33.38", "36.45", "3554"]
x448 = ["448", "-", "-", "-", "10.30", "8.76", "27.87", "33.32", "36.38", "3547"]
x447 = ["447", "-", "3.15", "4.69", "10.29", "8.74", "27.82", "33.26", "36.31", "3541"]
x446 = ["446", "-", "-", "-", "10.28", "8.72", "27.76", "33.19", "36.24", "3534"]
x445 = ["445", "-", "-", "4.68", "10.27", "8.71", "27.71", "33.13", "36.17", "3527"]
x444 = ["444", "-", "3.14", "-", "10.26", "8.69", "27.66", "33.06", "36.10", "3520"]
x443 = ["443", "-", "-", "4.67", "10.25", "8.67", "27.60", "33.00", "36.03", "3513"]
x442 = ["442", "-", "3.13", "-", "10.24", "8.65", "27.55", "32.93", "35.96", "3506"]
x441 = ["441", "1.55", "-", "4.66", "10.23", "8.64", "27.50", "32.87", "35.89", "3499"]
x350 = ["350", "-", "-", "-", "9.34", "7.10", "22.60", "27.00", "29.52", "2866"]
x349 = ["349", "-", "2.79", "4.20", "9.33", "7.08", "22.54", "26.94", "29.45", "2859"]
x348 = ["348", "1.45", "-", "-", "9.32", "7.07", "22.49", "26.87", "29.38", "2852"]
x347 = ["347", "-", "-", "4.19", "9.31", "7.05", "22.44", "26.81", "29.31", "2845"]
x346 = ["346", "-", "2.78", "-", "9.30", "7.03", "22.38", "26.74", "29.24", "2838"]
x345 = ["345", "-", "-", "4.18", "9.29", "7.02", "22.33", "26.68", "29.17", "2831"]
x344 = ["344", "-", "2.77", "-", "9.28", "7.00", "22.28", "26.61", "29.10", "2824"]
x343 = ["343", "-", "-", "4.17", "9.27", "6.98", "22.22", "26.55", "29.03", "2817"]
x342 = ["342", "-", "-", "4.16", "9.26", "6.97", "22.17", "26.49", "28.96", "2810"]
x341 = ["341", "-", "2.76", "-", "9.25", "6.95", "22.11", "26.42", "28.89", "2803"]
x250 = ["250", "-", "-", "-", "8.34", "5.41", "17.20", "20.54", "22.51", "2164"]
x249 = ["249", "-", "2.42", "3.69", "8.33", "5.39", "17.15", "20.47", "22.44", "2157"]
x248 = ["248", "1.34", "-", "-", "8.32", "5.37", "17.10", "20.41", "22.37", "2150"]
x247 = ["247", "-", "-", "3.68", "8.31", "5.36", "17.04", "20.35", "22.30", "2143"]
x246 = ["246", "-", "2.41", "-", "8.30", "5.34", "16.99", "20.28", "22.23", "2136"]
x245 = ["245", "-", "-", "3.67", "8.29", "5.32", "16.93", "20.22", "22.16", "2129"]
x244 = ["244", "-", "2.40", "-", "8.28", "5.31", "16.88", "20.15", "22.09", "2122"]
x243 = ["243", "-", "-", "3.66", "8.27", "5.29", "16.83", "20.09", "22.02", "2115"]
x242 = ["242", "-", "-", "-", "8.26", "5.27", "16.77", "20.02", "21.95", "2108"]
x241 = ["241", "-", "2.39", "3.65", "8.25", "5.26", "16.72", "19.96", "21.88", "2101"]
x150 = ["150", "-", "2.05", "3.18", "7.34", "3.71", "11.80", "14.06", "15.48", "1456"]
x149 = ["149", "-", "-", "-", "7.33", "3.69", "11.74", "14.00", "15.41", "1448"]
x148 = ["148", "1.23", "-", "3.17", "7.32", "3.68", "11.69", "13.93", "15.34", "1441"]
x147 = ["147", "-", "2.04", "-", "7.31", "3.66", "11.63", "13.87", "15.27", "1434"]
x146 = ["146", "-", "-", "3.16", "7.30", "3.64", "11.58", "13.80", "15.20", "1427"]
x145 = ["145", "-", "2.03", "-", "7.29", "3.63", "11.53", "13.74", "15.13", "1420"]
x144 = ["144", "-", "-", "3.15", "7.28", "3.61", "11.47", "13.67", "15.05", "1413"]
x143 = ["143", "-", "-", "-", "7.27", "3.59", "11.42", "13.61", "14.98", "1406"]
x142 = ["142", "-", "2.02", "3.14", "7.26", "3.58", "11.36", "13.54", "14.91", "1399"]
x141 = ["141", "-", "-", "-", "7.25", "3.56", "11.31", "13.48", "14.84", "1391"]
x50 = ["50", "1.12", "-", "2.66", "6.33", "2.01", "6.38", "7.57", "8.43", "740"]
x49 = ["49", "-", "1.67", "-", "6.32", "1.99", "6.32", "7.50", "8.36", "733"]
x48 = ["48", "-", "-", "2.65", "6.31", "1.98", "6.27", "7.44", "8.29", "726"]
x47 = ["47", "-", "1.66", "-", "6.30", "1.96", "6.21", "7.37", "8.22", "718"]
x46 = ["46", "-", "-", "2.64", "6.29", "1.94", "6.16", "7.31", "8.15", "711"]
x45 = ["45", "-", "-", "-", "6.28", "1.92", "6.11", "7.24", "8.08", "704"]
x44 = ["44", "-", "1.65", "2.63", "6.27", "1.91", "6.05", "7.18", "8.01", "697"]
x43 = ["43", "-", "-", "-", "6.26", "1.89", "6.00", "7.11", "7.93", "690"]
x42 = ["42", "-", "1.64", "2.62", "6.25", "1.87", "5.94", "7.05", "7.86", "683"]
x41 = ["41", "1.11", "-", "-", "6.24", "1.86", "5.89", "6.98", "7.79", "675"]
x10 = ["10", "-", "1.52", "2.45", "5.93", "1.33", "4.20", "4.96", "5.60", "452"]
x9 = ["9", "-", "-", "-", "5.92", "1.31", "4.15", "4.90", "5.53", "445"]
x8 = ["8", "-", "-", "2.44", "5.91", "1.29", "4.10", "4.83", "5.46", "437"]
x7 = ["7", "-", "1.51", "-", "5.90", "1.28", "4.04", "4.77", "5.39", "430"]
x6 = ["6", "-", "-", "2.43", "5.89", "1.26", "3.99", "4.70", "5.32", "423"]
x5 = ["5", "1.07", "1.50", "-", "5.88", "1.24", "3.93", "4.64", "5.25", "416"]
x4 = ["4", "-", "-", "2.42", "5.87", "1.23", "3.88", "4.57", "5.18", "409"]
x3 = ["3", "-", "-", "-", "5.86", "1.21", "3.82", "4.51", "5.11", "401"]
x2 = ["2", "-", "1.49", "2.41", "5.84", "1.19", "3.77", "4.44", "5.04", "394"]
x1 = ["1", "-", "-", "-", "5.83", "1.18", "3.72", "4.38", "4.97", "387"]
MENS_FIELD = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1300, x1299, x1298, x1297, x1296, x1295, x1294, x1293, x1292, x1291, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1200, x1199, x1198, x1197, x1196, x1195, x1194, x1193, x1192, x1191, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1100, x1099, x1098, x1097, x1096, x1095, x1094, x1093, x1092, x1091, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x1000, x999, x998, x997, x996, x995, x994, x993, x992, x991, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x650, x649, x648, x647, x646, x645, x644, x643, x642, x641, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x341, x250, x249, x248, x247, x246, x245, x244, x243, x242, x241, x150, x149, x148, x147, x146, x145, x144, x143, x142, x141, x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1]



xpoints = ["points", "100m", "110mH", "200m", "300m", "400m", "400mH", "4x100m", "4x200m", "4x400m"]
x1400 = ["1400", "-", "-", "-", "29.45", "41.72", "44.57", "35.87", "1:15.42", "2:47.04"]
x1399 = ["1399", "-", "12.26", "18.92", "29.46", "41.73", "44.58", "35.88", "1:15.44", "2:47.10"]
x1398 = ["1398", "9.52", "-", "18.93", "29.47", "41.75", "44.60", "35.89", "1:15.46", "2:47.15"]
x1397 = ["1397", "-", "12.27", "-", "29.48", "41.76", "44.62", "35.90", "1:15.49", "2:47.21"]
x1396 = ["1396", "-", "-", "18.94", "29.49", "41.78", "44.64", "35.91", "1:15.51", "2:47.27"]
x1395 = ["1395", "-", "12.28", "18.95", "29.50", "41.79", "44.66", "35.93", "1:15.54", "2:47.33"]
x1394 = ["1394", "9.53", "-", "-", "29.51", "41.80", "44.68", "35.94", "1:15.56", "2:47.38"]
x1393 = ["1393", "-", "12.29", "18.96", "29.52", "41.82", "44.70", "35.95", "1:15.59", "2:47.44"]
x1392 = ["1392", "-", "-", "-", "29.54", "41.83", "44.72", "35.96", "1:15.61", "2:47.50"]
x1391 = ["1391", "-", "12.30", "18.97", "29.55", "41.85", "44.73", "35.98", "1:15.64", "2:47.56"]
x1350 = ["1350", "-", "-", "-", "29.98", "42.44", "45.51", "36.48", "1:16.65", "2:49.94"]
x1349 = ["1349", "-", "12.51", "19.23", "29.99", "42.46", "45.53", "36.49", "1:16.68", "2:50.00"]
x1348 = ["1348", "-", "-", "19.24", "30.00", "42.47", "45.55", "36.51", "1:16.70", "2:50.06"]
x1347 = ["1347", "9.65", "12.52", "-", "30.02", "42.49", "45.57", "36.52", "1:16.73", "2:50.12"]
x1346 = ["1346", "-", "-", "19.25", "30.03", "42.50", "45.59", "36.53", "1:16.75", "2:50.17"]
x1345 = ["1345", "-", "12.53", "-", "30.04", "42.52", "45.61", "36.54", "1:16.78", "2:50.23"]
x1344 = ["1344", "-", "-", "19.26", "30.05", "42.53", "45.62", "36.56", "1:16.80", "2:50.29"]
x1343 = ["1343", "9.66", "12.54", "19.27", "30.06", "42.55", "45.64", "36.57", "1:16.83", "2:50.35"]
x1342 = ["1342", "-", "-", "-", "30.07", "42.56", "45.66", "36.58", "1:16.85", "2:50.41"]
x1341 = ["1341", "-", "12.55", "19.28", "30.08", "42.58", "45.68", "36.59", "1:16.88", "2:50.47"]
x1300 = ["1300", "-", "-", "19.54", "30.53", "43.18", "46.47", "37.11", "1:17.91", "2:52.89"]
x1299 = ["1299", "-", "12.76", "-", "30.54", "43.20", "46.49", "37.12", "1:17.94", "2:52.95"]
x1298 = ["1298", "-", "-", "19.55", "30.55", "43.21", "46.51", "37.13", "1:17.96", "2:53.01"]
x1297 = ["1297", "9.78", "12.77", "19.56", "30.56", "43.23", "46.53", "37.14", "1:17.99", "2:53.07"]
x1296 = ["1296", "-", "-", "-", "30.57", "43.24", "46.55", "37.16", "1:18.01", "2:53.13"]
x1295 = ["1295", "-", "12.78", "19.57", "30.58", "43.26", "46.57", "37.17", "1:18.04", "2:53.19"]
x1294 = ["1294", "-", "-", "-", "30.59", "43.27", "46.59", "37.18", "1:18.06", "2:53.25"]
x1293 = ["1293", "9.79", "12.79", "19.58", "30.60", "43.29", "46.61", "37.20", "1:18.09", "2:53.31"]
x1292 = ["1292", "-", "-", "19.59", "30.61", "43.30", "46.63", "37.21", "1:18.11", "2:53.37"]
x1291 = ["1291", "-", "12.80", "-", "30.62", "43.32", "46.65", "37.22", "1:18.14", "2:53.43"]
x1250 = ["1250", "-", "13.01", "19.86", "31.08", "43.94", "47.45", "37.75", "1:19.19", "2:55.91"]
x1249 = ["1249", "-", "-", "-", "31.09", "43.95", "47.47", "37.76", "1:19.22", "2:55.97"]
x1248 = ["1248", "9.91", "13.02", "19.87", "31.10", "43.97", "47.49", "37.77", "1:19.25", "2:56.03"]
x1247 = ["1247", "-", "13.03", "19.88", "31.11", "43.98", "47.51", "37.78", "1:19.27", "2:56.09"]
x1246 = ["1246", "-", "-", "-", "31.12", "44.00", "47.53", "37.80", "1:19.30", "2:56.15"]
x1245 = ["1245", "-", "13.04", "19.89", "31.13", "44.01", "47.55", "37.81", "1:19.32", "2:56.21"]
x1244 = ["1244", "9.92", "-", "-", "31.15", "44.03", "47.57", "37.82", "1:19.35", "2:56.27"]
x1243 = ["1243", "-", "13.05", "19.90", "31.16", "44.04", "47.59", "37.84", "1:19.37", "2:56.33"]
x1242 = ["1242", "-", "-", "19.91", "31.17", "44.06", "47.61", "37.85", "1:19.40", "2:56.39"]
x1241 = ["1241", "9.93", "13.06", "-", "31.18", "44.07", "47.63", "37.86", "1:19.43", "2:56.45"]
x1200 = ["1200", "10.04", "-", "-", "31.64", "44.71", "48.45", "38.40", "1:20.50", "2:58.98"]
x1199 = ["1199", "-", "13.28", "20.19", "31.65", "44.72", "48.47", "38.41", "1:20.53", "2:59.04"]
x1198 = ["1198", "-", "-", "20.20", "31.66", "44.74", "48.49", "38.42", "1:20.56", "2:59.10"]
x1197 = ["1197", "-", "13.29", "-", "31.68", "44.75", "48.52", "38.44", "1:20.58", "2:59.17"]
x1196 = ["1196", "10.05", "-", "20.21", "31.69", "44.77", "48.54", "38.45", "1:20.61", "2:59.23"]
x1195 = ["1195", "-", "13.30", "-", "31.70", "44.78", "48.56", "38.46", "1:20.63", "2:59.29"]
x1194 = ["1194", "-", "-", "20.22", "31.71", "44.80", "48.58", "38.48", "1:20.66", "2:59.35"]
x1193 = ["1193", "10.06", "13.31", "20.23", "31.72", "44.81", "48.60", "38.49", "1:20.69", "2:59.41"]
x1192 = ["1192", "-", "-", "-", "31.73", "44.83", "48.62", "38.50", "1:20.71", "2:59.48"]
x1191 = ["1191", "-", "13.32", "20.24", "31.74", "44.85", "48.64", "38.52", "1:20.74", "2:59.54"]
x1150 = ["1150", "-", "13.54", "-", "32.22", "45.49", "49.48", "39.06", "1:21.84", "3:02.12"]
x1149 = ["1149", "10.18", "13.55", "20.52", "32.23", "45.51", "49.50", "39.08", "1:21.87", "3:02.18"]
x1148 = ["1148", "-", "-", "20.53", "32.24", "45.52", "49.52", "39.09", "1:21.89", "3:02.24"]
x1147 = ["1147", "-", "13.56", "20.54", "32.25", "45.54", "49.54", "39.10", "1:21.92", "3:02.31"]
x1146 = ["1146", "10.19", "-", "-", "32.26", "45.55", "49.56", "39.12", "1:21.95", "3:02.37"]
x1145 = ["1145", "-", "13.57", "20.55", "32.28", "45.57", "49.58", "39.13", "1:21.97", "3:02.43"]
x1144 = ["1144", "-", "-", "20.56", "32.29", "45.59", "49.60", "39.14", "1:22.00", "3:02.50"]
x1143 = ["1143", "-", "13.58", "-", "32.30", "45.60", "49.62", "39.16", "1:22.03", "3:02.56"]
x1142 = ["1142", "10.20", "-", "20.57", "32.31", "45.62", "49.64", "39.17", "1:22.06", "3:02.62"]
x1141 = ["1141", "-", "13.59", "20.58", "32.32", "45.63", "49.66", "39.18", "1:22.08", "3:02.69"]
x1100 = ["1100", "10.32", "-", "20.86", "32.81", "46.29", "50.52", "39.74", "1:23.21", "3:05.32"]
x1099 = ["1099", "-", "13.82", "-", "32.82", "46.31", "50.54", "39.76", "1:23.23", "3:05.39"]
x1098 = ["1098", "-", "-", "20.87", "32.83", "46.33", "50.56", "39.77", "1:23.26", "3:05.45"]
x1097 = ["1097", "-", "13.83", "20.88", "32.84", "46.34", "50.58", "39.78", "1:23.29", "3:05.52"]
x1096 = ["1096", "10.33", "13.84", "-", "32.85", "46.36", "50.61", "39.80", "1:23.32", "3:05.58"]
x1095 = ["1095", "-", "-", "20.89", "32.87", "46.37", "50.63", "39.81", "1:23.34", "3:05.65"]
x1094 = ["1094", "-", "13.85", "20.90", "32.88", "46.39", "50.65", "39.83", "1:23.37", "3:05.71"]
x1093 = ["1093", "10.34", "-", "-", "32.89", "46.41", "50.67", "39.84", "1:23.40", "3:05.78"]
x1092 = ["1092", "-", "13.86", "20.91", "32.90", "46.42", "50.69", "39.85", "1:23.43", "3:05.84"]
x1091 = ["1091", "-", "-", "20.92", "32.91", "46.44", "50.71", "39.87", "1:23.45", "3:05.91"]
x1050 = ["1050", "-", "-", "-", "33.41", "47.11", "51.59", "40.44", "1:24.60", "3:08.60"]
x1049 = ["1049", "-", "14.10", "21.21", "33.42", "47.13", "51.61", "40.45", "1:24.63", "3:08.67"]
x1048 = ["1048", "10.47", "-", "21.22", "33.43", "47.15", "51.63", "40.47", "1:24.66", "3:08.74"]
x1047 = ["1047", "-", "14.11", "-", "33.45", "47.16", "51.65", "40.48", "1:24.69", "3:08.80"]
x1046 = ["1046", "-", "14.12", "21.23", "33.46", "47.18", "51.68", "40.49", "1:24.72", "3:08.87"]
x1045 = ["1045", "-", "-", "21.24", "33.47", "47.20", "51.70", "40.51", "1:24.74", "3:08.94"]
x1044 = ["1044", "10.48", "14.13", "21.25", "33.48", "47.21", "51.72", "40.52", "1:24.77", "3:09.00"]
x1043 = ["1043", "-", "-", "-", "33.49", "47.23", "51.74", "40.54", "1:24.80", "3:09.07"]
x1042 = ["1042", "-", "14.14", "21.26", "33.51", "47.25", "51.76", "40.55", "1:24.83", "3:09.14"]
x1041 = ["1041", "10.49", "-", "21.27", "33.52", "47.26", "51.78", "40.56", "1:24.86", "3:09.20"]
x1000 = ["1000", "-", "14.38", "21.56", "34.03", "47.95", "52.68", "41.15", "1:26.03", "3:11.96"]
x999 = ["999", "-", "14.39", "21.57", "34.04", "47.97", "52.71", "41.16", "1:26.06", "3:12.03"]
x998 = ["998", "-", "-", "-", "34.05", "47.99", "52.73", "41.18", "1:26.09", "3:12.10"]
x997 = ["997", "10.62", "14.40", "21.58", "34.06", "48.01", "52.75", "41.19", "1:26.12", "3:12.17"]
x996 = ["996", "-", "-", "21.59", "34.08", "48.02", "52.77", "41.21", "1:26.15", "3:12.23"]
x995 = ["995", "-", "14.41", "21.60", "34.09", "48.04", "52.79", "41.22", "1:26.18", "3:12.30"]
x994 = ["994", "10.63", "14.42", "-", "34.10", "48.06", "52.82", "41.24", "1:26.21", "3:12.37"]
x993 = ["993", "-", "-", "21.61", "34.11", "48.07", "52.84", "41.25", "1:26.24", "3:12.44"]
x992 = ["992", "-", "14.43", "21.62", "34.13", "48.09", "52.86", "41.27", "1:26.27", "3:12.51"]
x991 = ["991", "10.64", "-", "-", "34.14", "48.11", "52.88", "41.28", "1:26.30", "3:12.58"]
x950 = ["950", "-", "-", "21.93", "34.66", "48.82", "53.81", "41.88", "1:27.50", "3:15.41"]
x949 = ["949", "-", "14.68", "-", "34.67", "48.83", "53.83", "41.90", "1:27.53", "3:15.48"]
x948 = ["948", "10.77", "14.69", "21.94", "34.68", "48.85", "53.85", "41.91", "1:27.56", "3:15.55"]
x947 = ["947", "-", "-", "21.95", "34.70", "48.87", "53.87", "41.93", "1:27.59", "3:15.62"]
x946 = ["946", "-", "14.70", "-", "34.71", "48.89", "53.90", "41.94", "1:27.62", "3:15.69"]
x945 = ["945", "10.78", "-", "21.96", "34.72", "48.90", "53.92", "41.95", "1:27.65", "3:15.76"]
x944 = ["944", "-", "14.71", "21.97", "34.73", "48.92", "53.94", "41.97", "1:27.68", "3:15.83"]
x943 = ["943", "-", "14.72", "21.98", "34.75", "48.94", "53.97", "41.98", "1:27.71", "3:15.90"]
x942 = ["942", "-", "-", "-", "34.76", "48.96", "53.99", "42.00", "1:27.74", "3:15.97"]
x941 = ["941", "10.79", "14.73", "21.99", "34.77", "48.97", "54.01", "42.01", "1:27.77", "3:16.04"]
x900 = ["900", "10.92", "14.98", "22.30", "35.31", "49.70", "54.96", "42.63", "1:29.01", "3:18.94"]
x899 = ["899", "-", "-", "22.31", "35.32", "49.72", "54.98", "42.65", "1:29.04", "3:19.02"]
x898 = ["898", "-", "14.99", "22.32", "35.33", "49.74", "55.00", "42.66", "1:29.07", "3:19.09"]
x897 = ["897", "-", "-", "-", "35.35", "49.76", "55.03", "42.68", "1:29.10", "3:19.16"]
x896 = ["896", "10.93", "15.00", "22.33", "35.36", "49.77", "55.05", "42.69", "1:29.13", "3:19.23"]
x895 = ["895", "-", "15.01", "22.34", "35.37", "49.79", "55.07", "42.71", "1:29.16", "3:19.30"]
x894 = ["894", "-", "-", "22.35", "35.39", "49.81", "55.10", "42.72", "1:29.19", "3:19.37"]
x893 = ["893", "10.94", "15.02", "-", "35.40", "49.83", "55.12", "42.74", "1:29.22", "3:19.45"]
x892 = ["892", "-", "15.03", "22.36", "35.41", "49.85", "55.14", "42.75", "1:29.25", "3:19.52"]
x891 = ["891", "-", "-", "22.37", "35.43", "49.86", "55.17", "42.77", "1:29.28", "3:19.59"]
x850 = ["850", "11.08", "15.29", "22.69", "35.97", "50.61", "56.14", "43.40", "1:30.56", "3:22.58"]
x849 = ["849", "-", "-", "-", "35.99", "50.63", "56.17", "43.42", "1:30.59", "3:22.65"]
x848 = ["848", "-", "15.30", "22.70", "36.00", "50.65", "56.19", "43.43", "1:30.62", "3:22.73"]
x847 = ["847", "11.09", "15.31", "22.71", "36.01", "50.67", "56.21", "43.45", "1:30.65", "3:22.80"]
x846 = ["846", "-", "-", "22.72", "36.03", "50.69", "56.24", "43.46", "1:30.68", "3:22.87"]
x845 = ["845", "-", "15.32", "22.73", "36.04", "50.70", "56.26", "43.48", "1:30.72", "3:22.95"]
x844 = ["844", "-", "-", "-", "36.06", "50.72", "56.29", "43.50", "1:30.75", "3:23.02"]
x843 = ["843", "11.10", "15.33", "22.74", "36.07", "50.74", "56.31", "43.51", "1:30.78", "3:23.10"]
x842 = ["842", "-", "15.34", "22.75", "36.08", "50.76", "56.33", "43.53", "1:30.81", "3:23.17"]
x841 = ["841", "-", "-", "22.76", "36.10", "50.78", "56.36", "43.54", "1:30.84", "3:23.25"]
x800 = ["800", "-", "15.61", "-", "36.66", "51.55", "57.36", "44.20", "1:32.15", "3:26.32"]
x799 = ["799", "-", "-", "23.09", "36.68", "51.57", "57.39", "44.21", "1:32.19", "3:26.40"]
x798 = ["798", "11.25", "15.62", "23.10", "36.69", "51.59", "57.41", "44.23", "1:32.22", "3:26.48"]
x797 = ["797", "-", "15.63", "23.11", "36.70", "51.61", "57.44", "44.24", "1:32.25", "3:26.55"]
x796 = ["796", "-", "-", "23.12", "36.72", "51.62", "57.46", "44.26", "1:32.28", "3:26.63"]
x795 = ["795", "11.26", "15.64", "-", "36.73", "51.64", "57.49", "44.28", "1:32.32", "3:26.70"]
x794 = ["794", "-", "15.65", "23.13", "36.75", "51.66", "57.51", "44.29", "1:32.35", "3:26.78"]
x793 = ["793", "-", "-", "23.14", "36.76", "51.68", "57.54", "44.31", "1:32.38", "3:26.86"]
x792 = ["792", "11.27", "15.66", "23.15", "36.77", "51.70", "57.56", "44.32", "1:32.41", "3:26.93"]
x791 = ["791", "-", "15.67", "23.16", "36.79", "51.72", "57.59", "44.34", "1:32.45", "3:27.01"]
x750 = ["750", "-", "15.94", "-", "37.37", "52.52", "58.62", "45.01", "1:33.80", "3:30.19"]
x749 = ["749", "-", "-", "23.50", "37.39", "52.53", "58.65", "45.03", "1:33.83", "3:30.27"]
x748 = ["748", "11.42", "15.95", "23.51", "37.40", "52.55", "58.67", "45.05", "1:33.87", "3:30.34"]
x747 = ["747", "-", "15.96", "23.52", "37.41", "52.57", "58.70", "45.06", "1:33.90", "3:30.42"]
x746 = ["746", "-", "-", "23.53", "37.43", "52.59", "58.72", "45.08", "1:33.93", "3:30.50"]
x745 = ["745", "11.43", "15.97", "23.54", "37.44", "52.61", "58.75", "45.10", "1:33.97", "3:30.58"]
x744 = ["744", "-", "15.98", "-", "37.46", "52.63", "58.77", "45.11", "1:34.00", "3:30.66"]
x743 = ["743", "-", "-", "23.55", "37.47", "52.65", "58.80", "45.13", "1:34.03", "3:30.74"]
x742 = ["742", "11.44", "15.99", "23.56", "37.49", "52.67", "58.83", "45.15", "1:34.07", "3:30.82"]
x741 = ["741", "-", "16.00", "23.57", "37.50", "52.69", "58.85", "45.17", "1:34.10", "3:30.90"]
x700 = ["700", "11.59", "16.28", "23.92", "38.10", "53.51", "59.92", "45.86", "1:35.50", "3:34.18"]
x699 = ["699", "-", "-", "23.93", "38.12", "53.54", "59.95", "45.88", "1:35.54", "3:34.26"]
x698 = ["698", "-", "16.29", "-", "38.13", "53.56", "59.97", "45.90", "1:35.57", "3:34.34"]
x697 = ["697", "11.60", "16.30", "23.94", "38.15", "53.58", "1:00.00", "45.91", "1:35.61", "3:34.43"]
x696 = ["696", "-", "16.31", "23.95", "38.16", "53.60", "1:00.03", "45.93", "1:35.64", "3:34.51"]
x695 = ["695", "-", "-", "23.96", "38.18", "53.62", "1:00.05", "45.95", "1:35.68", "3:34.59"]
x694 = ["694", "11.61", "16.32", "23.97", "38.19", "53.64", "1:00.08", "45.97", "1:35.71", "3:34.67"]
x693 = ["693", "-", "16.33", "23.98", "38.21", "53.66", "1:00.11", "45.98", "1:35.74", "3:34.75"]
x692 = ["692", "-", "-", "23.99", "38.22", "53.68", "1:00.13", "46.00", "1:35.78", "3:34.83"]
x691 = ["691", "11.62", "16.34", "24.00", "38.24", "53.70", "1:00.16", "46.02", "1:35.81", "3:34.92"]
x650 = ["650", "11.77", "16.63", "24.36", "38.86", "54.55", "1:01.27", "46.74", "1:37.27", "3:38.32"]
x649 = ["649", "-", "16.64", "24.37", "38.88", "54.57", "1:01.30", "46.76", "1:37.30", "3:38.41"]
x648 = ["648", "11.78", "16.65", "-", "38.89", "54.59", "1:01.33", "46.78", "1:37.34", "3:38.49"]
x647 = ["647", "-", "-", "24.38", "38.91", "54.61", "1:01.35", "46.79", "1:37.37", "3:38.58"]
x646 = ["646", "-", "16.66", "24.39", "38.93", "54.64", "1:01.38", "46.81", "1:37.41", "3:38.66"]
x645 = ["645", "11.79", "16.67", "24.40", "38.94", "54.66", "1:01.41", "46.83", "1:37.45", "3:38.74"]
x644 = ["644", "-", "-", "24.41", "38.96", "54.68", "1:01.44", "46.85", "1:37.48", "3:38.83"]
x643 = ["643", "-", "16.68", "24.42", "38.97", "54.70", "1:01.46", "46.87", "1:37.52", "3:38.91"]
x642 = ["642", "11.80", "16.69", "24.43", "38.99", "54.72", "1:01.49", "46.88", "1:37.55", "3:39.00"]
x641 = ["641", "-", "16.70", "24.44", "39.00", "54.74", "1:01.52", "46.90", "1:37.59", "3:39.08"]
x600 = ["600", "11.96", "17.00", "24.81", "39.65", "55.63", "1:02.67", "47.65", "1:39.10", "3:42.62"]
x599 = ["599", "-", "17.01", "24.82", "39.67", "55.65", "1:02.70", "47.67", "1:39.14", "3:42.71"]
x598 = ["598", "11.97", "-", "24.83", "39.69", "55.67", "1:02.73", "47.69", "1:39.17", "3:42.80"]
x597 = ["597", "-", "17.02", "24.84", "39.70", "55.69", "1:02.76", "47.71", "1:39.21", "3:42.89"]
x596 = ["596", "-", "17.03", "24.85", "39.72", "55.72", "1:02.79", "47.73", "1:39.25", "3:42.98"]
x595 = ["595", "11.98", "17.04", "24.86", "39.73", "55.74", "1:02.81", "47.75", "1:39.29", "3:43.06"]
x594 = ["594", "-", "-", "24.87", "39.75", "55.76", "1:02.84", "47.76", "1:39.32", "3:43.15"]
x593 = ["593", "-", "17.05", "24.88", "39.77", "55.78", "1:02.87", "47.78", "1:39.36", "3:43.24"]
x592 = ["592", "11.99", "17.06", "24.89", "39.78", "55.80", "1:02.90", "47.80", "1:39.40", "3:43.33"]
x591 = ["591", "-", "17.07", "24.90", "39.80", "55.83", "1:02.93", "47.82", "1:39.44", "3:43.42"]
x550 = ["550", "12.16", "17.38", "25.29", "40.48", "56.75", "1:04.13", "48.60", "1:41.01", "3:47.11"]
x549 = ["549", "-", "17.39", "25.30", "40.49", "56.77", "1:04.16", "48.62", "1:41.05", "3:47.20"]
x548 = ["548", "-", "17.40", "25.31", "40.51", "56.80", "1:04.19", "48.64", "1:41.09", "3:47.29"]
x547 = ["547", "12.17", "-", "25.32", "40.53", "56.82", "1:04.22", "48.66", "1:41.13", "3:47.39"]
x546 = ["546", "-", "17.41", "25.33", "40.54", "56.84", "1:04.25", "48.68", "1:41.17", "3:47.48"]
x545 = ["545", "12.18", "17.42", "25.34", "40.56", "56.86", "1:04.28", "48.70", "1:41.21", "3:47.57"]
x544 = ["544", "-", "17.43", "25.35", "40.58", "56.89", "1:04.31", "48.72", "1:41.25", "3:47.66"]
x543 = ["543", "-", "17.44", "25.36", "40.60", "56.91", "1:04.34", "48.74", "1:41.28", "3:47.75"]
x542 = ["542", "12.19", "-", "25.37", "40.61", "56.93", "1:04.37", "48.76", "1:41.32", "3:47.85"]
x541 = ["541", "-", "17.45", "25.38", "40.63", "56.96", "1:04.40", "48.78", "1:41.36", "3:47.94"]
x500 = ["500", "-", "17.78", "25.79", "41.34", "57.92", "1:05.66", "49.60", "1:43.01", "3:51.81"]
x499 = ["499", "12.37", "17.79", "25.80", "41.36", "57.95", "1:05.69", "49.62", "1:43.05", "3:51.90"]
x498 = ["498", "-", "17.80", "25.81", "41.37", "57.97", "1:05.72", "49.64", "1:43.09", "3:52.00"]
x497 = ["497", "-", "17.81", "25.82", "41.39", "58.00", "1:05.76", "49.66", "1:43.13", "3:52.09"]
x496 = ["496", "12.38", "17.82", "25.83", "41.41", "58.02", "1:05.79", "49.68", "1:43.17", "3:52.19"]
x495 = ["495", "-", "-", "25.84", "41.43", "58.05", "1:05.82", "49.70", "1:43.22", "3:52.29"]
x494 = ["494", "12.39", "17.83", "25.85", "41.45", "58.07", "1:05.85", "49.72", "1:43.26", "3:52.38"]
x493 = ["493", "-", "17.84", "25.86", "41.46", "58.09", "1:05.88", "49.74", "1:43.30", "3:52.48"]
x492 = ["492", "12.40", "17.85", "25.87", "41.48", "58.12", "1:05.91", "49.76", "1:43.34", "3:52.58"]
x491 = ["491", "-", "17.86", "25.88", "41.50", "58.14", "1:05.95", "49.78", "1:43.38", "3:52.68"]
x450 = ["450", "12.58", "-", "26.31", "42.24", "59.16", "1:07.27", "50.65", "1:45.11", "3:56.74"]
x449 = ["449", "-", "18.21", "26.32", "42.26", "59.19", "1:07.30", "50.67", "1:45.16", "3:56.84"]
x448 = ["448", "12.59", "18.22", "26.33", "42.28", "59.21", "1:07.34", "50.69", "1:45.20", "3:56.94"]
x447 = ["447", "-", "18.23", "26.34", "42.30", "59.24", "1:07.37", "50.71", "1:45.24", "3:57.05"]
x446 = ["446", "12.60", "18.24", "26.35", "42.32", "59.26", "1:07.40", "50.73", "1:45.29", "3:57.15"]
x445 = ["445", "-", "18.25", "26.37", "42.34", "59.29", "1:07.44", "50.75", "1:45.33", "3:57.25"]
x444 = ["444", "12.61", "18.26", "26.38", "42.36", "59.31", "1:07.47", "50.77", "1:45.37", "3:57.35"]
x443 = ["443", "-", "-", "26.39", "42.38", "59.34", "1:07.50", "50.80", "1:45.42", "3:57.45"]
x442 = ["442", "-", "18.27", "26.40", "42.39", "59.36", "1:07.54", "50.82", "1:45.46", "3:57.56"]
x441 = ["441", "12.62", "18.28", "26.41", "42.41", "59.39", "1:07.57", "50.84", "1:45.50", "3:57.66"]
x350 = ["350", "-", "19.12", "27.45", "44.22", "1:01.86", "1:10.78", "52.93", "1:49.71", "4:07.52"]
x349 = ["349", "13.06", "19.13", "27.47", "44.24", "1:01.89", "1:10.82", "52.95", "1:49.75", "4:07.63"]
x348 = ["348", "-", "19.14", "27.48", "44.27", "1:01.91", "1:10.86", "52.98", "1:49.80", "4:07.75"]
x347 = ["347", "13.07", "19.15", "27.49", "44.29", "1:01.94", "1:10.89", "53.00", "1:49.85", "4:07.86"]
x346 = ["346", "-", "19.16", "27.50", "44.31", "1:01.97", "1:10.93", "53.03", "1:49.90", "4:07.98"]
x345 = ["345", "13.08", "19.17", "27.52", "44.33", "1:02.00", "1:10.97", "53.05", "1:49.95", "4:08.09"]
x344 = ["344", "-", "19.18", "27.53", "44.35", "1:02.03", "1:11.01", "53.08", "1:50.00", "4:08.21"]
x343 = ["343", "13.09", "19.19", "27.54", "44.37", "1:02.06", "1:11.04", "53.10", "1:50.05", "4:08.33"]
x342 = ["342", "-", "19.20", "27.55", "44.39", "1:02.09", "1:11.08", "53.13", "1:50.10", "4:08.44"]
x341 = ["341", "13.10", "19.21", "27.57", "44.41", "1:02.12", "1:11.12", "53.15", "1:50.15", "4:08.56"]
x250 = ["250", "-", "20.19", "28.78", "46.51", "1:04.97", "1:14.84", "55.57", "1:55.01", "4:19.98"]
x249 = ["249", "13.61", "20.20", "28.79", "46.54", "1:05.01", "1:14.88", "55.60", "1:55.07", "4:20.11"]
x248 = ["248", "-", "20.21", "28.81", "46.56", "1:05.04", "1:14.93", "55.63", "1:55.13", "4:20.25"]
x247 = ["247", "13.62", "20.22", "28.82", "46.59", "1:05.08", "1:14.97", "55.66", "1:55.19", "4:20.39"]
x246 = ["246", "13.63", "20.23", "28.84", "46.61", "1:05.11", "1:15.02", "55.69", "1:55.25", "4:20.53"]
x245 = ["245", "-", "20.25", "28.85", "46.64", "1:05.15", "1:15.06", "55.72", "1:55.31", "4:20.66"]
x244 = ["244", "13.64", "20.26", "28.86", "46.66", "1:05.18", "1:15.11", "55.75", "1:55.36", "4:20.80"]
x243 = ["243", "-", "20.27", "28.88", "46.69", "1:05.21", "1:15.15", "55.78", "1:55.42", "4:20.94"]
x242 = ["242", "13.65", "20.28", "28.89", "46.71", "1:05.25", "1:15.20", "55.81", "1:55.48", "4:21.08"]
x241 = ["241", "13.66", "20.29", "28.91", "46.74", "1:05.28", "1:15.24", "55.83", "1:55.54", "4:21.21"]
x150 = ["150", "14.28", "21.50", "30.40", "49.32", "1:08.81", "1:19.83", "58.82", "2:01.55", "4:35.31"]
x149 = ["149", "-", "21.51", "30.42", "49.36", "1:08.86", "1:19.89", "58.86", "2:01.62", "4:35.49"]
x148 = ["148", "14.29", "21.53", "30.44", "49.39", "1:08.90", "1:19.95", "58.90", "2:01.70", "4:35.66"]
x147 = ["147", "14.30", "21.54", "30.46", "49.42", "1:08.94", "1:20.01", "58.94", "2:01.77", "4:35.84"]
x146 = ["146", "14.31", "21.56", "30.48", "49.45", "1:08.99", "1:20.06", "58.97", "2:01.85", "4:36.02"]
x145 = ["145", "14.32", "21.57", "30.50", "49.49", "1:09.03", "1:20.12", "59.01", "2:01.92", "4:36.20"]
x144 = ["144", "-", "21.59", "30.52", "49.52", "1:09.08", "1:20.18", "59.05", "2:02.00", "4:36.37"]
x143 = ["143", "14.33", "21.60", "30.54", "49.55", "1:09.12", "1:20.24", "59.09", "2:02.08", "4:36.55"]
x142 = ["142", "14.34", "21.62", "30.56", "49.59", "1:09.17", "1:20.30", "59.13", "2:02.15", "4:36.73"]
x141 = ["141", "14.35", "21.63", "30.57", "49.62", "1:09.21", "1:20.36", "59.16", "2:02.23", "4:36.91"]
x50 = ["50", "15.26", "23.40", "32.77", "53.41", "1:14.38", "1:27.09", "1:03.55", "2:11.03", "4:57.58"]
x49 = ["49", "15.27", "23.42", "32.80", "53.47", "1:14.46", "1:27.19", "1:03.61", "2:11.16", "4:57.88"]
x48 = ["48", "15.28", "23.45", "32.83", "53.52", "1:14.54", "1:27.29", "1:03.68", "2:11.30", "4:58.19"]
x47 = ["47", "15.30", "23.48", "32.87", "53.58", "1:14.62", "1:27.39", "1:03.74", "2:11.43", "4:58.50"]
x46 = ["46", "15.31", "23.50", "32.90", "53.64", "1:14.69", "1:27.49", "1:03.81", "2:11.56", "4:58.82"]
x45 = ["45", "15.32", "23.53", "32.93", "53.70", "1:14.77", "1:27.60", "1:03.88", "2:11.70", "4:59.14"]
x44 = ["44", "15.34", "23.56", "32.97", "53.76", "1:14.85", "1:27.70", "1:03.94", "2:11.84", "4:59.46"]
x43 = ["43", "15.35", "23.59", "33.00", "53.82", "1:14.94", "1:27.81", "1:04.01", "2:11.98", "4:59.79"]
x42 = ["42", "15.37", "23.61", "33.04", "53.88", "1:15.02", "1:27.91", "1:04.08", "2:12.12", "5:00.12"]
x41 = ["41", "15.38", "23.64", "33.07", "53.94", "1:15.10", "1:28.02", "1:04.15", "2:12.26", "5:00.45"]
x10 = ["10", "16.00", "24.83", "34.55", "56.50", "1:18.59", "1:32.56", "1:07.11", "2:18.20", "5:14.39"]
x9 = ["9", "16.03", "24.89", "34.63", "56.63", "1:18.77", "1:32.79", "1:07.26", "2:18.50", "5:15.09"]
x8 = ["8", "16.06", "24.96", "34.70", "56.76", "1:18.95", "1:33.03", "1:07.42", "2:18.81", "5:15.83"]
x7 = ["7", "16.09", "25.02", "34.79", "56.91", "1:19.15", "1:33.29", "1:07.58", "2:19.15", "5:16.61"]
x6 = ["6", "16.13", "25.10", "34.88", "57.06", "1:19.36", "1:33.56", "1:07.76", "2:19.51", "5:17.46"]
x5 = ["5", "16.17", "25.17", "34.97", "57.23", "1:19.59", "1:33.86", "1:07.96", "2:19.90", "5:18.38"]
x4 = ["4", "16.22", "25.26", "35.08", "57.42", "1:19.84", "1:34.19", "1:08.17", "2:20.33", "5:19.39"]
x3 = ["3", "16.27", "25.36", "35.20", "57.63", "1:20.13", "1:34.57", "1:08.42", "2:20.82", "5:20.54"]
x2 = ["2", "16.33", "25.48", "35.35", "57.88", "1:20.47", "1:35.01", "1:08.71", "2:21.40", "5:21.91"]
x1 = ["1", "16.41", "25.63", "35.54", "58.21", "1:20.92", "1:35.59", "1:09.08", "2:22.16", "5:23.69"]
MENS_SPRINTS = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1300, x1299, x1298, x1297, x1296, x1295, x1294, x1293, x1292, x1291, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1200, x1199, x1198, x1197, x1196, x1195, x1194, x1193, x1192, x1191, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1100, x1099, x1098, x1097, x1096, x1095, x1094, x1093, x1092, x1091, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x1000, x999, x998, x997, x996, x995, x994, x993, x992, x991, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x900, x899, x898, x897, x896, x895, x894, x893, x892, x891, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x800, x799, x798, x797, x796, x795, x794, x793, x792, x791, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x700, x699, x698, x697, x696, x695, x694, x693, x692, x691, x650, x649, x648, x647, x646, x645, x644, x643, x642, x641, x600, x599, x598, x597, x596, x595, x594, x593, x592, x591, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x500, x499, x498, x497, x496, x495, x494, x493, x492, x491, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x341, x250, x249, x248, x247, x246, x245, x244, x243, x242, x241, x150, x149, x148, x147, x146, x145, x144, x143, x142, x141, x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1]


xpoints = ["points", "600m", "800m", "1000m", "1500m", "mile", "2000m"]
x1400 = ["1400", "1:09.21", "1:37.65", "2:06.45", "3:19.44", "3:35.31", "4:34.64"]
x1399 = ["1399", "1:09.24", "1:37.68", "2:06.49", "3:19.50", "3:35.38", "4:34.73"]
x1398 = ["1398", "1:09.26", "1:37.71", "2:06.53", "3:19.57", "3:35.45", "4:34.82"]
x1397 = ["1397", "1:09.28", "1:37.74", "2:06.58", "3:19.64", "3:35.52", "4:34.91"]
x1396 = ["1396", "1:09.30", "1:37.77", "2:06.62", "3:19.70", "3:35.59", "4:35.00"]
x1395 = ["1395", "1:09.32", "1:37.80", "2:06.66", "3:19.77", "3:35.67", "4:35.09"]
x1394 = ["1394", "1:09.34", "1:37.83", "2:06.70", "3:19.83", "3:35.74", "4:35.18"]
x1393 = ["1393", "1:09.37", "1:37.87", "2:06.74", "3:19.90", "3:35.81", "4:35.27"]
x1392 = ["1392", "1:09.39", "1:37.90", "2:06.79", "3:19.97", "3:35.88", "4:35.36"]
x1391 = ["1391", "1:09.41", "1:37.93", "2:06.83", "3:20.03", "3:35.95", "4:35.45"]
x1350 = ["1350", "1:10.31", "1:39.21", "2:08.58", "3:22.78", "3:38.91", "4:39.20"]
x1349 = ["1349", "1:10.33", "1:39.24", "2:08.63", "3:22.85", "3:38.98", "4:39.29"]
x1348 = ["1348", "1:10.35", "1:39.27", "2:08.67", "3:22.92", "3:39.05", "4:39.39"]
x1347 = ["1347", "1:10.38", "1:39.30", "2:08.71", "3:22.98", "3:39.12", "4:39.48"]
x1346 = ["1346", "1:10.40", "1:39.33", "2:08.76", "3:23.05", "3:39.20", "4:39.57"]
x1345 = ["1345", "1:10.42", "1:39.36", "2:08.80", "3:23.12", "3:39.27", "4:39.66"]
x1344 = ["1344", "1:10.44", "1:39.39", "2:08.84", "3:23.19", "3:39.34", "4:39.75"]
x1343 = ["1343", "1:10.46", "1:39.43", "2:08.89", "3:23.25", "3:39.42", "4:39.85"]
x1342 = ["1342", "1:10.49", "1:39.46", "2:08.93", "3:23.32", "3:39.49", "4:39.94"]
x1341 = ["1341", "1:10.51", "1:39.49", "2:08.97", "3:23.39", "3:39.56", "4:40.03"]
x1250 = ["1250", "1:12.56", "1:42.41", "2:12.98", "3:29.66", "3:46.31", "4:48.59"]
x1249 = ["1249", "1:12.59", "1:42.44", "2:13.02", "3:29.73", "3:46.38", "4:48.69"]
x1248 = ["1248", "1:12.61", "1:42.47", "2:13.07", "3:29.80", "3:46.46", "4:48.78"]
x1247 = ["1247", "1:12.63", "1:42.50", "2:13.11", "3:29.87", "3:46.54", "4:48.88"]
x1246 = ["1246", "1:12.65", "1:42.54", "2:13.16", "3:29.94", "3:46.61", "4:48.98"]
x1245 = ["1245", "1:12.68", "1:42.57", "2:13.20", "3:30.01", "3:46.69", "4:49.07"]
x1244 = ["1244", "1:12.70", "1:42.60", "2:13.25", "3:30.08", "3:46.76", "4:49.17"]
x1243 = ["1243", "1:12.72", "1:42.64", "2:13.29", "3:30.15", "3:46.84", "4:49.26"]
x1242 = ["1242", "1:12.75", "1:42.67", "2:13.34", "3:30.22", "3:46.91", "4:49.36"]
x1241 = ["1241", "1:12.77", "1:42.70", "2:13.38", "3:30.29", "3:46.99", "4:49.46"]
x1150 = ["1150", "1:14.91", "1:45.74", "2:17.55", "3:36.82", "3:54.01", "4:58.37"]
x1149 = ["1149", "1:14.93", "1:45.77", "2:17.60", "3:36.89", "3:54.09", "4:58.47"]
x1148 = ["1148", "1:14.96", "1:45.81", "2:17.65", "3:36.96", "3:54.17", "4:58.57"]
x1147 = ["1147", "1:14.98", "1:45.84", "2:17.69", "3:37.04", "3:54.25", "4:58.67"]
x1146 = ["1146", "1:15.00", "1:45.87", "2:17.74", "3:37.11", "3:54.33", "4:58.77"]
x1145 = ["1145", "1:15.03", "1:45.91", "2:17.79", "3:37.18", "3:54.41", "4:58.87"]
x1144 = ["1144", "1:15.05", "1:45.94", "2:17.83", "3:37.26", "3:54.49", "4:58.97"]
x1143 = ["1143", "1:15.08", "1:45.98", "2:17.88", "3:37.33", "3:54.57", "4:59.07"]
x1142 = ["1142", "1:15.10", "1:46.01", "2:17.93", "3:37.40", "3:54.64", "4:59.17"]
x1141 = ["1141", "1:15.12", "1:46.04", "2:17.97", "3:37.48", "3:54.72", "4:59.27"]
x1050 = ["1050", "1:17.36", "1:49.22", "2:22.33", "3:44.30", "4:02.06", "5:08.58"]
x1049 = ["1049", "1:17.38", "1:49.25", "2:22.38", "3:44.37", "4:02.14", "5:08.68"]
x1048 = ["1048", "1:17.41", "1:49.29", "2:22.43", "3:44.45", "4:02.23", "5:08.79"]
x1047 = ["1047", "1:17.43", "1:49.32", "2:22.48", "3:44.53", "4:02.31", "5:08.89"]
x1046 = ["1046", "1:17.46", "1:49.36", "2:22.53", "3:44.60", "4:02.39", "5:09.00"]
x1045 = ["1045", "1:17.48", "1:49.40", "2:22.57", "3:44.68", "4:02.47", "5:09.10"]
x1044 = ["1044", "1:17.51", "1:49.43", "2:22.62", "3:44.76", "4:02.56", "5:09.21"]
x1043 = ["1043", "1:17.53", "1:49.47", "2:22.67", "3:44.83", "4:02.64", "5:09.31"]
x1042 = ["1042", "1:17.56", "1:49.50", "2:22.72", "3:44.91", "4:02.72", "5:09.42"]
x1041 = ["1041", "1:17.58", "1:49.54", "2:22.77", "3:44.99", "4:02.80", "5:09.52"]
x950 = ["950", "1:19.93", "1:52.87", "2:27.34", "3:52.14", "4:10.50", "5:19.29"]
x949 = ["949", "1:19.95", "1:52.91", "2:27.39", "3:52.22", "4:10.59", "5:19.40"]
x948 = ["948", "1:19.98", "1:52.94", "2:27.44", "3:52.30", "4:10.68", "5:19.51"]
x947 = ["947", "1:20.01", "1:52.98", "2:27.50", "3:52.38", "4:10.76", "5:19.62"]
x946 = ["946", "1:20.03", "1:53.02", "2:27.55", "3:52.46", "4:10.85", "5:19.73"]
x945 = ["945", "1:20.06", "1:53.05", "2:27.60", "3:52.54", "4:10.94", "5:19.84"]
x944 = ["944", "1:20.08", "1:53.09", "2:27.65", "3:52.62", "4:11.02", "5:19.95"]
x943 = ["943", "1:20.11", "1:53.13", "2:27.70", "3:52.70", "4:11.11", "5:20.06"]
x942 = ["942", "1:20.14", "1:53.17", "2:27.75", "3:52.79", "4:11.20", "5:20.17"]
x941 = ["941", "1:20.16", "1:53.21", "2:27.81", "3:52.87", "4:11.28", "5:20.28"]
x850 = ["850", "1:22.63", "1:56.72", "2:32.62", "4:00.41", "4:19.40", "5:30.58"]
x849 = ["849", "1:22.66", "1:56.75", "2:32.68", "4:00.49", "4:19.49", "5:30.70"]
x848 = ["848", "1:22.69", "1:56.79", "2:32.73", "4:00.58", "4:19.58", "5:30.81"]
x847 = ["847", "1:22.72", "1:56.83", "2:32.79", "4:00.66", "4:19.68", "5:30.93"]
x846 = ["846", "1:22.75", "1:56.87", "2:32.84", "4:00.75", "4:19.77", "5:31.04"]
x845 = ["845", "1:22.77", "1:56.91", "2:32.90", "4:00.84", "4:19.86", "5:31.16"]
x844 = ["844", "1:22.80", "1:56.95", "2:32.95", "4:00.92", "4:19.95", "5:31.28"]
x843 = ["843", "1:22.83", "1:56.99", "2:33.01", "4:01.01", "4:20.04", "5:31.39"]
x842 = ["842", "1:22.86", "1:57.03", "2:33.06", "4:01.09", "4:20.13", "5:31.51"]
x841 = ["841", "1:22.89", "1:57.07", "2:33.11", "4:01.18", "4:20.23", "5:31.63"]
x750 = ["750", "1:25.51", "2:00.80", "2:38.23", "4:09.18", "4:28.84", "5:42.56"]
x749 = ["749", "1:25.54", "2:00.84", "2:38.29", "4:09.27", "4:28.94", "5:42.68"]
x748 = ["748", "1:25.57", "2:00.88", "2:38.34", "4:09.36", "4:29.03", "5:42.80"]
x747 = ["747", "1:25.60", "2:00.92", "2:38.40", "4:09.45", "4:29.13", "5:42.93"]
x746 = ["746", "1:25.63", "2:00.97", "2:38.46", "4:09.54", "4:29.23", "5:43.05"]
x745 = ["745", "1:25.66", "2:01.01", "2:38.52", "4:09.63", "4:29.33", "5:43.17"]
x744 = ["744", "1:25.69", "2:01.05", "2:38.58", "4:09.72", "4:29.43", "5:43.30"]
x743 = ["743", "1:25.72", "2:01.09", "2:38.63", "4:09.82", "4:29.52", "5:43.42"]
x742 = ["742", "1:25.75", "2:01.13", "2:38.69", "4:09.91", "4:29.62", "5:43.55"]
x741 = ["741", "1:25.78", "2:01.18", "2:38.75", "4:10.00", "4:29.72", "5:43.67"]
x649 = ["649", "1:28.61", "2:05.21", "2:44.28", "4:18.66", "4:39.04", "5:55.49"]
x648 = ["648", "1:28.64", "2:05.25", "2:44.34", "4:18.75", "4:39.14", "5:55.63"]
x647 = ["647", "1:28.68", "2:05.30", "2:44.41", "4:18.85", "4:39.25", "5:55.76"]
x646 = ["646", "1:28.71", "2:05.34", "2:44.47", "4:18.95", "4:39.35", "5:55.89"]
x645 = ["645", "1:28.74", "2:05.39", "2:44.53", "4:19.05", "4:39.46", "5:56.03"]
x644 = ["644", "1:28.77", "2:05.43", "2:44.59", "4:19.14", "4:39.56", "5:56.16"]
x643 = ["643", "1:28.80", "2:05.48", "2:44.65", "4:19.24", "4:39.67", "5:56.29"]
x642 = ["642", "1:28.84", "2:05.52", "2:44.72", "4:19.34", "4:39.77", "5:56.43"]
x641 = ["641", "1:28.87", "2:05.57", "2:44.78", "4:19.44", "4:39.88", "5:56.56"]
x550 = ["550", "1:31.90", "2:09.88", "2:50.69", "4:28.69", "4:49.83", "6:09.19"]
x549 = ["549", "1:31.93", "2:09.92", "2:50.76", "4:28.80", "4:49.95", "6:09.34"]
x548 = ["548", "1:31.97", "2:09.97", "2:50.83", "4:28.90", "4:50.06", "6:09.48"]
x547 = ["547", "1:32.00", "2:10.02", "2:50.89", "4:29.01", "4:50.18", "6:09.63"]
x546 = ["546", "1:32.04", "2:10.07", "2:50.96", "4:29.11", "4:50.29", "6:09.77"]
x545 = ["545", "1:32.07", "2:10.12", "2:51.03", "4:29.22", "4:50.41", "6:09.92"]
x544 = ["544", "1:32.11", "2:10.17", "2:51.10", "4:29.33", "4:50.52", "6:10.06"]
x543 = ["543", "1:32.14", "2:10.22", "2:51.17", "4:29.43", "4:50.63", "6:10.21"]
x542 = ["542", "1:32.18", "2:10.27", "2:51.23", "4:29.54", "4:50.75", "6:10.35"]
x541 = ["541", "1:32.21", "2:10.32", "2:51.30", "4:29.65", "4:50.86", "6:10.50"]
x450 = ["450", "1:35.54", "2:15.04", "2:57.79", "4:39.79", "5:01.78", "6:24.35"]
x449 = ["449", "1:35.57", "2:15.10", "2:57.86", "4:39.91", "5:01.91", "6:24.51"]
x448 = ["448", "1:35.61", "2:15.15", "2:57.93", "4:40.03", "5:02.04", "6:24.67"]
x447 = ["447", "1:35.65", "2:15.21", "2:58.01", "4:40.14", "5:02.16", "6:24.83"]
x446 = ["446", "1:35.69", "2:15.26", "2:58.08", "4:40.26", "5:02.29", "6:24.99"]
x445 = ["445", "1:35.73", "2:15.31", "2:58.16", "4:40.38", "5:02.41", "6:25.15"]
x444 = ["444", "1:35.77", "2:15.37", "2:58.23", "4:40.50", "5:02.54", "6:25.31"]
x443 = ["443", "1:35.80", "2:15.42", "2:58.31", "4:40.61", "5:02.67", "6:25.48"]
x442 = ["442", "1:35.84", "2:15.48", "2:58.39", "4:40.73", "5:02.79", "6:25.64"]
x441 = ["441", "1:35.88", "2:15.53", "2:58.46", "4:40.85", "5:02.92", "6:25.80"]
x350 = ["350", "1:39.60", "2:20.82", "3:05.72", "4:52.22", "5:15.15", "6:41.32"]
x349 = ["349", "1:39.65", "2:20.88", "3:05.81", "4:52.35", "5:15.29", "6:41.50"]
x348 = ["348", "1:39.69", "2:20.95", "3:05.89", "4:52.48", "5:15.44", "6:41.68"]
x347 = ["347", "1:39.74", "2:21.01", "3:05.98", "4:52.61", "5:15.58", "6:41.86"]
x346 = ["346", "1:39.78", "2:21.07", "3:06.06", "4:52.75", "5:15.72", "6:42.04"]
x345 = ["345", "1:39.82", "2:21.13", "3:06.15", "4:52.88", "5:15.87", "6:42.22"]
x344 = ["344", "1:39.87", "2:21.19", "3:06.23", "4:53.01", "5:16.01", "6:42.41"]
x343 = ["343", "1:39.91", "2:21.26", "3:06.32", "4:53.15", "5:16.16", "6:42.59"]
x342 = ["342", "1:39.95", "2:21.32", "3:06.40", "4:53.28", "5:16.30", "6:42.77"]
x341 = ["341", "1:40.00", "2:21.38", "3:06.49", "4:53.42", "5:16.44", "6:42.95"]
x250 = ["250", "1:44.31", "2:27.51", "3:14.90", "5:06.58", "5:30.61", "7:00.93"]
x249 = ["249", "1:44.36", "2:27.58", "3:15.00", "5:06.74", "5:30.78", "7:01.15"]
x248 = ["248", "1:44.41", "2:27.65", "3:15.10", "5:06.90", "5:30.95", "7:01.36"]
x247 = ["247", "1:44.46", "2:27.73", "3:15.20", "5:07.05", "5:31.12", "7:01.58"]
x246 = ["246", "1:44.52", "2:27.80", "3:15.30", "5:07.21", "5:31.29", "7:01.79"]
x245 = ["245", "1:44.57", "2:27.87", "3:15.40", "5:07.37", "5:31.46", "7:02.01"]
x244 = ["244", "1:44.62", "2:27.95", "3:15.50", "5:07.53", "5:31.63", "7:02.22"]
x243 = ["243", "1:44.67", "2:28.02", "3:15.61", "5:07.69", "5:31.80", "7:02.44"]
x242 = ["242", "1:44.72", "2:28.10", "3:15.71", "5:07.85", "5:31.97", "7:02.66"]
x241 = ["241", "1:44.78", "2:28.17", "3:15.81", "5:08.01", "5:32.14", "7:02.88"]
x150 = ["150", "1:50.10", "2:35.73", "3:26.19", "5:24.26", "5:49.63", "7:25.06"]
x149 = ["149", "1:50.17", "2:35.83", "3:26.32", "5:24.46", "5:49.85", "7:25.34"]
x148 = ["148", "1:50.23", "2:35.92", "3:26.45", "5:24.66", "5:50.07", "7:25.62"]
x147 = ["147", "1:50.30", "2:36.02", "3:26.58", "5:24.87", "5:50.29", "7:25.90"]
x146 = ["146", "1:50.37", "2:36.11", "3:26.71", "5:25.07", "5:50.51", "7:26.18"]
x145 = ["145", "1:50.43", "2:36.21", "3:26.84", "5:25.28", "5:50.73", "7:26.46"]
x144 = ["144", "1:50.50", "2:36.30", "3:26.98", "5:25.48", "5:50.95", "7:26.74"]
x143 = ["143", "1:50.57", "2:36.40", "3:27.11", "5:25.69", "5:51.18", "7:27.02"]
x142 = ["142", "1:50.64", "2:36.50", "3:27.24", "5:25.90", "5:51.40", "7:27.31"]
x141 = ["141", "1:50.71", "2:36.59", "3:27.37", "5:26.11", "5:51.62", "7:27.59"]
x50 = ["50", "1:58.51", "2:47.68", "3:42.59", "5:49.93", "6:17.26", "8:00.11"]
x49 = ["49", "1:58.62", "2:47.84", "3:42.82", "5:50.28", "6:17.64", "8:00.60"]
x48 = ["48", "1:58.74", "2:48.01", "3:43.04", "5:50.64", "6:18.02", "8:01.08"]
x47 = ["47", "1:58.86", "2:48.17", "3:43.27", "5:51.00", "6:18.41", "8:01.57"]
x46 = ["46", "1:58.98", "2:48.34", "3:43.51", "5:51.36", "6:18.80", "8:02.07"]
x45 = ["45", "1:59.10", "2:48.51", "3:43.74", "5:51.73", "6:19.19", "8:02.57"]
x44 = ["44", "1:59.22", "2:48.69", "3:43.98", "5:52.10", "6:19.59", "8:03.08"]
x43 = ["43", "1:59.34", "2:48.86", "3:44.22", "5:52.48", "6:20.00", "8:03.59"]
x42 = ["42", "1:59.47", "2:49.04", "3:44.46", "5:52.86", "6:20.41", "8:04.11"]
x41 = ["41", "1:59.59", "2:49.22", "3:44.71", "5:53.24", "6:20.82", "8:04.64"]
x10 = ["10", "2:04.86", "2:56.70", "3:54.98", "6:09.31", "6:38.12", "8:26.58"]
x9 = ["9", "2:05.12", "2:57.07", "3:55.49", "6:10.12", "6:38.98", "8:27.68"]
x8 = ["8", "2:05.40", "2:57.47", "3:56.03", "6:10.97", "6:39.90", "8:28.84"]
x7 = ["7", "2:05.70", "2:57.89", "3:56.61", "6:11.87", "6:40.88", "8:30.08"]
x6 = ["6", "2:06.02", "2:58.34", "3:57.23", "6:12.85", "6:41.92", "8:31.41"]
x5 = ["5", "2:06.36", "2:58.83", "3:57.91", "6:13.91", "6:43.06", "8:32.85"]
x4 = ["4", "2:06.75", "2:59.38", "3:58.66", "6:15.08", "6:44.32", "8:34.45"]
x3 = ["3", "2:07.18", "3:00.00", "3:59.51", "6:16.41", "6:45.75", "8:36.27"]
x2 = ["2", "2:07.70", "3:00.73", "4:00.51", "6:17.98", "6:47.45", "8:38.42"]
x1 = ["1", "2:08.37", "3:01.69", "4:01.83", "6:20.04", "6:49.66", "8:41.22"]
MENS_MIDDLE = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x649, x648, x647, x646, x645, x644, x643, x642, x641, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x341, x250, x249, x248, x247, x246, x245, x244, x243, x242, x241, x150, x149, x148, x147, x146, x145, x144, x143, x142, x141, x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1]


xpoints = ["points", "2000mSC", "3000m", "3000mSC", "2miles", "5000m", "10000m"]
x1400 = ["1400", "4:50.60", "7:05.53", "7:31.38", "7:40.41", "12:12.89", "25:22.28"]
x1399 = ["1399", "4:50.73", "7:05.68", "7:31.58", "7:40.57", "12:13.14", "25:22.86"]
x1398 = ["1398", "4:50.86", "7:05.83", "7:31.78", "7:40.73", "12:13.39", "25:23.44"]
x1397 = ["1397", "4:51.00", "7:05.98", "7:31.99", "7:40.89", "12:13.65", "25:24.02"]
x1396 = ["1396", "4:51.13", "7:06.13", "7:32.19", "7:41.04", "12:13.90", "25:24.61"]
x1395 = ["1395", "4:51.26", "7:06.27", "7:32.39", "7:41.20", "12:14.15", "25:25.19"]
x1394 = ["1394", "4:51.39", "7:06.42", "7:32.60", "7:41.36", "12:14.41", "25:25.77"]
x1393 = ["1393", "4:51.53", "7:06.57", "7:32.80", "7:41.52", "12:14.66", "25:26.35"]
x1392 = ["1392", "4:51.66", "7:06.72", "7:33.00", "7:41.68", "12:14.91", "25:26.94"]
x1391 = ["1391", "4:51.79", "7:06.87", "7:33.21", "7:41.84", "12:15.16", "25:27.52"]
x1350 = ["1350", "4:57.26", "7:13.00", "7:41.62", "7:48.42", "12:25.63", "25:51.61"]
x1349 = ["1349", "4:57.39", "7:13.15", "7:41.83", "7:48.58", "12:25.89", "25:52.20"]
x1348 = ["1348", "4:57.53", "7:13.30", "7:42.04", "7:48.74", "12:26.14", "25:52.79"]
x1347 = ["1347", "4:57.66", "7:13.45", "7:42.24", "7:48.91", "12:26.40", "25:53.39"]
x1346 = ["1346", "4:57.79", "7:13.60", "7:42.45", "7:49.07", "12:26.66", "25:53.98"]
x1345 = ["1345", "4:57.93", "7:13.76", "7:42.66", "7:49.23", "12:26.92", "25:54.57"]
x1344 = ["1344", "4:58.06", "7:13.91", "7:42.87", "7:49.39", "12:27.17", "25:55.17"]
x1343 = ["1343", "4:58.20", "7:14.06", "7:43.07", "7:49.55", "12:27.43", "25:55.76"]
x1342 = ["1342", "4:58.33", "7:14.21", "7:43.28", "7:49.72", "12:27.69", "25:56.35"]
x1341 = ["1341", "4:58.47", "7:14.36", "7:43.49", "7:49.88", "12:27.95", "25:56.95"]
x1250 = ["1250", "5:10.95", "7:28.36", "8:02.70", "8:04.90", "12:51.84", "26:51.95"]
x1249 = ["1249", "5:11.09", "7:28.52", "8:02.92", "8:05.07", "12:52.11", "26:52.56"]
x1248 = ["1248", "5:11.23", "7:28.68", "8:03.13", "8:05.24", "12:52.38", "26:53.18"]
x1247 = ["1247", "5:11.37", "7:28.84", "8:03.35", "8:05.41", "12:52.64", "26:53.80"]
x1246 = ["1246", "5:11.51", "7:28.99", "8:03.56", "8:05.57", "12:52.91", "26:54.41"]
x1245 = ["1245", "5:11.65", "7:29.15", "8:03.78", "8:05.74", "12:53.18", "26:55.03"]
x1244 = ["1244", "5:11.79", "7:29.31", "8:03.99", "8:05.91", "12:53.45", "26:55.64"]
x1243 = ["1243", "5:11.93", "7:29.46", "8:04.21", "8:06.08", "12:53.72", "26:56.26"]
x1242 = ["1242", "5:12.07", "7:29.62", "8:04.42", "8:06.25", "12:53.98", "26:56.88"]
x1241 = ["1241", "5:12.21", "7:29.78", "8:04.64", "8:06.42", "12:54.25", "26:57.50"]
x1150 = ["1150", "5:25.20", "7:44.36", "8:24.64", "8:22.06", "13:19.13", "27:54.75"]
x1149 = ["1149", "5:25.35", "7:44.52", "8:24.87", "8:22.23", "13:19.40", "27:55.39"]
x1148 = ["1148", "5:25.49", "7:44.68", "8:25.09", "8:22.41", "13:19.68", "27:56.04"]
x1147 = ["1147", "5:25.64", "7:44.85", "8:25.31", "8:22.58", "13:19.96", "27:56.68"]
x1146 = ["1146", "5:25.79", "7:45.01", "8:25.54", "8:22.76", "13:20.24", "27:57.32"]
x1145 = ["1145", "5:25.93", "7:45.17", "8:25.76", "8:22.93", "13:20.52", "27:57.96"]
x1144 = ["1144", "5:26.08", "7:45.34", "8:25.99", "8:23.11", "13:20.80", "27:58.61"]
x1143 = ["1143", "5:26.22", "7:45.50", "8:26.21", "8:23.28", "13:21.08", "27:59.25"]
x1142 = ["1142", "5:26.37", "7:45.67", "8:26.44", "8:23.46", "13:21.36", "27:59.89"]
x1141 = ["1141", "5:26.52", "7:45.83", "8:26.66", "8:23.63", "13:21.64", "28:00.54"]
x1050 = ["1050", "5:40.09", "8:01.06", "8:47.56", "8:39.97", "13:47.62", "29:00.35"]
x1049 = ["1049", "5:40.24", "8:01.23", "8:47.79", "8:40.16", "13:47.91", "29:01.02"]
x1048 = ["1048", "5:40.39", "8:01.40", "8:48.03", "8:40.34", "13:48.21", "29:01.70"]
x1047 = ["1047", "5:40.55", "8:01.57", "8:48.26", "8:40.52", "13:48.50", "29:02.37"]
x1046 = ["1046", "5:40.70", "8:01.74", "8:48.50", "8:40.71", "13:48.79", "29:03.04"]
x1045 = ["1045", "5:40.85", "8:01.92", "8:48.73", "8:40.89", "13:49.08", "29:03.71"]
x1044 = ["1044", "5:41.01", "8:02.09", "8:48.97", "8:41.07", "13:49.37", "29:04.39"]
x1043 = ["1043", "5:41.16", "8:02.26", "8:49.20", "8:41.26", "13:49.67", "29:05.06"]
x1042 = ["1042", "5:41.31", "8:02.43", "8:49.44", "8:41.44", "13:49.96", "29:05.73"]
x1041 = ["1041", "5:41.46", "8:02.60", "8:49.67", "8:41.63", "13:50.25", "29:06.41"]
x950 = ["950", "5:55.70", "8:18.58", "9:11.59", "8:58.77", "14:17.51", "30:09.16"]
x949 = ["949", "5:55.86", "8:18.76", "9:11.84", "8:58.96", "14:17.82", "30:09.86"]
x948 = ["948", "5:56.03", "8:18.94", "9:12.09", "8:59.15", "14:18.13", "30:10.57"]
x947 = ["947", "5:56.19", "8:19.12", "9:12.33", "8:59.34", "14:18.43", "30:11.28"]
x946 = ["946", "5:56.35", "8:19.30", "9:12.58", "8:59.54", "14:18.74", "30:11.98"]
x945 = ["945", "5:56.51", "8:19.48", "9:12.83", "8:59.73", "14:19.05", "30:12.69"]
x944 = ["944", "5:56.67", "8:19.66", "9:13.08", "8:59.92", "14:19.35", "30:13.40"]
x943 = ["943", "5:56.83", "8:19.84", "9:13.32", "9:00.12", "14:19.66", "30:14.11"]
x942 = ["942", "5:56.99", "8:20.02", "9:13.57", "9:00.31", "14:19.97", "30:14.81"]
x941 = ["941", "5:57.15", "8:20.20", "9:13.82", "9:00.50", "14:20.28", "30:15.52"]
x850 = ["850", "6:12.17", "8:37.05", "9:36.93", "9:18.58", "14:49.02", "31:21.69"]
x849 = ["849", "6:12.33", "8:37.24", "9:37.19", "9:18.78", "14:49.35", "31:22.44"]
x848 = ["848", "6:12.50", "8:37.43", "9:37.45", "9:18.98", "14:49.67", "31:23.18"]
x847 = ["847", "6:12.67", "8:37.62", "9:37.71", "9:19.19", "14:49.99", "31:23.93"]
x846 = ["846", "6:12.84", "8:37.81", "9:37.98", "9:19.39", "14:50.32", "31:24.68"]
x845 = ["845", "6:13.01", "8:38.00", "9:38.24", "9:19.60", "14:50.64", "31:25.43"]
x844 = ["844", "6:13.18", "8:38.19", "9:38.50", "9:19.80", "14:50.97", "31:26.17"]
x843 = ["843", "6:13.35", "8:38.38", "9:38.76", "9:20.01", "14:51.30", "31:26.92"]
x842 = ["842", "6:13.52", "8:38.57", "9:39.02", "9:20.21", "14:51.62", "31:27.67"]
x841 = ["841", "6:13.69", "8:38.76", "9:39.28", "9:20.42", "14:51.95", "31:28.42"]
x750 = ["750", "6:29.63", "8:56.64", "10:03.81", "9:39.59", "15:22.45", "32:38.63"]
x749 = ["749", "6:29.81", "8:56.84", "10:04.09", "9:39.81", "15:22.79", "32:39.42"]
x748 = ["748", "6:29.99", "8:57.04", "10:04.37", "9:40.03", "15:23.14", "32:40.22"]
x747 = ["747", "6:30.17", "8:57.25", "10:04.64", "9:40.24", "15:23.48", "32:41.01"]
x746 = ["746", "6:30.35", "8:57.45", "10:04.92", "9:40.46", "15:23.83", "32:41.81"]
x745 = ["745", "6:30.53", "8:57.65", "10:05.20", "9:40.68", "15:24.17", "32:42.61"]
x744 = ["744", "6:30.71", "8:57.86", "10:05.48", "9:40.90", "15:24.52", "32:43.40"]
x743 = ["743", "6:30.89", "8:58.06", "10:05.76", "9:41.11", "15:24.87", "32:44.20"]
x742 = ["742", "6:31.07", "8:58.26", "10:06.04", "9:41.33", "15:25.21", "32:45.00"]
x741 = ["741", "6:31.25", "8:58.47", "10:06.31", "9:41.55", "15:25.56", "32:45.80"]
x650 = ["650", "6:48.30", "9:17.59", "10:32.55", "10:02.06", "15:58.18", "34:00.89"]
x649 = ["649", "6:48.49", "9:17.80", "10:32.85", "10:02.29", "15:58.55", "34:01.75"]
x648 = ["648", "6:48.68", "9:18.02", "10:33.14", "10:02.53", "15:58.92", "34:02.60"]
x647 = ["647", "6:48.88", "9:18.24", "10:33.44", "10:02.76", "15:59.30", "34:03.46"]
x646 = ["646", "6:49.07", "9:18.46", "10:33.74", "10:02.99", "15:59.67", "34:04.31"]
x645 = ["645", "6:49.27", "9:18.67", "10:34.04", "10:03.23", "16:00.04", "34:05.17"]
x644 = ["644", "6:49.46", "9:18.89", "10:34.34", "10:03.46", "16:00.41", "34:06.02"]
x643 = ["643", "6:49.65", "9:19.11", "10:34.64", "10:03.70", "16:00.78", "34:06.88"]
x642 = ["642", "6:49.85", "9:19.33", "10:34.94", "10:03.93", "16:01.16", "34:07.74"]
x641 = ["641", "6:50.04", "9:19.55", "10:35.24", "10:04.17", "16:01.53", "34:08.60"]
x550 = ["550", "7:08.46", "9:40.22", "11:03.60", "10:26.34", "16:36.79", "35:29.77"]
x549 = ["549", "7:08.68", "9:40.45", "11:03.92", "10:26.59", "16:37.20", "35:30.70"]
x548 = ["548", "7:08.89", "9:40.69", "11:04.24", "10:26.84", "16:37.60", "35:31.63"]
x547 = ["547", "7:09.10", "9:40.93", "11:04.57", "10:27.10", "16:38.00", "35:32.56"]
x546 = ["546", "7:09.31", "9:41.16", "11:04.89", "10:27.35", "16:38.41", "35:33.49"]
x545 = ["545", "7:09.52", "9:41.40", "11:05.22", "10:27.61", "16:38.81", "35:34.42"]
x544 = ["544", "7:09.73", "9:41.64", "11:05.54", "10:27.86", "16:39.22", "35:35.35"]
x543 = ["543", "7:09.94", "9:41.88", "11:05.87", "10:28.12", "16:39.62", "35:36.28"]
x542 = ["542", "7:10.15", "9:42.11", "11:06.20", "10:28.37", "16:40.03", "35:37.22"]
x541 = ["541", "7:10.37", "9:42.35", "11:06.52", "10:28.63", "16:40.43", "35:38.15"]
x450 = ["450", "7:30.57", "10:05.02", "11:37.62", "10:52.94", "17:19.10", "37:07.17"]
x449 = ["449", "7:30.80", "10:05.28", "11:37.98", "10:53.22", "17:19.55", "37:08.19"]
x448 = ["448", "7:31.03", "10:05.54", "11:38.34", "10:53.50", "17:19.99", "37:09.22"]
x447 = ["447", "7:31.27", "10:05.80", "11:38.70", "10:53.78", "17:20.44", "37:10.25"]
x446 = ["446", "7:31.50", "10:06.06", "11:39.06", "10:54.06", "17:20.89", "37:11.28"]
x445 = ["445", "7:31.73", "10:06.33", "11:39.42", "10:54.34", "17:21.34", "37:12.31"]
x444 = ["444", "7:31.97", "10:06.59", "11:39.78", "10:54.62", "17:21.78", "37:13.34"]
x443 = ["443", "7:32.20", "10:06.85", "11:40.14", "10:54.91", "17:22.23", "37:14.37"]
x442 = ["442", "7:32.44", "10:07.11", "11:40.50", "10:55.19", "17:22.68", "37:15.41"]
x441 = ["441", "7:32.67", "10:07.38", "11:40.86", "10:55.47", "17:23.13", "37:16.44"]
x350 = ["350", "7:55.30", "10:32.76", "12:15.69", "11:22.70", "18:06.44", "38:56.14"]
x349 = ["349", "7:55.56", "10:33.06", "12:16.09", "11:23.02", "18:06.95", "38:57.30"]
x348 = ["348", "7:55.83", "10:33.36", "12:16.50", "11:23.34", "18:07.45", "38:58.47"]
x347 = ["347", "7:56.09", "10:33.65", "12:16.91", "11:23.66", "18:07.96", "38:59.63"]
x346 = ["346", "7:56.36", "10:33.95", "12:17.32", "11:23.98", "18:08.47", "39:00.80"]
x345 = ["345", "7:56.62", "10:34.25", "12:17.72", "11:24.30", "18:08.98", "39:01.97"]
x344 = ["344", "7:56.89", "10:34.55", "12:18.13", "11:24.62", "18:09.49", "39:03.14"]
x343 = ["343", "7:57.15", "10:34.85", "12:18.54", "11:24.94", "18:09.99", "39:04.32"]
x342 = ["342", "7:57.42", "10:35.15", "12:18.95", "11:25.26", "18:10.51", "39:05.49"]
x341 = ["341", "7:57.69", "10:35.45", "12:19.37", "11:25.58", "18:11.02", "39:06.67"]
x250 = ["250", "8:23.90", "11:04.85", "12:59.71", "11:57.12", "19:01.19", "41:02.16"]
x249 = ["249", "8:24.21", "11:05.20", "13:00.19", "11:57.50", "19:01.79", "41:03.54"]
x248 = ["248", "8:24.52", "11:05.55", "13:00.67", "11:57.88", "19:02.39", "41:04.92"]
x247 = ["247", "8:24.84", "11:05.91", "13:01.16", "11:58.25", "19:02.99", "41:06.30"]
x246 = ["246", "8:25.15", "11:06.26", "13:01.64", "11:58.63", "19:03.59", "41:07.68"]
x245 = ["245", "8:25.47", "11:06.61", "13:02.13", "11:59.01", "19:04.19", "41:09.07"]
x244 = ["244", "8:25.78", "11:06.97", "13:02.61", "11:59.39", "19:04.80", "41:10.46"]
x243 = ["243", "8:26.10", "11:07.32", "13:03.10", "11:59.77", "19:05.40", "41:11.86"]
x242 = ["242", "8:26.42", "11:07.68", "13:03.59", "12:00.15", "19:06.01", "41:13.25"]
x241 = ["241", "8:26.73", "11:08.03", "13:04.08", "12:00.54", "19:06.62", "41:14.65"]
x150 = ["150", "8:59.08", "11:44.33", "13:53.87", "12:39.47", "20:08.54", "43:37.20"]
x149 = ["149", "8:59.49", "11:44.78", "13:54.49", "12:39.96", "20:09.31", "43:38.98"]
x148 = ["148", "8:59.89", "11:45.24", "13:55.12", "12:40.44", "20:10.09", "43:40.76"]
x147 = ["147", "9:00.30", "11:45.69", "13:55.74", "12:40.93", "20:10.87", "43:42.55"]
x146 = ["146", "9:00.71", "11:46.15", "13:56.37", "12:41.42", "20:11.65", "43:44.35"]
x145 = ["145", "9:01.11", "11:46.61", "13:57.00", "12:41.92", "20:12.43", "43:46.16"]
x144 = ["144", "9:01.53", "11:47.07", "13:57.63", "12:42.41", "20:13.22", "43:47.96"]
x143 = ["143", "9:01.94", "11:47.53", "13:58.27", "12:42.91", "20:14.01", "43:49.78"]
x142 = ["142", "9:02.35", "11:48.00", "13:58.90", "12:43.40", "20:14.80", "43:51.60"]
x141 = ["141", "9:02.77", "11:48.46", "13:59.54", "12:43.90", "20:15.59", "43:53.43"]
x50 = ["50", "9:50.19", "12:41.67", "15:12.54", "13:40.98", "21:46.36", "47:22.39"]
x49 = ["49", "9:50.89", "12:42.46", "15:13.62", "13:41.82", "21:47.71", "47:25.48"]
x48 = ["48", "9:51.60", "12:43.25", "15:14.71", "13:42.67", "21:49.06", "47:28.60"]
x47 = ["47", "9:52.31", "12:44.06", "15:15.81", "13:43.54", "21:50.44", "47:31.76"]
x46 = ["46", "9:53.04", "12:44.87", "15:16.92", "13:44.41", "21:51.82", "47:34.95"]
x45 = ["45", "9:53.77", "12:45.69", "15:18.05", "13:45.29", "21:53.22", "47:38.17"]
x44 = ["44", "9:54.51", "12:46.52", "15:19.19", "13:46.18", "21:54.64", "47:41.43"]
x43 = ["43", "9:55.26", "12:47.36", "15:20.34", "13:47.08", "21:56.07", "47:44.73"]
x42 = ["42", "9:56.01", "12:48.21", "15:21.51", "13:47.99", "21:57.52", "47:48.07"]
x41 = ["41", "9:56.78", "12:49.07", "15:22.69", "13:48.91", "21:58.99", "47:51.44"]
x10 = ["10", "10:28.78", "13:24.97", "16:11.94", "14:27.42", "23:00.23", "50:12.43"]
x9 = ["9", "10:30.38", "13:26.76", "16:14.40", "14:29.35", "23:03.30", "50:19.49"]
x8 = ["8", "10:32.07", "13:28.66", "16:17.01", "14:31.39", "23:06.54", "50:26.95"]
x7 = ["7", "10:33.87", "13:30.69", "16:19.79", "14:33.56", "23:09.99", "50:34.90"]
x6 = ["6", "10:35.81", "13:32.86", "16:22.77", "14:35.89", "23:13.70", "50:43.44"]
x5 = ["5", "10:37.92", "13:35.23", "16:26.01", "14:38.43", "23:17.74", "50:52.72"]
x4 = ["4", "10:40.25", "13:37.84", "16:29.60", "14:41.23", "23:22.20", "51:02.99"]
x3 = ["3", "10:42.90", "13:40.81", "16:33.67", "14:44.41", "23:27.26", "51:14.65"]
x2 = ["2", "10:46.03", "13:44.33", "16:38.50", "14:48.19", "23:33.27", "51:28.47"]
x1 = ["1", "10:50.12", "13:48.92", "16:44.80", "14:53.11", "23:41.10", "51:46.49"]
MENS_LONG = [xpoints, x1400, x1399, x1398, x1397, x1396, x1395, x1394, x1393, x1392, x1391, x1350, x1349, x1348, x1347, x1346, x1345, x1344, x1343, x1342, x1341, x1250, x1249, x1248, x1247, x1246, x1245, x1244, x1243, x1242, x1241, x1150, x1149, x1148, x1147, x1146, x1145, x1144, x1143, x1142, x1141, x1050, x1049, x1048, x1047, x1046, x1045, x1044, x1043, x1042, x1041, x950, x949, x948, x947, x946, x945, x944, x943, x942, x941, x850, x849, x848, x847, x846, x845, x844, x843, x842, x841, x750, x749, x748, x747, x746, x745, x744, x743, x742, x741, x650, x649, x648, x647, x646, x645, x644, x643, x642, x641, x550, x549, x548, x547, x546, x545, x544, x543, x542, x541, x450, x449, x448, x447, x446, x445, x444, x443, x442, x441, x350, x349, x348, x347, x346, x345, x344, x343, x342, x341, x250, x249, x248, x247, x246, x245, x244, x243, x242, x241, x150, x149, x148, x147, x146, x145, x144, x143, x142, x141, x50, x49, x48, x47, x46, x45, x44, x43, x42, x41, x10, x9, x8, x7, x6, x5, x4, x3, x2, x1]





end