# GHRepoStats

# Installation

  $ gem install gh_repo_stats

# Requirements

Ruby 1.9.3+

# Usage

## Command Line

	gh_repo_stats [--after DATETIME] [--before DATETIME] [--event EVENT_NAME] [-n COUNT]

## In Your Application
	require 'gh_repo_stats'

  	options = {}
  	query = GHRepoStats::StatsQuery.new(options)
  	query.call
  	
  	# Available options are the same as for the command line:
	
	after:  Date & Time to start query from   ( default: '7 days ago' )
  	before: Date & Time to stop query at      ( default 'today' )
  	event:  What events to filter query by
  	count:  Number of results to return

There is an additional option if you are using the gem from your application to change how data the data is presented:

	output_presenter: YOUR_PRESENTER_CLASS  ( this class can be a custom class you created that supports the render method )

Example:

	  class DisplayEvents
	    def self.render(obj)
	      obj.events.slice(0..obj.count.to_i).map { |e| "Event URL: #{e['url']}, Event Type: #{e['type']}"}
	    end
	  end
	
	  query = GHRepoStats::StatsQuery.new(output_presenter: DisplayEvents)
	  query.call

