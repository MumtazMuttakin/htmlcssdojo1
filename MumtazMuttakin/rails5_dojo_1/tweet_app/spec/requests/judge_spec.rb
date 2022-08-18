require 'rails_helper'

RSpec.describe '/posts/:id', type: :request do
  let(:post_params) { { content: 'content1' } }

  it '@@@Terjadi error ketika mengakses URL berikut ini: localhost:3000/posts/index@@@' do
    get '/posts/index'
    expect(response).to have_http_status(200)
  end

  it '@@@Route tidak tepat untuk URL-URL seperti: localhost:3000/posts/1@@@' do
    post = Post.create(post_params)
    expect { get "/posts/#{post.id}" }.not_to raise_error(ActionController::RoutingError)
  end

  it '@@@Terjadi error ketika mengakses halaman Detail Post@@@' do
    post = Post.create(post_params)
    get "/posts/#{post.id}"
    expect(response).to have_http_status(200)
  end

  it '@@@Isi dari halaman Detail Post tidak tepat@@@' do
    post = Post.create(post_params)
    get "/posts/#{post.id}"
    expect(response.body).to include(post.content)
  end

  it '@@@Waktu pada saat post terbentuk tidak ditampilkan dengan tepat dalam halaman Detail Post@@@' do
    post = Post.create(post_params)
    get "/posts/#{post.id}"
    expect(response.body).to include(post.created_at.to_s)
  end

  it '@@@Tautan menuju halaman Detail Post  dalam halaman pada「localhost:3000/posts/index」 tidak tepat@@@' do
    post = Post.create(post_params)
    get '/posts/index'
    expect(response.body).to match(%r{<a\s+href\s*=\s*"/posts/#{post.id}[?"]})
  end
end
