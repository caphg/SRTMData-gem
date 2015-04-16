require_relative "SRTMGem/version"

  class SRTM
    def initialize(dir)
      @srtm_dir = dir
    end


    def get_elevation(longitude, latitude)
      d_longitude = longitude
      d_latitude = latitude
      i_longitude = d_longitude.to_i
      i_latitude = d_latitude.to_i
      intervals = 1200
      file_parts = ['N' + i_latitude.to_s, 'E' + i_longitude.to_s, '.hgt']

      if d_longitude < 0
        i_longitude = (i_longitude - 1) * -1
        d_longitude = (i_longitude + d_longitude) + i_longitude.to_f
        file_parts[1] = 'W' + (i_longitude - 1).to_s
      end

      if d_latitude < 0
        i_latitude = (i_latitude - 1) * -1
        d_latitude = (i_latitude.to_f + d_latitude) + i_latitude.to_f
        file_parts[0] = 'S' + (i_latitude - 1).to_s
      end

      file = file_parts.join()

      i_longitude_index = ((d_longitude - i_longitude.to_f) * intervals).to_i
      i_latitude_index = ((d_latitude - i_latitude.to_f) * intervals).to_i


      if i_longitude_index >= intervals
        i_longitude_index = intervals - 1
      end

      if i_latitude_index >= intervals
        i_latitude_index = intervals - 1
      end


      d_longitude_offset = d_longitude - i_longitude.to_f
      d_latitude_offset = d_latitude - i_latitude.to_f


      position = (((intervals - i_latitude_index) - 1) * (intervals + 1)) + i_longitude_index
      d_left_top = read_bin(position, file)
      position = ((intervals - i_latitude_index) * (intervals + 1)) + i_longitude_index
      d_left_bottom = read_bin(position, file)
      position = (((intervals - i_latitude_index) - 1) * (intervals + 1)) + i_longitude_index +1
      d_right_top = read_bin(position, file)
      position = ((intervals - i_latitude_index) * (intervals + 1)) + i_longitude_index + 1
      d_right_bottom = read_bin(position, file)


      d_delta_longitude = d_longitude_offset - (i_longitude_index.to_f * (1 / intervals.to_f))
      d_delta_latitude = d_latitude_offset - (i_latitude_index.to_f * (1 / intervals.to_f))

      d_longitude_height_left = d_left_bottom - calc_elev(d_left_bottom - d_left_top, 1 / intervals.to_f, d_delta_latitude)
      d_longitude_height_right = d_right_bottom - calc_elev(d_right_bottom - d_right_top, 1 / intervals.to_f, d_delta_latitude)

      d_elevation = d_longitude_height_left - calc_elev(d_longitude_height_left - d_longitude_height_right, 1 / intervals.to_f, d_delta_longitude)
      return d_elevation + 0.5
    end

    private
    def read_bin(position,file)
      input_file = File.open(@srtm_dir + '/' + file, 'rb')
      input_file.seek(position * 2)
      bytes = input_file.read(2)
      first_byte = bytes[0].ord
      second_byte = bytes[1].ord
      return first_byte * 256 + second_byte
    end

    def calc_elev(height, length, diff)
      return (height * diff) / length
    end
  end

