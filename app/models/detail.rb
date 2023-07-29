# frozen_string_literal: true

# app/models/detail.rb
class Detail < ApplicationRecord
  enum status: %i[Started Finished Delivered]
  enum flagType: %i[backFlag icebox currentIteration]

  belongs_to :project
  has_and_belongs_to_many :users
  has_many :tasks, dependent: :destroy
  has_many :chats, dependent: :destroy

  has_many_attached :file

  validates :title, presence: { message: "Title can't be blank" },
                    length: { maximum: 30, message: 'Title is too long (maximum is 30 characters)' }
  validates :description, presence: { message: "Description can't be blank" }

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'true' do
      indexes :id, type: :keyword
      indexes :project_id, type: :text
      indexes :title, type: :text
      indexes :description, type: :text
      indexes :status, type: :text
      indexes :flagType, type: :text
      indexes :uuid, type: :text
    end
  end

  # rubocop:disable Style/HashSyntax
  def as_indexed_json(_options = {})
    {
      id: id,
      project_id: project_id,
      title: title,
      description: description,
      status: status,
      flagType: flagType,
      uuid: uuid
    }
  end
  # rubocop:enable Style/HashSyntax

  # rubocop:disable Metrics/MethodLength
  def self.search_items(query)
    search_definition = {
      query: {
        bool: {
          must: []
        }
      }
    }

    if query.present?
      search_definition[:query][:bool][:must] << {
        query_string: {
          query: "*#{query}*"
        }
      }
    end

    search_definition
  end

  # rubocop:enable Metrics/MethodLength
  index_data
end
