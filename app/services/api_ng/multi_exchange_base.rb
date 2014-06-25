module ApiNg
  module MultiExchangeBase

    def initialize(params={})
      single_exchange_class = nesting_class_name.constantize
      @au_rpc = single_exchange_class.new(:aus, params)
      @uk_rpc = single_exchange_class.new(:uk, params)
    end

    def call
      sort(merge_results(@au_rpc.call, @uk_rpc.call))
    end

    def merge_results(au_result, uk_result)
      au_result + uk_result
    end

    def sort(result)
      result
    end

    def nesting_class_name
      self.class.name.deconstantize
    end

    def paginate(page, page_size)
      self.page = page
      self.page_size = page_size
      call[from_record..to_record]
    end
  end
end
