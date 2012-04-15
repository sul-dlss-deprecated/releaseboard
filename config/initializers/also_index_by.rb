class Array
  def also_index_by(attr)
    m = eval(%{Module.new do
      def [] *args
        if args.first.is_a?(String)
          key = args.first
          self.find { |e| e.send(:#{attr}) == key }
        else
          super *args
        end
      end
    end})
    self.extend(m)
  end
end
