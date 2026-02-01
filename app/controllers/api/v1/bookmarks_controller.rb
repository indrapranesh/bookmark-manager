module Api
  module V1
    class BookmarksController < BaseController
      def index
        bookmarks = current_user.bookmarks.recent
        render json: bookmarks
      end

      def show
        bookmark = current_user.bookmarks.find(params[:id])
        render json: bookmark
      end

      def create
        result = Bookmarks::Creator.call(
          user: current_user,
          url: bookmark_params[:url]
        )

        if result.success?
          render json: result.bookmark, status: :created
        else
          render_validation_errors(result.errors)
        end
      end

      def destroy
        bookmark = current_user.bookmarks.find(params[:id])
        bookmark.destroy
        head :no_content
      end

      private

      def bookmark_params
        params.require(:bookmark).permit(:url)
      end
    end
  end
end
