class Search
  LOCATION = %w(Everywhere Questions Answers Comments Users).freeze

  def self.find(query, location)
    return unless Search::LOCATION.include?(location)

    query = ThinkingSphinx::Query.escape(query)
    return ThinkingSphinx.search(query) if location == 'Everywhere'
    location.classify.constantize.search(query)
  end
end
