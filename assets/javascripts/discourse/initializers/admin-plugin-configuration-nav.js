import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "discourse-surveys-admin-plugin-configuration-nav",

  initialize(container) {
    const currentUser = container.lookup("service:current-user");
    if (!currentUser?.admin) {
      return;
    }

    withPluginApi((api) => {
      api.addAdminPluginConfigurationNav("privateSurvey", [
        {
          label: "discourse_surveys.admin.export_tab",
          route: "adminPlugins.show.discourse-surveys-export",
        },
      ]);
    });
  },
};
