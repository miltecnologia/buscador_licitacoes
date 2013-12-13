class ORBuilder
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
        condition_with_or = nil
        if @conditions.length > 0
            condition_with_or = ""
            @conditions.each{|c| condition_with_or += c.to_s}
            condition_with_or.gsub! ")(", ") OR ("
        end
        condition_with_or
    end
end
