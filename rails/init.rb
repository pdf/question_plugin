require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'

Dispatcher.to_prepare :question_plugin do
  require_dependency 'journal'
  require_dependency 'query'
  require_dependency 'issue'
  require_dependency 'queries_helper'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Journal.included_modules.include? QuestionPlugin::JournalPatch
    Journal.send(:include, QuestionPlugin::JournalPatch)
  end
  unless Query.included_modules.include? QuestionPlugin::QueryPatch
    Query.send(:include, QuestionPlugin::QueryPatch)
  end
  unless Issue.included_modules.include? QuestionPlugin::IssuePatch
    Issue.send(:include, QuestionPlugin::IssuePatch)
  end
  unless QueriesHelper.included_modules.include? QuestionPlugin::QueriesHelperPatch
    QueriesHelper.send(:include, QuestionPlugin::QueriesHelperPatch)
  end
end


require 'question_issue_hooks'
require 'question_layout_hooks'
require 'question_journal_hooks'

require_dependency 'journal_questions_observer'
ActiveRecord::Base.observers << :journal_questions_observer

Redmine::Plugin.register :question_plugin do
  name 'Redmine Question plugin'
  author 'Eric Davis'
  url "https://projects.littlestreamsoftware.com/projects/redmine-questions" if respond_to?(:url)
  author_url 'http://www.littlestreamsoftware.com' if respond_to?(:author_url)
  description 'This is a plugin for Redmine that will allow users to ask questions to each other in issue notes'
  version '0.3.0'

  requires_redmine :version_or_higher => '0.8.0'

end
