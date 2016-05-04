require 'spec_helper'

module Filterable
  describe 'Joined Models' do
    before :all do
      schema_helper = SchemaHelper.new
      schema_helper.connect_to('sqlite3', ':memory:')
      schema_helper.generate_model('user', { name: 'string', email: 'text' })
      schema_helper.generate_model('post', { title: 'string', body: 'text', user_id: 'integer' })
      schema_helper.generate_model('comment', { body: 'text', author_id: 'integer' })
      User.has_many :posts
      User.filter_by :name, :email
      User.filter_by :posts_title, joins: :posts

      Post.belongs_to :user
      Post.filter_by :title, :user_id

      Comment.belongs_to :post
      Comment.filter_by :author_id
      Comment.filter_by :post_user_name, joins: { post: :user }
    end

    it 'queries by joined model fields' do
      query = User.filter(by_posts_title: 'test').to_sql

      expect(/JOIN "posts"/.match(query)).not_to be_nil
      expect(/"posts"."title" = 'test'/.match(query)).not_to be_nil
    end

    it 'queries by attribute on belogns to side' do
      query = Post.filter(by_user_id: 1).to_sql

      expect(/"posts"."user_id" = 1/.match(query)).not_to be_nil
    end

    it 'queries by nested joined model fields' do
      query = Comment.filter(by_post_user_name: 'test').to_sql

      expect(/JOIN "posts"/.match(query)).not_to be_nil
      expect(/JOIN "users"/.match(query)).not_to be_nil
      expect(/"users"."name" = 'test'/.match(query)).not_to be_nil
    end
  end
end
