require 'open-uri'
require 'zlib'
require 'yajl'

module GHRepoStats
  class StatsQuery
    attr_accessor :after, :before, :event, :count, :output_presenter
    attr_reader   :events, :repos

    def initialize(options={})
      after   = options[:after]  || (DateTime.now - 7).strftime("%Y-%m-%d")
      before  = options[:before] || (DateTime.now).strftime("%Y-%m-%d")

      @after  = DateTime.parse(after).new_offset(0)
      @before = DateTime.parse(before).new_offset(0)

      @event  = options[:event]
      @count  = options[:count] || 10

      @events = []
      @repos  = []

      @output_presenter = options[:output_presenter] || GHRepoStats::StandardOutput
    end

    def call
      printf "Retrieving Data AFTER #{@after.strftime('%B %d, %Y - %H:%M')} and BEFORE #{@before.strftime('%B %d, %Y - %H:%M')}"
      printf " for EVENT #{@event}" if @event
      printf " COUNT #{@count}" 
      printf "\n<- "

      # Collect
      threads = []
      date_range.each do |date|
        threads << Thread.new {
          begin
            load_events_for_date(date)
            printf "."
          rescue OpenURI::HTTPError
          end
        }
      end
      threads.each { |t| t.join }

      puts " ->"
      
      # Display
      @output_presenter.render(self)
    end

    private

    def date_range
      date_range = ( @after..(@before + 1) ).to_a
      date_range.map { |dt| dt.strftime("%Y-%m-%d-0").strip }
    end

    def load_events_for_date(date)
      gz = open("http://data.githubarchive.org/#{date}.json.gz")
      js = Zlib::GzipReader.new(gz).read
      Yajl::Parser.parse(js) do |event|
        event['url'] = event['repository'].nil? ? event['url'] : event['repository']['url']
        @events << event if valid_event_type_for_event?(event) && valid_time_for_event?(event)
      end
    end

    def valid_event_type_for_event?(e)
      return true unless @event
      e['type'] == @event
    end

    def valid_time_for_event?(e)
      event_time = DateTime.parse(e['created_at']).new_offset(0)
      event_time > @after && event_time < @before
    end

  end

  class StandardOutput
    def self.render(obj)
      repos = obj.events.group_by { |e| e['url'] }.sort_by { |repo, entries| entries.length }.reverse.slice(0..(obj.count.to_i - 1))
      repos.each { |repo, entries| puts "#{repo.gsub('https://github.com/','')} - #{entries.length}" }
    end
  end
end