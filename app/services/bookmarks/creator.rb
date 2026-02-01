module Bookmarks
  class Creator
    Result = Struct.new(:success?, :bookmark, :errors, keyword_init: true)

    def self.call(user:, url:)
      new(user: user, url: url).call
    end

    def initialize(user:, url:)
      @user = user
      @url = url
    end

    def call
      bookmark = @user.bookmarks.new(url: @url)

      if bookmark.save
        FetchMetadataJob.perform_async(bookmark.id)
        success(bookmark)
      else
        failure(bookmark.errors.full_messages)
      end
    end

    private

    def success(bookmark)
      Result.new(success?: true, bookmark: bookmark, errors: [])
    end

    def failure(errors)
      Result.new(success?: false, bookmark: nil, errors: Array(errors))
    end
  end
end
