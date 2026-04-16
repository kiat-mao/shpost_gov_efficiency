class FakeMailsController < ApplicationController
  load_and_authorize_resource :fake_mail

  def index
  end
end