# frozen_string_literal: true

module DiscourseSurveys
  PLUGIN_NAME = "privateSurvey".freeze
  HAS_SURVEYS = "has_surveys"
  DEFAULT_SURVEY_NAME = "survey"
  DATA_PREFIX = "data-survey-"

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseSurveys

    config.after_initialize do
      Discourse::Application.routes.append { mount ::DiscourseSurveys::Engine, at: "/" }
    end
  end
end
