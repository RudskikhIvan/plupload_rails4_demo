require "rails_helper"

describe "Contents", :type => :feature do

  describe "Contents list" do

    before do
      FactoryGirl.create(:content, :title => 'First File', :tags => 'rails ruby')
      FactoryGirl.create(:content, :title => 'Second File', :tags => 'ruby coffescript')
      FactoryGirl.create(:content, :title => 'Thrid File', :tags => 'rails coffescript')
    end

    it 'show index page' do
      visit '/'
      expect(page).to have_content('Plupload Rails4 Demo')
      expect(page).to have_content('First File')
      expect(page).to have_content('Second File')
      expect(page).to have_content('Thrid File')
      expect(page).to have_content('Загрузить')
    end

    it 'show contents by tag' do
      visit '/'
      expect(page).to have_content('Plupload Rails4 Demo')
      find('tbody tr:first-child').click_link('rails')
      expect(page).to have_content('First File')
      expect(page).to_not have_content('Second File')
      expect(page).to have_content('Thrid File')
      click_link('coffescript')
      expect(page).to_not have_content('First File')
      expect(page).to have_content('Second File')
      expect(page).to have_content('Thrid File')
    end

    it 'show content details' do
      visit '/'
      expect(page).to have_content('Plupload Rails4 Demo')
      click_link('First File')
      expect(page).to have_content('First File')
      expect(page).to have_content('rails ruby')
      expect(page).to have_content('112 KB')
      expect(page).to have_content('image/jpeg')
      click_link('Назад')
      click_link('Second File')
      expect(page).to have_content('Second File')
      expect(page).to have_content('ruby coffescript')
      expect(page).to have_content('112 KB')
      expect(page).to have_content('image/jpeg')
    end

    it 'remove content' do
      visit '/'
      expect(page).to have_content('Plupload Rails4 Demo')
      expect(Content.count).to be 3
      find('tbody tr:first-child').click_link('Удалить')
      expect(page).to have_content('Файл Thrid File был удалён')
      expect(Content.count).to be 2
    end

  end

  describe 'Form' do

    it 'load file', js: true do
      visit '/'
      expect(Content.count).to be 0
      find('.nav').click_link('Загрузить файл')
      sleep 1
      page.execute_script("$('#content_title').val('New File').blur()")
      page.execute_script("$('#content_tags').val('ruby rails')")
      page.execute_script("$('[type=\"file\"]').css('opacity', 1)")
      find("[type='file']").set(Rails.root.join('spec/fixtures/image.jpeg'))
      find('#submit').click
      sleep 1
      expect(Content.count).to be 1
    end

  end

end