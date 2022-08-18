require 'rails_helper'

RSpec.describe '/posts/:id/destroy', type: :request do
  let(:content_string) { 'test_content' }
  let(:post_instance) { Post.create(content: content_string) }

  it '@@@Terjadi error ketika mengakses halaman Post Detail@@@' do
    get "/posts/#{post_instance.id}"
    expect(response).to have_http_status(200)
  end

  it '@@@Pada halaman Post Detail, tautan untuk menghapus post tidak ditemukan atau tidak tepat@@@' do
    get "/posts/#{post_instance.id}"
    expect(response.body).to include('Hapus')
  end

  it '@@@Pada halaman Post Detail, URL untuk tautan hapus tidak diatur dengan benar@@@' do
    get "/posts/#{post_instance.id}"
    expect(response.body).to match(%r{<a.*?href\s*=\s*"/posts/#{post_instance.id}/destroy[?"]})
  end

  it '@@@Pada halaman Post Detail, method untuk tautan hapus seharusnya tidak diatur sebagai `post`@@@' do
    get "/posts/#{post_instance.id}"
    expect(response.body).to match(%r{<a.*?method\s*=\s*"post".*?href\s*=\s*"/posts/#{post_instance.id}/destroy[?"]})
  end

  it '@@@Tidak ditemukan route untuk pola URL berikut ini: localhost:3000/posts/1/destroy@@@' do
    expect { post "/posts/#{post_instance.id}/destroy" }.not_to raise_error(ActionController::RoutingError)
  end

  it '@@@Terjadi error ketika mencoba menghapus post. Silahkan periksa tab Preview@@@' do
    expect { post "/posts/#{post_instance.id}/destroy" }.not_to raise_error
  end

  it '@@@Tidak berhasil menghapus data post@@@' do
    post_instance
    expect { post "/posts/#{post_instance.id}/destroy" }.to change(Post, :count).by(-1)
  end

  it '@@@Setelah post berhasil dihapus, halaman Post(index) seharusnya ditampilkan@@@' do
    post "/posts/#{post_instance.id}/destroy"
    expect(response).to redirect_to(%r{/posts/index[?"]})
  end

  it '@@@Pesan flash yang ditampilkan setelah berhasil menghapus post itu tidak tepat@@@' do
    post "/posts/#{post_instance.id}/destroy"
    expect(flash[:notice]).to be_present
  end

  it '@@@Pesan flash yang ditampilkan setelah berhasil menghapus post itu tidak tepat@@@' do
    post "/posts/#{post_instance.id}/destroy"
    expect(flash[:notice]).to eq('Post berhasil dihapus')
  end

  it '@@@Pesan flash seharusnya ditampilkan pada halaman Post (index) setelah post berhasil dihapus@@@' do
    allow_any_instance_of(ApplicationController).to receive(:flash).and_return(notice: 'Post berhasil dihapus')
    get '/posts/index'
    expect(response.body).to include('Post berhasil dihapus')
  end
end
