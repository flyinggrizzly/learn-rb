# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161027152727) do

  create_table "announcements", force: true do |t|
    t.string   "subtype"
    t.text     "body_content"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.string   "featured_image_caption"
    t.string   "object_title"
    t.text     "object_embed_code"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "call_to_action_label"
    t.string   "call_to_action_content"
    t.integer  "last_published_version", limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "call_to_action_type"
    t.string   "call_to_action_reason"
  end

  create_table "associated_orgs_content_items", id: false, force: true do |t|
    t.integer "organisation_id", limit: nil, precision: 38
    t.integer "content_item_id", limit: nil, precision: 38
  end

  add_index "associated_orgs_content_items", ["content_item_id"], name: "i_ass_org_con_ite_con_ite_id"
  add_index "associated_orgs_content_items", ["organisation_id"], name: "i_ass_org_con_ite_org_id"

  create_table "associated_orgs_groups", id: false, force: true do |t|
    t.integer "organisation_id", limit: nil, precision: 38
    t.integer "group_id",        limit: nil, precision: 38
  end

  add_index "associated_orgs_groups", ["group_id"], name: "i_ass_org_gro_gro_id"
  add_index "associated_orgs_groups", ["organisation_id"], name: "i_ass_org_gro_org_id"

  create_table "associated_orgs_users", id: false, force: true do |t|
    t.integer "organisation_id", limit: nil, precision: 38
    t.integer "user_id",         limit: nil, precision: 38
  end

  add_index "associated_orgs_users", ["organisation_id"], name: "i_ass_org_use_org_id"
  add_index "associated_orgs_users", ["user_id"], name: "i_ass_org_use_use_id"

  create_table "benefits", force: true do |t|
    t.text     "description"
    t.string   "call_to_action_label"
    t.string   "call_to_action_content"
    t.string   "image"
    t.string   "image_alt"
    t.string   "image_caption"
    t.string   "object_title"
    t.text     "object_embed_code"
    t.integer  "campaign_id",            limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "call_to_action_type"
    t.string   "call_to_action_reason"
  end

  add_index "benefits", ["campaign_id"], name: "index_benefits_on_campaign_id"

  create_table "campaigns", force: true do |t|
    t.string   "subtype"
    t.string   "status"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.datetime "start"
    t.datetime "end"
    t.text     "supporting_information"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "last_published_version", limit: nil, precision: 38
    t.string   "featured_image_caption"
  end

  create_table "case_studies", force: true do |t|
    t.string   "subtype"
    t.text     "body_content"
    t.string   "quote"
    t.string   "quote_attribution"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.string   "featured_image_caption"
    t.string   "object_title"
    t.text     "object_embed_code"
    t.string   "call_to_action_label"
    t.string   "call_to_action_content"
    t.integer  "last_published_version", limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "call_to_action_type"
    t.string   "call_to_action_reason"
  end

  create_table "collection_sections", force: true do |t|
    t.string   "title"
    t.text     "summary"
    t.integer  "collection_id", limit: nil, precision: 38
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "collection_sections", ["collection_id"], name: "i_col_sec_col_id"

  create_table "collections", force: true do |t|
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "last_published_version", limit: nil, precision: 38
  end

  create_table "content_items", force: true do |t|
    t.string   "as_a"
    t.string   "i_need"
    t.string   "so_that"
    t.string   "title"
    t.string   "summary"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "status",              limit: nil, precision: 38, default: 0
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "core_data_id",        limit: nil, precision: 38
    t.string   "core_data_type"
    t.integer  "organisation_id",     limit: nil, precision: 38
    t.string   "url_path"
    t.text     "published_item_json"
  end

  add_context_index "content_items", ["title"], name: "i_content_items_title"
  add_index "content_items", ["core_data_id"], name: "i_content_items_core_data_id"
  add_index "content_items", ["core_data_type", "core_data_id"], name: "iec95716aea10896b09410ce9969d2"
  add_index "content_items", ["organisation_id"], name: "i_con_ite_org_id"

  create_table "content_items_labels", id: false, force: true do |t|
    t.integer "content_item_id", limit: nil, precision: 38, null: false
    t.integer "label_id",        limit: nil, precision: 38, null: false
  end

  add_index "content_items_labels", ["content_item_id", "label_id"], name: "i29cadf0cf259b2d6da647663b98a7"
  add_index "content_items_labels", ["label_id", "content_item_id"], name: "i708e8429ca36acaba8941a03f80a5"

  create_table "corporate_informations", force: true do |t|
    t.string   "subtype"
    t.text     "body_content"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.string   "featured_image_caption"
    t.string   "object_title"
    t.text     "object_embed_code"
    t.string   "call_to_action_label"
    t.string   "call_to_action_content"
    t.integer  "last_published_version", limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "call_to_action_type"
    t.string   "call_to_action_reason"
  end

  create_table "events", force: true do |t|
    t.string   "subtype"
    t.datetime "start"
    t.datetime "end"
    t.string   "building"
    t.string   "town"
    t.string   "postcode"
    t.string   "country"
    t.text     "accessibility"
    t.string   "audience"
    t.string   "audience_detail"
    t.text     "description"
    t.text     "speaker_profile"
    t.string   "booking_method"
    t.string   "booking_email"
    t.string   "booking_link"
    t.boolean  "charge"
    t.string   "featured_image"
    t.string   "featured_image_caption"
    t.string   "featured_image_alt"
    t.string   "hashtag"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "location"
    t.string   "venue"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "room_number"
    t.decimal  "price",                              precision: 7,  scale: 2
    t.integer  "last_published_version", limit: nil, precision: 38
  end

  create_table "external_items", force: true do |t|
    t.string   "subtype"
    t.string   "external_url"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.string   "featured_image_caption"
    t.integer  "last_published_version", limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "guides", force: true do |t|
    t.string   "subtype"
    t.string   "call_to_action_label"
    t.string   "call_to_action_content"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.string   "featured_image_caption"
    t.string   "object_title"
    t.text     "object_embed_code"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "last_published_version", limit: nil, precision: 38
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "call_to_action_type"
    t.string   "call_to_action_reason"
  end

  create_table "guides_service_starts", id: false, force: true do |t|
    t.integer "guide_id",         limit: nil, precision: 38, null: false
    t.integer "service_start_id", limit: nil, precision: 38, null: false
  end

  add_index "guides_service_starts", ["guide_id", "service_start_id"], name: "idec8ca59ca87feb71cd155ed97889"
  add_index "guides_service_starts", ["service_start_id", "guide_id"], name: "i69c4b3f7e91dfb031e0ff6b31c62b"

  create_table "highlighted_items", force: true do |t|
    t.string   "item"
    t.string   "item_type"
    t.integer  "item_order",                   limit: nil, precision: 38
    t.integer  "olp_announcement_id",          limit: nil, precision: 38
    t.integer  "olp_campaign_id",              limit: nil, precision: 38
    t.integer  "olp_case_study_id",            limit: nil, precision: 38
    t.integer  "olp_corporate_information_id", limit: nil, precision: 38
    t.integer  "olp_event_id",                 limit: nil, precision: 38
    t.integer  "olp_guide_id",                 limit: nil, precision: 38
    t.integer  "olp_location_id",              limit: nil, precision: 38
    t.integer  "olp_person_profile_id",        limit: nil, precision: 38
    t.integer  "olp_project_id",               limit: nil, precision: 38
    t.integer  "olp_publication_id",           limit: nil, precision: 38
    t.integer  "olp_service_start_id",         limit: nil, precision: 38
    t.integer  "olp_team_profile_id",          limit: nil, precision: 38
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  create_table "labels", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "locations", force: true do |t|
    t.string   "subtype"
    t.string   "on_off_campus"
    t.string   "building"
    t.string   "room"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "town"
    t.string   "postcode"
    t.string   "country"
    t.string   "longitude"
    t.string   "latitude"
    t.text     "accessibility"
    t.text     "additional_information"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.string   "featured_image_caption"
    t.text     "map_embed_code"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "opening_time_monday"
    t.string   "opening_time_tuesday"
    t.string   "opening_time_wednesday"
    t.string   "opening_time_thursday"
    t.string   "opening_time_friday"
    t.string   "opening_time_saturday"
    t.string   "opening_time_sunday"
    t.text     "opening_time_notes"
    t.integer  "last_published_version", limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "organisation_landing_pages", force: true do |t|
    t.text     "about"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "on_off_campus"
    t.string   "building"
    t.string   "room"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "town"
    t.string   "postcode"
    t.string   "country"
    t.string   "featured_item_1"
    t.string   "featured_item_2"
    t.string   "featured_item_3"
    t.string   "featured_item_4"
    t.string   "featured_item_5"
    t.string   "featured_item_6"
    t.integer  "last_published_version", limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "subtype"
    t.string   "content_list"
  end

  create_table "organisations", force: true do |t|
    t.string   "name"
    t.string   "contact_information"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "parent_organisation_id", limit: nil, precision: 38
    t.string   "type"
  end

  add_index "organisations", ["name"], name: "index_organisations_on_name", unique: true

  create_table "organisations_users", id: false, force: true do |t|
    t.integer "group_id", limit: nil, precision: 38
    t.integer "user_id",  limit: nil, precision: 38
  end

  add_index "organisations_users", ["group_id"], name: "i_organisations_users_group_id"
  add_index "organisations_users", ["user_id"], name: "i_organisations_users_user_id"

  create_table "partners", force: true do |t|
    t.string   "name"
    t.string   "logo_url"
    t.string   "logo_alt"
    t.string   "link_url"
    t.string   "link_text"
    t.integer  "project_id",  limit: nil, precision: 38
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "campaign_id", limit: nil, precision: 38
  end

  add_index "partners", ["campaign_id"], name: "index_partners_on_campaign_id"
  add_index "partners", ["project_id"], name: "index_partners_on_project_id"

  create_table "person_profiles", force: true do |t|
    t.string   "role_holder_name"
    t.string   "honours_post_nominal_letters"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "role_holder_photo_url"
    t.string   "role_holder_photo_alt_text"
    t.string   "role_holder_photo_caption"
    t.text     "achievements_in_role"
    t.text     "career_achievements"
    t.text     "education"
    t.string   "all_publications_url"
    t.integer  "supervisor_availability",      limit: nil, precision: 38
    t.text     "research_interests"
    t.text     "current_research_projects"
    t.string   "person_finder_link"
    t.string   "subtype"
    t.text     "role_related_posts_held"
    t.text     "courses_taught_undergrad"
    t.text     "courses_taught_postgrad"
    t.integer  "last_published_version",       limit: nil, precision: 38
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "role_holder_title"
  end

  create_table "phases", force: true do |t|
    t.string   "title"
    t.text     "summary"
    t.datetime "start"
    t.datetime "end"
    t.string   "budget"
    t.integer  "project_id", limit: nil, precision: 38
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "phases", ["project_id"], name: "index_phases_on_project_id"

  create_table "projects", force: true do |t|
    t.string   "subtype"
    t.string   "status"
    t.text     "project_overview"
    t.string   "budget"
    t.datetime "start"
    t.datetime "end"
    t.string   "featured_image"
    t.string   "featured_image_alt"
    t.string   "featured_image_caption"
    t.string   "object_title"
    t.text     "object_embed_code"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "last_published_version", limit: nil, precision: 38
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
  end

  create_table "publication_attachments", force: true do |t|
    t.string   "title"
    t.string   "attachment_filename"
    t.integer  "publication_id",      limit: nil, precision: 38
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "publication_attachments", ["publication_id"], name: "i_pub_att_pub_id"

  create_table "publications", force: true do |t|
    t.string   "subtype"
    t.integer  "last_published_version", limit: nil, precision: 38
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.text     "additional_info"
    t.string   "attachment_filename"
    t.boolean  "restricted"
  end

  create_table "section_items", force: true do |t|
    t.integer  "item_order",            limit: nil, precision: 38
    t.integer  "collection_section_id", limit: nil, precision: 38
    t.integer  "content_item_id",       limit: nil, precision: 38
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "section_items", ["collection_section_id"], name: "i_sec_ite_col_sec_id"
  add_index "section_items", ["content_item_id"], name: "i_sec_ite_con_ite_id"

  create_table "sections", force: true do |t|
    t.string   "title"
    t.text     "body_content"
    t.integer  "guide_id",     limit: nil, precision: 38
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "sections", ["guide_id"], name: "index_sections_on_guide_id"

  create_table "service_starts", force: true do |t|
    t.text     "usage_instructions"
    t.string   "call_to_action_label"
    t.string   "call_to_action_content"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "last_published_version", limit: nil, precision: 38
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "call_to_action_type"
    t.string   "call_to_action_reason"
  end

  create_table "subsets", force: true do |t|
    t.string   "title"
    t.text     "membership"
    t.integer  "team_profile_id", limit: nil, precision: 38
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "subsets", ["team_profile_id"], name: "i_subsets_team_profile_id"

  create_table "team_memberships", force: true do |t|
    t.integer "team_profile_id",   limit: nil, precision: 38, null: false
    t.integer "person_profile_id", limit: nil, precision: 38, null: false
    t.integer "member_order",      limit: nil, precision: 38
  end

  add_index "team_memberships", ["person_profile_id"], name: "i_tea_mem_per_pro_id"
  add_index "team_memberships", ["team_profile_id"], name: "i_tea_mem_tea_pro_id"

  create_table "team_profiles", force: true do |t|
    t.text     "duties"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "members_with_no_profile"
    t.integer  "last_published_version",  limit: nil, precision: 38
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "membership_type"
    t.string   "subtype"
  end

  create_table "urls", force: true do |t|
    t.string   "url"
    t.integer  "person_profile_id", limit: nil, precision: 38
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "urls", ["person_profile_id"], name: "i_urls_person_profile_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "display_name"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "person_id",       limit: nil, precision: 38
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "organisation_id", limit: nil, precision: 38
    t.boolean  "admin",                                      default: false
    t.boolean  "editor",                                     default: false
    t.boolean  "author",                                     default: false
    t.boolean  "contributor",                                default: false
  end

  add_index "users", ["organisation_id"], name: "index_users_on_organisation_id"
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "version_associations", force: true do |t|
    t.integer "version_id",       limit: nil, precision: 38
    t.string  "foreign_key_name",                            null: false
    t.integer "foreign_key_id",   limit: nil, precision: 38
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations"
  add_index "version_associations", ["version_id"], name: "i_ver_ass_ver_id"

  create_table "versions", force: true do |t|
    t.string   "item_type",                                 null: false
    t.integer  "item_id",        limit: nil, precision: 38, null: false
    t.string   "event",                                     null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.integer  "transaction_id", limit: nil, precision: 38
  end

  add_index "versions", ["item_type", "item_id"], name: "i_versions_item_type_item_id"
  add_index "versions", ["transaction_id"], name: "i_versions_transaction_id"

  add_foreign_key "benefits", "campaigns", name: "benefits_campaign_id_fk"

  add_foreign_key "collection_sections", "collections", name: "col_sec_col_id_fk"

  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_announcement_id", name: "hig_ite_olp_ann_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_campaign_id", name: "hig_ite_olp_cam_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_case_study_id", name: "hig_ite_olp_cas_stu_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_corporate_information_id", name: "hig_ite_olp_cor_inf_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_event_id", name: "hig_ite_olp_eve_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_guide_id", name: "hig_ite_olp_gui_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_location_id", name: "hig_ite_olp_loc_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_person_profile_id", name: "hig_ite_olp_per_pro_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_project_id", name: "hig_ite_olp_pro_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_publication_id", name: "hig_ite_olp_pub_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_service_start_id", name: "hig_ite_olp_ser_sta_id_fk"
  add_foreign_key "highlighted_items", "organisation_landing_pages", column: "olp_team_profile_id", name: "hig_ite_olp_tea_pro_id_fk"

  add_foreign_key "partners", "projects", name: "partners_project_id_fk"

  add_foreign_key "phases", "projects", name: "phases_project_id_fk"

  add_foreign_key "publication_attachments", "publications", name: "pub_att_pub_id_fk"

  add_foreign_key "section_items", "collection_sections", name: "sec_ite_col_sec_id_fk"
  add_foreign_key "section_items", "content_items", name: "sec_ite_con_ite_id_fk"

  add_foreign_key "sections", "guides", name: "sections_guide_id_fk"

  add_foreign_key "subsets", "team_profiles", name: "subsets_team_profile_id_fk"

  add_foreign_key "team_memberships", "person_profiles", name: "tea_mem_per_pro_id_fk"
  add_foreign_key "team_memberships", "team_profiles", name: "tea_mem_tea_pro_id_fk"

  add_foreign_key "urls", "person_profiles", name: "urls_person_profile_id_fk"

end
