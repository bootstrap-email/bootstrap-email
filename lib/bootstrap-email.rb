require 'nokogiri'
require 'erb'
require 'ostruct'
require 'action_mailer'
require 'premailer'
require 'premailer/rails'
require 'rails'

module BootstrapEmail
  class Compiler

    def initialize mail
      @mail = mail
      @doc = Nokogiri::HTML(@mail.body.raw_source)
    end

    def compile_html!
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
      spacer
      table
      body
    end

    def update_mailer!
      @mail.body = @doc.to_html
      @mail
    end

    private

    def build_from_template template, locals_hash = {}
      namespace = OpenStruct.new(locals_hash)
      template = File.open(File.expand_path("../core/templates/#{template}.html.erb", __dir__)).read
      ERB.new(template).result(namespace.instance_eval { binding })
    end

    def each_node css_lookup, &blk
      # sort by youngest child and traverse backwards up the tree
      @doc.css(css_lookup).sort_by{ |n| n.ancestors.size }.reverse!.each(&blk)
    end

    def button
      each_node('.btn') do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def badge
      each_node('.badge') do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table-left', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def alert
      each_node('.alert') do |node| # move all classes up and remove all classes from the element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def align
      each_node('.align-left, .float-left') do |node| # align table and move contents
        node['class'] = node['class'].sub(/(align-left)|(float-left)/, '')
        node.replace(build_from_template('align-left', {contents: node.to_html}))
      end
      each_node('.align-center') do |node| # align table and move contents
        node['class'] = node['class'].sub(/(align-center)|(mx-auto)/, '')
        node.replace(build_from_template('align-center', {contents: node.to_html}))
      end
      each_node('.align-right') do |node| # align table and move contents
        node['class'] = node['class'].sub(/(align-right)|(float-right)/, '')
        node.replace(build_from_template('align-right', {contents: node.to_html}))
      end
    end

    def card
      each_node('.card') do |node| # move all classes up and remove all classes from element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
      each_node('.card-body') do |node| # move all classes up and remove all classes from element
        node.replace(build_from_template('table', {classes: node['class'], contents: node.delete('class') && node.to_html}))
      end
    end

    def hr
      each_node('hr') do |node| # drop hr in place of current
        node.replace(build_from_template('hr', {classes: "hr #{node['class']}"}))
      end
    end

    def container
      each_node('.container') do |node|
        node.replace(build_from_template('container', {classes: node['class'], contents: node.inner_html}))
      end
      each_node('.container-fluid') do |node|
        node.replace(build_from_template('table', {classes: node['class'], contents: node.inner_html}))
      end
    end

    def grid
      each_node('.row') do |node|
        node.replace(build_from_template('row', {classes: node['class'], contents: node.inner_html}))
      end
      each_node('*[class*=col]') do |node|
        node.replace(build_from_template('col', {classes: node['class'], contents: node.inner_html}))
      end
    end

    def padding
      each_node('*[class*=p-], *[class*=pt-], *[class*=pr-], *[class*=pb-], *[class*=pl-], *[class*=px-], *[class*=py-]') do |node|
        if node.name != 'table' # if it is already on a table, set the padding on the table, else wrap the content in a table
          padding_regex = /(p[trblxy]?-\d)/
          classes = node['class'].scan(padding_regex).join(' ')
          node['class'] = node['class'].gsub(padding_regex, '')
          node.replace(build_from_template('table', {classes: classes, contents: node.to_html}))
        end
      end
    end

    def margin
      each_node('*[class*=m-], *[class*=mt-], *[class*=mb-]') do |node|
        top_class = node['class'][/m[ty]{1}-(lg-)?(\d)/]
        bottom_class = node['class'][/m[by]{1}-(lg-)?(\d)/]
        node['class'] = node['class'].gsub(/(m[tby]{1}-(lg-)?\d)/, '')
        html = ''
        if top_class
          html += build_from_template('div', {classes: "s-#{top_class.gsub(/m[ty]?-/, '')}", contents: nil})
        end
        html += node.to_html
        if bottom_class
          html += build_from_template('div', {classes: "s-#{bottom_class.gsub(/m[by]?-/, '')}", contents: nil})
        end
        node.replace(html)
      end
    end

    def spacer
      each_node('*[class*=s-]') do |node|
        node.replace(build_from_template('table', {classes: node['class'] + ' w-100', contents: "&#xA0;"}))
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

    def body
      @doc.css('body').each do |node|
        node.replace( '<body>' + build_from_template('table', {classes: "#{node['class']} body", contents: "#{node.inner_html}"}) + '</body>' )
      end
    end

  end
end

require 'bootstrap-email/premailer_railtie'
require 'bootstrap-email/action_mailer'
require 'bootstrap-email/engine'
require 'bootstrap-email/version'
