class DiscardController < ApplicationController
  def index
    if defined? session[:content_item_status]
      status = session[:content_item_status]
      redirect_to root_path,
                  flash: { message: I18n.t("action_messages.#{status}_discard"), class: status }
      session[:content_item_status] = nil
    end
  end
end
