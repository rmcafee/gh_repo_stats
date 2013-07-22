require "gh_repo_stats/version"
require "thor"

module GHRepoStats
  class CLI < Thor
    default_task :gh_repo_stats

    desc "[--after DATETIME] [--before DATETIME] [--event EVENT_NAME] [-n COUNT]", "Retrieve Event Stats from Github Archives"
    option :after,    banner: "Limit results to after this DATETIME"
    option :before,   banner: "Limit results to before this DATETIME"
    option :event,    banner: "Limit results to an EVENT NAME"
    option :count,    banner: "Limit the number of results in the output"

    def gh_repo_stats
      puts options
      # puts "Github Reports after:#{after} before:#{before} event:#{event} count:#{count}"
    end

    # Override help to get options for the only current command in CLI
    def help
      super(:gh_repo_stats)
    end

  end
end