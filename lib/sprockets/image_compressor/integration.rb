module Sprockets
  module ImageCompressor
    class Integration
      def self.setup env
        monkey_patch_older_sprockets!

        env.register_mime_type 'image/png', '.png'
        env.register_postprocessor 'image/png', :png_compressor do |context, data|
          PngCompressor.new.compress data
        end

        env.register_mime_type 'image/jpeg', '.jpg'
        env.register_postprocessor 'image/jpeg', :jpg_compressor do |context, data|
          JpgCompressor.new.compress data
        end
      end

      # Rails locks down Sprockets to an older version, which will cause the image compressor to barf on ruby 1.9.
      # Monkey patch in binary fixes from Sprockets 2.2.0.
      def self.monkey_patch_older_sprockets!
        return unless Sprockets::VERSION =~ /2\.[01]\.\d/ # Sprockets version >= 2.0.0 and < 2.2.0
        return unless "".respond_to?(:valid_encoding?) # is ruby 1.9?

        Sprockets::BundledAsset.class_eval do
          def build_dependency_context_and_body
            start_time = Time.now.to_f

            context = blank_context

            # Read original data once and pass it along to `Context`
            mime_type = environment.mime_types(pathname.extname)
            encoding = environment.encoding_for_mime_type(mime_type)
            if encoding && "".respond_to?(:valid_encoding?)
              data = Sprockets::Utils.read_unicode(pathname, encoding)
            else
              data = Sprockets::Utils.read_unicode(pathname)
            end

            # Prime digest cache with data, since we happen to have it
            environment.file_digest(pathname, data)

            # Runs all processors on `Context`
            body = context.evaluate(pathname, :data => data)

            @dependency_context, @body = context, body

            elapsed_time = ((Time.now.to_f - start_time) * 1000).to_i
            logger.info "Compiled #{logical_path}  (#{elapsed_time}ms)  (pid #{Process.pid})"

            return context, body
          end
        end

        Sprockets::Context.class_eval do
          def evaluate(path, options = {})
            pathname   = resolve(path)
            attributes = environment.attributes_for(pathname)
            processors = options[:processors] || attributes.processors

            if options[:data]
              result = options[:data]
            else
              mime_type = environment.mime_types(pathname.extname)
              encoding = environment.encoding_for_mime_type(mime_type)
              if encoding && "".respond_to?(:valid_encoding?)
                result = Sprockets::Utils.read_unicode(pathname, encoding)
              else
                result = Sprockets::Utils.read_unicode(pathname)
              end
            end

            processors.each do |processor|
              begin
                template = processor.new(pathname.to_s) { result }
                result = template.render(self, {})
              rescue Exception => e
                annotate_exception! e
                raise
              end
            end

            result
          end
        end

        Sprockets::Mime.module_eval do
          # Mime types that should be opened with BINARY encoding.
          def binary_mime_types
            @binary_mime_types ||= [ %r{^(image|audio|video)/} ]
          end

          # Returns the correct encoding for a given mime type, while falling
          # back on the default external encoding, if it exists.
          def encoding_for_mime_type(type)
            encoding = "BINARY" if binary_mime_types.any? { |matcher| matcher === type }
            encoding ||= default_external_encoding if respond_to?(:default_external_encoding)
            encoding
          end
        end

        Sprockets::Utils.module_eval do
          def self.utf8_bom_pattern
            @ut8_bom_pattern ||= Regexp.new("\\A\uFEFF".encode('utf-8'))
          end

          def self.read_unicode(pathname, external_encoding = Encoding.default_external)
            pathname.open("r:#{external_encoding}") do |f|
              f.read.tap do |data|
                # Eager validate the file's encoding. In most cases we
                # expect it to be UTF-8 unless `default_external` is set to
                # something else. An error is usually raised if the file is
                # saved as UTF-16 when we expected UTF-8.
                if !data.valid_encoding?
                  raise EncodingError, "#{pathname} has a invalid " +
                  "#{data.encoding} byte sequence"

                  # If the file is UTF-8 and theres a BOM, strip it for safe concatenation.
                elsif data.encoding.name == "UTF-8" && data =~ utf8_bom_pattern
                  data.sub!(utf8_bom_pattern, "")
                end
              end
            end
          end
        end
      end
    end
  end
end
