# frozen_string_literal: true

class Api::V1::Accounts::LookupController < Api::BaseController
  before_action -> { authorize_if_got_token! :read, :'read:accounts' }
  before_action :set_account

  def show
    cache_if_unauthenticated!
    if @account
      render json: @account, serializer: REST::AccountSerializer
    else
      render json: {email: 'OK'}
    end
  end

  # verismile
  def send_reset_password_instructions
    user = User.find_by(email: params[:email])
    if user
      user.send_reset_password_instructions
      render json: {message: 'ok'}
    else
      render json: {error: 'user not found'}
    end
  end

  private

  def set_account
    if params[:acct]
      @account = ResolveAccountService.new.call(params[:acct], skip_webfinger: true) || raise(ActiveRecord::RecordNotFound)
    else
      sleep 1 # evitar flooding
      User.find_by(email: params[:email]) || raise(ActiveRecord::RecordNotFound) # procurar se existe email cadastrado
    end
  rescue Addressable::URI::InvalidURIError
    raise(ActiveRecord::RecordNotFound)
  end
end