# frozen_string_literal: true

require "decidim/superspaces/admin"
require "decidim/superspaces/engine"
require "decidim/superspaces/admin_engine"

Decidim.register_global_engine(:decidim_superspaces, Decidim::Superspaces::Engine, at: "/superspaces")
