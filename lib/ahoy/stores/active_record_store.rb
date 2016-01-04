module Ahoy
  module Stores
    class ActiveRecordStore < BaseStore
      def track_visit(options, &block)
        visit = visit_model.new(
          visitor_id: ahoy.visitor_id,
          started_at: options[:started_at]
        )

        visit.id = ahoy.visit_id
        visit.user = user if visit.respond_to?(:user=)

        set_visit_properties(visit)

        yield(visit) if block_given?

        begin
          visit.save!
          geocode(visit)
        rescue *unique_exception_classes
          # do nothing
        end
      end

      def track_event(name, properties, options, &block)
        event = event_model.new(
          visit_id: ahoy.visit_id,
          name: name,
          properties: properties,
          time: options[:time]
        )

        event.id = options[:id]
        event.user = user if event.respond_to?(:user=)

        yield(event) if block_given?

        begin
          event.save!
        rescue *unique_exception_classes
          # do nothing
        end
      end

      def visit
        @visit ||= visit_model.where(id: ahoy.visit_id).first if ahoy.visit_id
      end

      protected

      def visit_model
        ::Visit
      end

      def event_model
        ::Ahoy::Event
      end
    end
  end
end
