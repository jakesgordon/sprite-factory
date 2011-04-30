module SpriteFactory
  module Layout

    #--------------------------------------------------------------------------

    def self.horizontal(images, options = {})
      width      = options[:width]
      height     = options[:height]
      hpadding   = options[:hpadding] || 0
      vpadding   = options[:vpadding] || 0
      max_height = height || ((2 * vpadding) + images.map{|i| i[:height]}.max)
      x = 0
      images.each do |i|

        if width
          i[:cssw] = width
          i[:cssx] = x
          i[:x]    = x + (width - i[:width]) / 2
        else
          i[:cssw] = i[:width]  + (2 * hpadding)   # image width plus padding
          i[:cssx] = x                             # anchored at x
          i[:x] = i[:cssx] + hpadding              # image drawn offset to account for padding
        end

        if height
          i[:cssh] = height
          i[:cssy] = 0
          i[:y]    = 0 + (height - i[:height]) / 2
        else
          i[:cssh] = i[:height] + (2 * vpadding)   # image height plus padding
          i[:cssy] = (max_height - i[:cssh]) / 2   # centered vertically
          i[:y]    = i[:cssy] + vpadding           # image drawn offset to account for padding
        end

        x = x + i[:cssw]

      end 
      { :width  => x, :height => max_height }
    end

    #--------------------------------------------------------------------------

    def self.vertical(images, options = {})
      width     = options[:width]
      height    = options[:height]
      hpadding  = options[:hpadding] || 0
      vpadding  = options[:vpadding] || 0
      max_width = width || ((2 * hpadding) + images.map{|i| i[:width]}.max)
      y = 0
      images.each do |i|

        if width
          i[:cssw] = width
          i[:cssx] = 0
          i[:x]    = 0 + (width - i[:width]) / 2
        else
          i[:cssw] = i[:width]  + (2 * hpadding)  # image width plus padding
          i[:cssx] = (max_width - i[:cssw]) / 2   # centered horizontally
          i[:x]    = i[:cssx] + hpadding          # image drawn offset to account for padding
        end

        if height
          i[:cssh] = height
          i[:cssy] = y
          i[:y]    = y + (height - i[:height]) / 2
        else
          i[:cssh] = i[:height] + (2 * vpadding)  # image height plus padding
          i[:cssy] = y                            # anchored at y
          i[:y]    = i[:cssy] + vpadding          # image drawn offset to account for padding
        end

        y = y + i[:cssh]

      end
      { :width => max_width, :height => y }
    end

    #--------------------------------------------------------------------------

    def self.knapsack(images)

      raise NotImplementedError, "one day, when I have time, I'll do some kind of 'best-fit' algorithm"

    end

    #--------------------------------------------------------------------------

  end
end
