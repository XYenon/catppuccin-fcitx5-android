#!/use/bin/env ruby
# frozen_string_literal: true

require 'selenium-webdriver'
require 'webp-ffi'

options = Selenium::WebDriver::Options.firefox
options.args << '-headless'
driver = Selenium::WebDriver.for :firefox, options: options

driver.get('https://fcitx5-android.github.io/theme-designer/')

preview_div = driver.find_element(css: 'div[class="input-view"]')
driver.execute_script('arguments[0].style.zoom = "4";', preview_div)
border_checkbox = driver.find_element(css: 'input[id="border"][type="checkbox"]')
border_checkbox.click unless border_checkbox.selected?
import_input = driver.find_element(css: 'input[type="file"]')

temp_file = Tempfile.new(%w[preview .png])
ARGV.each do |theme_path|
  abs_path = File.expand_path(theme_path)
  dir, _ = File.split(abs_path)
  import_input.send_keys(abs_path)
  preview_div.save_screenshot(temp_file.path)
  preview_path = "#{abs_path.delete_suffix('.zip')}.webp"
  WebP.encode(temp_file.path, preview_path)
  File.open("#{dir}/README.md", 'w') do |readme|
    readme.puts <<~README
      ![preview](#{File.basename(preview_path)})
    README
  end
end
temp_file.close
temp_file.unlink

driver.quit
