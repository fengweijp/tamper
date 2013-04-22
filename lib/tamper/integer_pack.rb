module Tamper
  class IntegerPack < Pack

    def encoding
      :integer
    end

    def encode(idx, data)
      choice_data = data[attr_name.to_s]
      choice_data = [choice_data] unless choice_data.is_a?(Array)

      (0...max_choices).each do |choice_idx|
        choice_offset = (item_window_width * idx) + (bit_window_width * choice_idx)

        value = choice_data[choice_idx]

        possibility_id = possibilities.index(value)

        bit_code = possibility_id.to_i.to_s(2).split('') # converts to str binary representation
        bit_code_length_pad = bit_window_width - bit_code.length
        bit_code.each_with_index do |bit, bit_idx|
          @bitset[(choice_offset + bit_code_length_pad + bit_idx)] = bit == "1"
        end
      end

    end

    def initialize_pack!(max_guid)
      @bit_window_width = Math.log2(possibilities.length).ceil
      @item_window_width = bit_window_width * max_choices
      @bitset = Bitset.new(item_window_width * (max_guid + 1))
    end

  end
end