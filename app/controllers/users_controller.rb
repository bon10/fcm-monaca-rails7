class UsersController < ApplicationController
    before_action :set_user, only: [:show]
    skip_before_action :verify_authenticity_token, only: [:token]
  
    def index
      @users = User.all
    end
  
    def show
    end
  
    # FIXME: 実際はカスタムヘッダや暗号化を使って秘匿性を上げたほうが良い&エラー処理
    def token
      json_hash  = params
      Rails.logger.info "JSON-----------------"
      Rails.logger.info json_hash
  
      User.regsiter_and_update_token(json_hash)
  
      render status: 200, json: {}
    end
    
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
        return
      end
  
      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:name, :uid, :token)
      end
  end