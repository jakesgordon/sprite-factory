module SpriteFactory
  module Layout
    module Packed

      #------------------------------------------------------------------------

      def self.layout(images, options = {})

        raise NotImplementedError, ":packed layout does not support the :padding and :margin option" if (options[:padding].to_i > 0) || (options[:hpadding].to_i > 0) || (options[:vpadding].to_i > 0) || (options[:margin].to_i > 0) || (options[:hmargin].to_i > 0) || (options[:vmargin].to_i > 0)
        raise NotImplementedError, ":packed layout does not support fixed :width/:height option" if options[:width] || options[:height]

        return { :width => 0, :height => 0 } if images.empty?

        images.sort! do |a,b|
          diff = [b[:width], b[:height]].max <=> [a[:width], a[:height]].max
          diff = [b[:width], b[:height]].min <=> [a[:width], a[:height]].min if diff.zero?
          diff = b[:height] <=> a[:height] if diff.zero?
          diff = b[:width]  <=> a[:width]  if diff.zero?
          diff
        end

        root = { :x => 0, :y => 0, :w => images[0][:width], :h => images[0][:height] }

        images.each do |i|
          if (node = findNode(root, i[:width], i[:height]))
            placeImage(i, node)
            splitNode(node, i[:width], i[:height])
          else
            root = grow(root, i[:width], i[:height])
            redo
          end
        end

        { :width => root[:w], :height => root[:h] }

      end

      def self.placeImage(image, node)
        image[:cssx] = image[:x] = node[:x]  # TODO
        image[:cssy] = image[:y] = node[:y]  #   * support for :padding option
        image[:cssw] = image[:width]         #   * support for fixed :width/:height option
        image[:cssh] = image[:height]
      end

      def self.findNode(root, w, h)
        if root[:used]
          findNode(root[:right], w, h) || findNode(root[:down], w, h)
        elsif (w <= root[:w]) && (h <= root[:h])
          root
        end
      end

      def self.splitNode(node, w, h)
        node[:used]  = true
        node[:down]  = { :x => node[:x],     :y => node[:y] + h, :w => node[:w],     :h => node[:h] - h }
        node[:right] = { :x => node[:x] + w, :y => node[:y],     :w => node[:w] - w, :h => h            }
      end

      def self.grow(root, w, h)

        canGrowDown  = (w <= root[:w])
        canGrowRight = (h <= root[:h])

        shouldGrowRight = canGrowRight && (root[:h] >= (root[:w] + w))
        shouldGrowDown  = canGrowDown  && (root[:w] >= (root[:h] + h))

        if shouldGrowRight
          growRight(root, w, h)
        elsif shouldGrowDown
          growDown(root, w, h)
        elsif canGrowRight
          growRight(root, w, h)
        elsif canGrowDown
          growDown(root, w, h)
        else
          raise RuntimeError, "can't fit #{w}x#{h} block into root #{root[:w]}x#{root[:h]} - this should not happen if images are pre-sorted correctly"
        end

      end

      def self.growRight(root, w, h)
        return {
          :used  => true,
          :x     => 0,
          :y     => 0,
          :w     => root[:w] + w,
          :h     => root[:h],
          :down  => root,
          :right => { :x => root[:w], :y => 0, :w => w, :h => root[:h] }
        }
      end

      def self.growDown(root, w, h)
        return {
          :used  => true,
          :x     => 0,
          :y     => 0,
          :w     => root[:w],
          :h     => root[:h] + h,
          :down  => { :x => 0, :y => root[:h], :w => root[:w], :h => h },
          :right => root
        }
      end

      end # module Packed
  end # module Layout
end # module SpriteFactory
