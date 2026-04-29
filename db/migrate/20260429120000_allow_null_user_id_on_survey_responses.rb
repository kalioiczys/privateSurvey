# frozen_string_literal: true

class AllowNullUserIdOnSurveyResponses < ActiveRecord::Migration[7.0]
  def change
    change_column_null :survey_responses, :user_id, true
  end
end
