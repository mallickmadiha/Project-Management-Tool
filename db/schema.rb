# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

# rubocop: disable all
ActiveRecord::Schema.define(version: 20_230_715_103_900) do
  create_table 'action_cable_channels', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'channel', null: false
    t.string 'broadcasting', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'action_cable_events', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'channel', null: false
    t.string 'event', null: false
    t.text 'data'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'active_storage_attachments', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'chats', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'sender_id', null: false
    t.text 'message', null: false
    t.text 'mentioned_user_ids'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'detail_id'
    t.index ['detail_id'], name: 'fk_rails_3483a88122'
    t.index ['sender_id'], name: 'index_chats_on_sender_id'
  end

  create_table 'details', charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'project_id', null: false
    t.string 'title', limit: 30, null: false
    t.text 'description', null: false
    t.string 'file'
    t.integer 'status', default: 0
    t.integer 'flagType', default: 0
    t.string 'uuid'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['project_id'], name: 'index_details_on_project_id'
  end

  create_table 'details_users', id: false, charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'detail_id'
    t.bigint 'user_id'
    t.index ['detail_id'], name: 'index_details_users_on_detail_id'
    t.index ['user_id'], name: 'index_details_users_on_user_id'
  end

  create_table 'notifications', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'message', null: false
    t.bigint 'user_id', null: false
    t.boolean 'read', default: false
    t.index ['user_id'], name: 'index_notifications_on_user_id'
  end

  create_table 'projects', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'name', limit: 30, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'user_id', null: false
    t.index ['user_id'], name: 'index_projects_on_user_id'
  end

  create_table 'projects_users', id: false, charset: 'utf8mb3', force: :cascade do |t|
    t.bigint 'project_id'
    t.bigint 'user_id'
    t.index ['project_id'], name: 'index_projects_users_on_project_id'
    t.index ['user_id'], name: 'index_projects_users_on_user_id'
  end

  create_table 'tasks', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'status', default: 0
    t.bigint 'detail_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['detail_id'], name: 'index_tasks_on_detail_id'
  end

  create_table 'users', charset: 'utf8mb3', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'uid'
    t.string 'provider'
    t.string 'username', null: false
    t.datetime 'expires_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'chats', 'details'
  add_foreign_key 'chats', 'users', column: 'sender_id'
  add_foreign_key 'details', 'projects'
  add_foreign_key 'notifications', 'users'
  add_foreign_key 'projects', 'users'
  add_foreign_key 'tasks', 'details'
end
