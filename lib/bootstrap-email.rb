require 'nokogiri'
require 'erb'
require 'ostruct'
require 'action_mailer'
require 'premailer'
require 'rails'

module BootstrapEmail

  class << self
    def compile_html! mail
      @doc = Nokogiri::HTML(mail.body.raw_source)

      button
      badge
      alert
      align
      card
      hr
      container
      grid
      padding
      margin
      table

      mail.body = @doc.to_html
      mail
    end

    def build_from_template template, locals_hash = {}
      namespace = OpenStruct.new(locals_hash)
      template = File.open(File.expand_path("../core/templates/#{template}.html.erb", __dir__)).read
      Nokogiri::HTML::DocumentFragment.parse(ERB.new(template).result(namespace.instance_eval { binding }))
    end

    def button
      @doc.css('.btn').each do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table-left', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def badge
      @doc.css('.badge').each do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table-left', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def alert
      @doc.css('.alert').each do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def align
      @doc.css('.align-left').each do |node| # align table and move contents
        node['class'] = node['class'].sub(/align-left/, '')
        node.replace(build_from_template('align-left', {contents: node.to_html}))
      end
      @doc.css('.align-center').each do |node| # align table and move contents
        node['class'] = node['class'].sub(/align-center/, '')
        node.replace(build_from_template('align-center', {contents: node.to_html}))
      end
      @doc.css('.align-right').each do |node| # align table and move contents
        node['class'] = node['class'].sub(/align-right/, '')
        node.replace(build_from_template('align-right', {contents: node.to_html}))
      end
    end

    def card
      @doc.css('.card').each do |node| # move all classes up and remove all classes from element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
      @doc.css('.card-body').each do |node| # move all classes up and remove all classes from element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def hr
      @doc.css('hr').each do |node| # drop hr in place of current
        node.replace(build_from_template('hr', {classes: "hr #{node['class']}"}))
      end
    end

    def container
      @doc.css('.container').each do |node|
        node.replace(build_from_template('container', {classes: node['class'], contents: node.inner_html}))
      end
      @doc.css('.container-fluid').each do |node|
        node.replace(build_from_template('table', {classes: node['class'], contents: node.inner_html}))
      end
    end

    def grid
      @doc.css('.row').each do |node|
        node.replace(build_from_template('row', {classes: node['class'], contents: node.inner_html}))
      end
      @doc.css('*[class*=col]').each do |node|
        node.replace(build_from_template('col', {classes: node['class'], contents: node.inner_html}))
      end
    end

    def padding
      @doc.css('*[class*=p-], *[class*=pt-], *[class*=pr-], *[class*=pb-], *[class*=pl-], *[class*=px-], *[class*=py-]').each do |node|
        if node.name != 'table' # if it is already on a table, set the padding on the table, else wrap the content in a table
          padding_regex = /(p[trblxy]?-\d)/
          classes = node['class'].scan(padding_regex).join(' ')
          node['class'] = node['class'].sub(padding_regex, '')
          node.replace(build_from_template('table', {classes: classes, contents: node.to_html}))
        end
      end
    end

    def margin
      margins = %w( m mt mr mb ml mx my ).map{|m| (1..5).map{|i| ".#{m}-#{i}" }.join(',')}.join(',')
      puts "*************: #{margins}"
      @doc.css(margins).each do |node|
        if node.name != 'div' # if it is already on a div, set the margin on the div, else wrap the content in a div
          margin_regex = /(m[trblxy]?-\d)/
          classes = node['class'].scan(margin_regex).join(' ')
          node['class'] = node['class'].sub(margin_regex, '')
          node.replace(build_from_template('div', {classes: classes, contents: node.to_html}))
        end
      end
    end

    def table
      @doc.css('table').each do |node|
        #border="0" cellpadding="0" cellspacing="0"
        node['border'] = 0
        node['cellpadding'] = 0
        node['cellspacing'] = 0
      end
    end

  end
end

class MyRailtie < Rails::Railtie
  initializer 'my_railtie.configure_rails_initialization' do
    Premailer::Rails.config.merge!(adapter: :nokogiri, preserve_reset: false)
  end
end

require 'bootstrap-email/action_mailer'
require 'bootstrap-email/engine'
require 'bootstrap-email/version'
