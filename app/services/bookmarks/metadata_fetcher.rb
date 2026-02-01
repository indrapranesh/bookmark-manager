module Bookmarks
  class MetadataFetcher
    TIMEOUT = 10
    MAX_REDIRECTS = 5

    def self.call(bookmark)
      new(bookmark).call
    end

    def initialize(bookmark)
      @bookmark = bookmark
    end

    def call
      response = fetch_url
      return mark_as_failed("Failed to fetch URL") unless response&.success?

      html = Nokogiri::HTML(response.body)

      @bookmark.update!(
        title: extract_title(html),
        description: extract_description(html),
        thumbnail_url: extract_image(html),
        metadata_status: 'fetched'
      )
    rescue StandardError => e
      mark_as_failed(e.message)
    end

    private

    def fetch_url
      HTTParty.get(
        @bookmark.url,
        timeout: TIMEOUT,
        follow_redirects: true,
        max_redirects: MAX_REDIRECTS,
        headers: { 'User-Agent' => 'Mozilla/5.0 (BookmarkManager/1.0)' }
      )
    rescue HTTParty::Error, Net::OpenTimeout, SocketError => e
      Rails.logger.error("Failed to fetch #{@bookmark.url}: #{e.message}")
      nil
    end

    def extract_title(html)
      html.at_css('meta[property="og:title"]')&.[]('content') ||
        html.at_css('meta[name="twitter:title"]')&.[]('content') ||
        html.at_css('title')&.text ||
        'Untitled'
    end

    def extract_description(html)
      html.at_css('meta[property="og:description"]')&.[]('content') ||
        html.at_css('meta[name="description"]')&.[]('content') ||
        html.at_css('meta[name="twitter:description"]')&.[]('content')
    end

    def extract_image(html)
      og_image = html.at_css('meta[property="og:image"]')&.[]('content')
      twitter_image = html.at_css('meta[name="twitter:image"]')&.[]('content')

      og_image || twitter_image
    end

    def mark_as_failed(error_message)
      @bookmark.update!(
        metadata_status: 'failed',
        metadata_error: error_message
      )
    end
  end
end
