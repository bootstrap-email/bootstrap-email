require 'nokogiri'
require 'erb'
require 'ostruct'
require 'action_mailer'
require 'premailer'

module BootstrapEmail

  class << self
    def compile_html! mail
      @mail = mail
      doc = Nokogiri::HTML(@mail.body.raw_source)
      doc.css('.btn').each do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table-left', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
      doc.css('.badge').each do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table-left', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
      doc.css('.alert').each do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
      doc.css('.align-left').each do |node| # align table and move contents
        node.replace(build_from_template('align-left', {contents: node.to_html}))
      end
      doc.css('.align-center').each do |node| # align table and move contents
        node.replace(build_from_template('align-center', {contents: node.to_html}))
      end
      doc.css('.align-right').each do |node| # align table and move contents
        node.replace(build_from_template('align-right', {contents: node.to_html}))
      end
      doc.css('.card').each do |node| # move all classes up and remove all classes from element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
      doc.css('.card-body').each do |node| # move all classes up and remove all classes from element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
      doc.css('hr').each do |node| # drop hr in place of current
        node.replace(build_from_template('hr'))
      end
      doc.css('.container').each do |node|
        node.replace(build_from_template('container', {classes: node['class'], contents: node.inner_html}))
      end
      doc.css('.container-fluid').each do |node|
        node.replace(build_from_template('table', {classes: node['class'], contents: node.inner_html}))
      end
      doc.css('.row').each do |node|
        node.replace(build_from_template('row', {classes: node['class'], contents: node.inner_html}))
      end
      doc.css('*[class^=col]').each do |node|
        node.replace(build_from_template('col', {classes: node['class'], contents: node.inner_html}))
      end
      padding = %w( p- pt- pr- pb- pl- px- py- ).map{ |padding| "contains(@class, '#{padding}')" }.join(' or ')
      doc.xpath("//*[#{padding}]").each do |node|
        if node.name != 'table' # if it is already on a table, set the padding on the table, else wrap the content in a table
          node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
        end
      end
      margin = %w( m- mt- mr- mb- ml- mx- my- ).map{ |margin| "contains(@class, '#{margin}')" }.join(' or ')
      doc.xpath("//*[#{margin}]").each do |node|
        if node.name != 'div' # if it is already on a div, set the margin on the div, else wrap the content in a div
          node.replace(build_from_template('div', {classes: node['class'].scan(/(m[trblxy]?-\d)/).join(' '), contents: node.delete('class') && node.to_html}))
        end
      end
      doc.css('table').each do |node|
        #border="0" cellpadding="0" cellspacing="0"
        node['border'] = 0
        node['cellpadding'] = 0
        node['cellspacing'] = 0
      end
      @mail.body = doc.to_html
      @mail
    end

    def build_from_template template, locals_hash = {}
      namespace = OpenStruct.new(locals_hash)
      template = File.open(File.expand_path("../core/templates/#{template}.html.erb", __dir__)).read
      Nokogiri::HTML::DocumentFragment.parse(ERB.new(template).result(namespace.instance_eval { binding }))
    end
  end
end

require 'bootstrap-email/action_mailer'
require 'bootstrap-email/engine'
require 'bootstrap-email/version'
