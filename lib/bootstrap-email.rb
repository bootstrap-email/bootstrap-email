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
      @source = mail.html_part || mail
      update_doc(@source.body.raw_source)
    end

    def update_doc source
      @doc = Nokogiri::HTML(source)
    end

    def perform_full_compile
      compile_html!
      inline_css!
      inject_head!
      update_mailer!
    end

    def compile_html!
      button
      badge
      alert
      card
      hr
      container
      grid
      align
      padding
      margin
      spacer
      table
      body
    end

    def inline_css!
      @source.body = @doc.to_html
      @mail = Premailer::Rails::Hook.perform(@mail)
      @mail.header[:skip_premailer] = true
      update_doc(@mail.html_part.body.raw_source)
    end

    def inject_head!
      @doc.at_css('head').add_child(bootstrap_email_head)
    end

    def update_mailer!
      @mail.html_part.body = @doc.to_html
      @mail
    end

    private

    def bootstrap_email_head
      engine = defined?(SassC::Engine).nil? ? Sass::Engine : SassC::Engine
      html_string = <<-HEREDOC
        <style type="text/css">
          #{engine.new(File.open(File.expand_path('../core/head.scss', __dir__)).read, {syntax: :scss, style: :compressed, cache: false, read_cache: false}).render}
        </style>
      HEREDOC
      html_string
    end

    def template file, locals_hash = {}
      namespace = OpenStruct.new(locals_hash)
      template_html = File.open(File.expand_path("../core/templates/#{file}.html.erb", __dir__)).read
      ERB.new(template_html).result(namespace.instance_eval { binding })
    end

    def each_node css_lookup, &blk
      # sort by youngest child and traverse backwards up the tree
      @doc.css(css_lookup).sort_by{ |n| n.ancestors.size }.reverse!.each(&blk)
    end

    def button
      each_node('.btn') do |node| # move all classes up and remove all classes from the element
        node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.to_html))
      end
    end

    def badge
      each_node('.badge') do |node| # move all classes up and remove all classes from the element
        node.replace(template('table-left', classes: node['class'], contents: node.delete('class') && node.to_html))
      end
    end

    def alert
      each_node('.alert') do |node| # move all classes up and remove all classes from the element
        node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.to_html))
      end
    end

    def align
      each_node('.float-left') do |node|
        align_helper(node, /float-left/, 'left')
      end
      each_node('.mx-auto') do |node|
        align_helper(node, /mx-auto/, 'center')
      end
      each_node('.float-right') do |node|
        align_helper(node, /float-right/, 'right')
      end
    end

    def align_helper node, klass, template
      if node.name != 'table' # if it is already on a table, set the proprieties on the current table
        node['class'] = node['class'].sub(klass, '')
        node.replace(template("align-#{template}", contents: node.to_html))
      else
        node['align'] = template
      end
    end

    def card
      each_node('.card') do |node| # move all classes up and remove all classes from element
        node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.to_html))
      end
      each_node('.card-body') do |node| # move all classes up and remove all classes from element
        node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.to_html))
      end
    end

    def hr
      each_node('hr') do |node| # drop hr in place of current
        node.replace(template('hr', classes: "hr #{node['class']}"))
      end
    end

    def container
      each_node('.container') do |node|
        node.replace(template('container', classes: node['class'], contents: node.inner_html))
      end
      each_node('.container-fluid') do |node|
        node.replace(template('table', classes: node['class'], contents: node.inner_html))
      end
    end

    def grid
      each_node('.row') do |node|
        node.replace(template('row', classes: node['class'], contents: node.inner_html))
      end
      each_node('*[class*=col]') do |node|
        node.replace(template('col', classes: node['class'], contents: node.inner_html))
      end
    end

    def padding
      each_node('*[class*=p-], *[class*=pt-], *[class*=pr-], *[class*=pb-], *[class*=pl-], *[class*=px-], *[class*=py-]') do |node|
        if node.name != 'table' # if it is already on a table, set the padding on the table, else wrap the content in a table
          padding_regex = /(p[trblxy]?-\d)/
          classes = node['class'].scan(padding_regex).join(' ')
          node['class'] = node['class'].gsub(padding_regex, '')
          node.replace(template('table', classes: classes, contents: node.to_html))
        end
      end
    end

    def margin
      each_node('*[class*=my-], *[class*=mt-], *[class*=mb-]') do |node|
        top_class = node['class'][/m[ty]{1}-(lg-)?(\d)/]
        bottom_class = node['class'][/m[by]{1}-(lg-)?(\d)/]
        node['class'] = node['class'].gsub(/(m[tby]{1}-(lg-)?\d)/, '')
        html = ''
        if top_class
          html += template('div', classes: "s-#{top_class.gsub(/m[ty]{1}-/, '')}", contents: nil)
        end
        html += node.to_html
        if bottom_class
          html += template('div', classes: "s-#{bottom_class.gsub(/m[by]{1}-/, '')}", contents: nil)
        end
        node.replace(html)
      end
    end

    def spacer
      spacers = {
        '0' => 0,
        '1' => (16 * 0.25),
        '2' => (16 * 0.5),
        '3' => 16,
        '4' => (16 * 1.5),
        '5' => (16 * 3)
      }
      each_node('*[class*=s-]') do |node|
        temp = Nokogiri::HTML::DocumentFragment.parse(template('table', classes: node['class'] + ' w-100', contents: '&nbsp;'))
        temp.at_css('td')['height'] = spacers[node['class'].gsub(/s-/, '')].to_i
        node.replace(temp)
      end
    end

    def table
      @doc.css('table').each do |node|
        # border="0" cellpadding="0" cellspacing="0"
        node['border'] = 0
        node['cellpadding'] = 0
        node['cellspacing'] = 0
      end
    end

    def body
      @doc.css('body').each do |node|
        node.replace('<body>' + preview_text.to_s + template('body', classes: "#{node['class']} body", contents: node.inner_html.to_s) + '</body>')
      end
    end

    def preview_text
      preview_node = @doc.at_css('preview')
      if preview_node.present?
        # apply spacing after the text max of 100 characters so it doesn't show body text
        preview_node.content += '&nbsp;' * (100 - preview_node.content.length.to_i)
        node = template('div', classes: 'preview', contents: preview_node.content)
        preview_node.remove
        return node
      end
    end
  end
end

require 'bootstrap-email/premailer_railtie'
require 'bootstrap-email/action_mailer'
require 'bootstrap-email/engine'
require 'bootstrap-email/version'
