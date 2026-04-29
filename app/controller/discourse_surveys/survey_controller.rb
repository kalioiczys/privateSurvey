# frozen_string_literal: true

module DiscourseSurveys
  class SurveyController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    # Allow submit_response through without login — we gate it inside the action
    before_action :ensure_logged_in, except: %i[submit_response]

    # Skip CSRF token verification for anonymous submissions (they won't have one)
    skip_before_action :verify_authenticity_token, only: [:submit_response], if: -> { current_user.blank? }

    def submit_response
      post_id = params.require(:post_id)
      survey_name = params.require(:survey_name)
      response = params.require(:response)

      # If not logged in, only allow submission to posts listed in the site setting
      if current_user.blank?
        allowed_ids = SiteSetting.public_survey_post_ids.split("|").map(&:to_i)
        unless allowed_ids.include?(post_id.to_i)
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