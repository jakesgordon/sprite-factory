module SpriteFactory
  module Layout
    module Vertical

      def self.layout(images, options = {})
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

    end
  end
end
