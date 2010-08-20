module Smusher
  class PunyPng
    DEFAULT_API_KEY = '97b8b70fc59768979e2a0bdaf19df4dfa5536ed4'

    @@api_key = nil
    def self.api_key=(x); @@api_key = x; end
    def self.api_key
      @@api_key ||= (personal_key || DEFAULT_API_KEY)
    end

    def self.converts_gif_to_png?
      false
    end

    def self.optimized_image_data_for(file)
      url = 'http://www.punypng.com/api/optimize'
      response = HTTPClient.post url, { 'img' => File.new(file), 'key' => api_key}
      response = JSON.parse(response.body.content)
      raise "puny_png: #{response['error']}" if response['error']
      image_url = response['optimized_url']
      raise "no optimized_url found" unless image_url
      open(image_url) { |source| source.read() }
    end

    private

    def self.personal_key
      key = `cat ~/.puny_png_api_key`.strip
      key.empty? ? nil : key
    end
  end
end