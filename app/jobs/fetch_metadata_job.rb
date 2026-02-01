class FetchMetadataJob
  include Sidekiq::Job

  def perform(bookmark_id)
    bookmark = Bookmark.find_by(id: bookmark_id)
    return unless bookmark

    Bookmarks::MetadataFetcher.call(bookmark)
  end
end
