class ANDBuilder
    def initialize
        @conditions = []
    end
    def append condition
        @conditions << "(#{condition.to_s})"
    end
    def valid?
       @conditions.length > 0
    end
    def query
        condition_with_and = nil
        if @conditions.length > 0
            condition_with_and = ""
            @conditions.each{|c| condition_with_and += c.to_s}
            condition_with_and.gsub! ")(", ") AND ("
        end
        condition_with_and
    end
end
