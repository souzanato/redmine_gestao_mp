module MyPlugin
  class Hooks < Redmine::Hook::ViewListener
    # This just renders the partial in
    # app/views/hooks/my_plugin/_view_issues_form_details_bottom.rhtml
    # The contents of the context hash is made available as local variables to the partial.
    #
    # Additional context fields
    #   :issue  => the issue this is edited
    #   :f      => the form object to create additional fields
    # render_on :view_issues_form_details_bottom, :partial => 'redmine_gestao_mp_risks/risk_setup'

    # render_on :view_issues_show_description_bottom, :partial => "redmine_gestao_mp_risk_setups/risk_setup", locals: {risks_from_issue: true}
  end
end