module SpriteFactory
  module Layout
    module Horizontal

      def self.layout(images, options = {})
        width      = options[:width]
        height     = options[:height]
        hpadding   = options[:hpadding] || 0
        vpadding   = options[:vpadding] || 0
        hmargin  = options[:hmargin] || 0
        vmargin  = options[:vmargin] || 0
        max_height = height || (2 *(vpadding + vmargin) + images.map{|i| i[:height]}.max)
        x = 0
        images.each do |i|

          if width
            i[:cssw] = width
            i[:cssx] = x
            i[:x]    = x + (width - i[:width]) / 2
          else
            i[:cssw] = i[:width]  + (2 * hpadding)   # image width plus padding
            i[:cssx] = x + hmargin                   # anchored at x
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

          x += i[:cssw] + 2 * hmargin

        end 
        { :width  => x, :height => max_height }
      end

    end
  end
end
