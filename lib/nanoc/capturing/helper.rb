# encoding: utf-8

require 'nanoc/capturing'

module Nanoc::Capturing

  module Helper

    # @api private
    class CapturesStore

      def initialize
        @store = {}
      end

      def []=(item, name, content)
        @store[item.identifier] ||= {}
        @store[item.identifier][name] = content
      end

      def [](item, name)
        @store[item.identifier] ||= {}
        @store[item.identifier][name]
      end

    end

    class ::Nanoc::Site

      # @api private
      def captures_store
        @captures_store ||= CapturesStore.new
      end

      # @api private
      def captures_store_compiled_items
        require 'set'
        @captures_store_compiled_items ||= Set.new
      end

    end

    def content_for(*args, &block)
      if block_given? # Set content
        # Get args
        if args.size != 1
          raise ArgumentError, "expected 1 argument (the name " +
            "of the capture) but got #{args.size} instead"
        end
        name = args[0]

        # Capture and store
        content = capture(&block)
        @site.captures_store[@item, name.to_sym] = content
      else # Get content
        # Get args
        if args.size != 2
          raise ArgumentError, "expected 2 arguments (the item " +
            "and the name of the capture) but got #{args.size} instead"
        end
        item = args[0]
        name = args[1]

        # Create dependency
        current_item = @_compiler.dependency_tracker.top
        unwrapped_item = item.item
        if unwrapped_item != current_item
          Nanoc::NotificationCenter.post(:visit_started, unwrapped_item)
          Nanoc::NotificationCenter.post(:visit_ended,   unwrapped_item)

          # This is an extremely ugly hack to get the compiler to recompile the
          # item from which we use content. For this, we need to manually edit
          # the content attribute to reset it. :(
          # FIXME clean this up
          if !@site.captures_store_compiled_items.include? item
            @site.captures_store_compiled_items << item
            item.forced_outdated = true
            item.reps.each do |r|
              content = item.content
              r.content = { :raw => content, :last => content }
              @_compiler.send(:compile_rep, r)
            end
          end
        end

        # Get content
        @site.captures_store[item, name.to_sym]
      end
    end

    def capture(&block)
      # Get erbout so far
      erbout = eval('_erbout', block.binding)
      erbout_length = erbout.length

      # Execute block
      block.call

      # Get new piece of erbout
      erbout_addition = erbout[erbout_length..-1]

      # Remove addition
      erbout[erbout_length..-1] = ''

      # Depending on how the filter outputs, the result might be a
      # single string or an array of strings (slim outputs the latter).
      erbout_addition = erbout_addition.join if erbout_addition.is_a? Array

      # Done.
      erbout_addition
    end

  end

end
