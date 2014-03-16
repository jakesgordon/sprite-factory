module SpriteFactory
  module Library
    module ImageMagick

      # Represents an error from an underlying ImageMagick call
      class Error < RuntimeError
        attr_reader :command
        attr_reader :args
        attr_reader :output
        
        def initialize(msg, command, args, output)
          super(msg)
          @command = command
          @args = args
          @output = output
        end
      end

      VALID_EXTENSIONS = [:png, :jpg, :jpeg, :gif, :ico]

      def self.load(files)
        files.map do |filename|
          path = "#{filename}[0]"   # layer 0
          output = run("identify", ['-format', '%wx%h', path])
          
          width, height = output.chomp.split(/x/).map(&:to_i)
          {
            :filename => filename,
            :path     => path,
            :width    => width,
            :height   => height
          }
        end
      end

      def self.create(filename, images, width, height)
        # we want to invoke:
        # convert -size #{width}x#{height} xc:none
        #   #{input} -geometry +#{x}+#{y} -composite
        # #{output}
        
        args = ["-size", "#{width}x#{height}", "xc:none"]
        images.each do |image|
          args +=  [image[:path], "-geometry", "+#{image[:x]}+#{image[:y]}", "-composite"]
        end
        args << filename
        
        run("convert", args)
        true
      end
      
      protected
      def self.run(command, args)
        full_command = [command] + args.map(&:to_s)
        
        r, w = IO.pipe
        pid = Process.spawn(*full_command, {[:out, :err] => w})
        
        w.close
        output = r.read
        
        Process.waitpid(pid)
        success = $?.exitstatus == 0 ? true : false
        
        if !success
          raise Error.new("error running `#{command}` (check $!.args/$!.output for more information)", command, args, output)
        end
        
        output
      end
      
    end # module ImageMagick
  end # module Library
end # module SpriteFactory
