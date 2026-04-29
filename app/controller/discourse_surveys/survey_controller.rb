# frozen_string_literal: true

module DiscourseSurveys
  class SurveyController < ::ApplicationController
    requires_plugin PLUGIN_NAME
 
    # Allow submit_response through without login — we gate it inside the action
    before_action :ensure_logged_in, except: %i[submit_response]
 
    # Skip CSRF token verification for anonymous submissions (they won't have one)
    skip_before_action :verify_authenticity_token, only: [:submit_response], if: -> { current_user.blank? }
 
    ANONYMOUS_SURVEY_POST_ID = 56
 
    def submit_response
      post_id = params.require(:post_id)
      survey_name = params.require(:survey_name)
      response = params.require(:response)
 
      # If not logged in, only allow submission to the specific application survey
      if current_user.blank?
        unless post_id.to_i == ANONYMOUS_SURVEY_POST_ID
          raise Discourse::NotLoggedIn
        end
      end
 
      begin
        DiscourseSurveys::Helper.submit_response(post_id, survey_name, response, current_user)
        render json: success_json
      rescue StandardError => e
        render_json_error e.message
      end
    end
  end
end
