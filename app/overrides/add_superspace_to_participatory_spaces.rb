# frozen_string_literal: true

Deface::Override.new(virtual_path: "decidim/assemblies/assemblies/show",
                     name: "add_superspace_to_assemblies",
                     insert_before: "erb[loud]:contains('participatory_space_floating_help')",
                     text: <<-ERB
                            <% if current_participatory_space.superspace.present? %>
                                <section class="participatory-space__block-reference">
                                    <% superspace_link = link_to(
                                        translated_attribute(current_participatory_space.superspace.title),
                                        decidim_superspaces.superspace_path(current_participatory_space.superspace),
                                        class: "text-secondary underline"
                                    ) %>
                                    <%= t("part_of", superspace: superspace_link, scope:"decidim.superspaces.participatory_spaces.show").html_safe %>
                                </section>
                            <% end %>
                     ERB
                    )
Deface::Override.new(virtual_path: "decidim/participatory_processes/participatory_processes/show",
                     name: "add_superspace_to_participatory_process",
                     insert_before: "erb[loud]:contains('participatory_space_floating_help')",
                     text: <<-ERB
                            <% if current_participatory_space.superspace.present? %>
                                <section class="participatory-space__block-reference">
                                    <% superspace_link = link_to(
                                        translated_attribute(current_participatory_space.superspace.title),
                                        decidim_superspaces.superspace_path(current_participatory_space.superspace),
                                        class: "text-secondary underline"
                                    ) %>
                                    <%= t("part_of", superspace: superspace_link, scope:"decidim.superspaces.participatory_spaces.show").html_safe %>
                                </section>
                            <% end %>
                     ERB
                    )
Deface::Override.new(virtual_path: "decidim/conferences/conferences/show",
                     name: "add_superspace_to_conferences",
                     insert_before: "erb[loud]:contains('participatory_space_floating_help')",
                     text: <<-ERB
                            <% if current_participatory_space.superspace.present? %>
                                <section class="participatory-space__block-reference">
                                    <% superspace_link = link_to(
                                        translated_attribute(current_participatory_space.superspace.title),
                                        decidim_superspaces.superspace_path(current_participatory_space.superspace),
                                        class: "text-secondary underline"
                                    ) %>
                                    <%= t("part_of", superspace: superspace_link, scope:"decidim.superspaces.participatory_spaces.show").html_safe %>
                                </section>
                            <% end %>
                     ERB
                    )
