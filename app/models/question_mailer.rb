class QuestionMailer < Mailer
  def asked_question(journal)
    question = journal.question
    subject "[Question - #{question.issue.tracker.name} ##{question.issue.id}] #{question.issue.subject}"
    recipients question.assigned_to.mail unless question.assigned_to.nil?
    @from  = "#{question.author.name} (Redmine) <#{Setting.mail_from}>" unless question.author.nil?

    body({
      :question => question,
      :issue => question.issue,
      :journal => journal,
      :issue_url => url_for(:controller => 'issues', :action => 'show', :id => question.issue)
    })

    render_multipart('asked_question', body)

    RAILS_DEFAULT_LOGGER.debug 'Sending QuestionMailer#asked_question'
  end
  
  def answered_question(question, closing_journal)
    subject "[Answered - #{question.issue.tracker.name} ##{question.issue.id}] #{question.issue.subject}"
    recipients question.author.mail unless question.author.nil?
    @from = "#{question.assigned_to.name} (Redmine) <#{Setting.mail_from}>" unless question.assigned_to.nil?

    body({
      :question => question,
      :issue => question.issue,
      :journal => closing_journal,
      :issue_url => url_for(:controller => 'issues', :action => 'show', :id => question.issue)
    })

    render_multipart('answered_question', body)

    RAILS_DEFAULT_LOGGER.debug 'Sending QuestionMailer#answered_question'
  end
  
end
