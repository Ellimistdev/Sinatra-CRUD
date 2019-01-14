require_relative '../spec_helper'

describe ApplicationController do
  it 'redirects to movie index' do
    visit '/'
    expect(page.status_code).to eq(200)
    expect(page.current_path).to eq('/movies')
  end
end
