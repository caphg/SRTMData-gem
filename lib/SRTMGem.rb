require "SRTMGem/version"
require 'zip'
require "open-uri"

  class SRTM
    def initialize(*args)
      unless args.is_a?(Array)
        if File.exist?(args)
          @input_file = File.open(args, 'rb')
        else
          puts 'File does not exist!'
        end
      else
        if args.length == 2
          args = args.to_a
          fetch_file(args[0], args[1])
        else
          puts 'Wrong number of parameters. You should input longitude and latitude, example: N44, E16, that will download the appropriate tile.'
        end
      end
    end


    def fetch_file(longitude, latitude)
      File.open('temp.tmp.zip', 'wb') do |fo|
        fo.write open("http://dds.cr.usgs.gov/srtm/version2_1/SRTM3/Eurasia/#{longitude}#{latitude}.hgt.zip").read
      end
      Zip::File.open('temp.tmp.zip') do |zipfile|
        zipfile.each do |file|
          @input_file = file.get_input_stream.read
        end
      end
    end

    def get_elevation(longitude, latitude)
      d_longitude = longitude
      d_latitude = latitude
      i_longitude = d_longitude.to_i
      i_latitude = d_latitude.to_i
      intervals = 1200

      if d_longitude < 0
        i_longitude = (i_longitude - 1) * -1
        d_longitude = (i_longitude + d_longitude) + i_longitude.to_f
      end

      if d_latitude < 0
        i_latitude = (i_latitude - 1) * -1
        d_latitude = (i_latitude.to_f + d_latitude) + i_latitude.to_f
      end


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
      d_left_top = read_bin(position)
      position = ((intervals - i_latitude_index) * (intervals + 1)) + i_longitude_index
      d_left_bottom = read_bin(position)
      position = (((intervals - i_latitude_index) - 1) * (intervals + 1)) + i_longitude_index +1
      d_right_top = read_bin(position)
      position = ((intervals - i_latitude_index) * (intervals + 1)) + i_longitude_index + 1
      d_right_bottom = read_bin(position)


      d_delta_longitude = d_longitude_offset - (i_longitude_index.to_f * (1 / intervals.to_f))
      d_delta_latitude = d_latitude_offset - (i_latitude_index.to_f * (1 / intervals.to_f))

      d_longitude_height_left = d_left_bottom - calc_elev(d_left_bottom - d_left_top, 1 / intervals.to_f, d_delta_latitude)
      d_longitude_height_right = d_right_bottom - calc_elev(d_right_bottom - d_right_top, 1 / intervals.to_f, d_delta_latitude)

      d_elevation = d_longitude_height_left - calc_elev(d_longitude_height_left - d_longitude_height_right, 1 / intervals.to_f, d_delta_longitude)
      return d_elevation + 0.5
    end

    private
    def read_bin(position)
      @input_file.seek(position * 2)
      bytes = @input_file.read(2)
      first_byte = bytes[0].ord
      second_byte = bytes[1].ord
      return first_byte * 256 + second_byte
    end

    def calc_elev(height, length, diff)
      return (height * diff) / length
    end
  end

