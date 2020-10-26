module BootstrapEmail
  class Compiler
    HEAD_SCSS_PATH = File.expand_path('../../core/head.scss', __dir__)

    def initialize(type:, input:)
      case type
      when :rails
        html = add_layout!(input)
        @adapter = BootstrapEmail::RailsAdapter.new(html)
      when :string
        html = add_layout!(input)
        @adapter = BootstrapEmail::StringAdapter.new(html)
      when :file
        html = add_layout!(File.read(input))
        @adapter = BootstrapEmail::StringAdapter.new(html)
      end
    end

    def perform_full_compile
      compile_html!
      @adapter.inline_css!
      inject_head!
      @adapter.finalize_document!
    end

    def compile_html!
      as_table
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
      spacing
      spacer
      table
      body
      # color
    end

    def add_layout!(html)
      doc = Nokogiri::HTML(html)
      return unless doc.at_css('head').nil?

      namespace = OpenStruct.new(contents: ERB.new(doc.to_html).result)
      template_html = File.read(File.expand_path('../../core/layout.html.erb', __dir__))
      ERB.new(template_html).result(namespace.instance_eval { binding })
    end

    def inject_head!
      @adapter.doc.at_css('head').add_child(bootstrap_email_head)
    end

    private

    def bootstrap_email_head
      html_string = <<-INLINE
        <style type="text/css">
          #{purged_css_from_head}
        </style>
      INLINE
      html_string
    end

    def purged_css_from_head
      default, custom = BootstrapEmail::SassCache.compile(HEAD_SCSS_PATH).split('/*! allow_purge_after */')
      # get each CSS declaration
      custom.scan(/\w*\.[\w\-]*[\s\S\n]+?(?=})}{1}/).each do |group|
        # get the first class for each comma separated CSS declaration
        exist = group.scan(/(\.[\w\-]*).*?((,+?)|{+?)/).map(&:first).uniq.any? do |selector|
          !@adapter.doc.at_css(selector).nil?
        end
        custom.sub!(group, '') unless exist
      end
      (default + custom).gsub(/\n\s*\n+/, "\n")
    end

    def template(file, locals_hash = {})
      locals_hash[:classes] = locals_hash[:classes].split.join(' ') if locals_hash[:classes]
      namespace = OpenStruct.new(locals_hash)
      template_html = File.read(File.expand_path("../../core/templates/#{file}.html.erb", __dir__))
      ERB.new(template_html).result(namespace.instance_eval { binding })
    end

    def each_node(css_lookup, &blk)
      # sort by youngest child and traverse backwards up the tree
      @adapter.doc.css(css_lookup).sort_by { |n| n.ancestors.size }.reverse!.each(&blk)
    end

    def as_table
      each_node('.as-table') do |node|
        node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.inner_html))
      end
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
      ['left', 'center', 'right'].each do |type|
        each_node(".align-#{type}") do |node|
          align_helper(node, type)
        end
      end
    end

    def align_helper(node, type)
      if node.name != 'table' # if it is already on a table, set the proprieties on the current table
        node['class'] = node['class'].sub("align-#{type}", '')
        node = node.replace(template('table', classes: "align-#{type}", contents: node.to_html))[0]
      end
      node['align'] = type
    end

    def card
      each_node('.card') do |node| # move all classes up and remove all classes from element
        node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.inner_html))
      end
      each_node('.card-body') do |node| # move all classes up and remove all classes from element
        node.replace(template('table', classes: node['class'], contents: node.delete('class') && node.inner_html))
      end
    end

    def hr
      each_node('hr') do |node| # drop hr in place of current
        default_margin = node['class'].to_s.match?(/m[tby]{1}-(lg-)?\d+/) ? '' : 'my-5'
        node.replace(template('table', classes: "#{default_margin} hr #{node['class']}", contents: ''))
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
        next if ['table', 'td', 'a'].include?(node.name) # if it is already on a table, set the padding on the table, else wrap the content in a table

        padding_regex = /(p[trblxy]?-\d+)/
        classes = node['class'].scan(padding_regex).join(' ')
        node['class'] = node['class'].gsub(padding_regex, '')
        node.replace(template('table', classes: classes, contents: node.to_html))
      end
    end

    def margin
      each_node('*[class*=my-], *[class*=mt-], *[class*=mb-]') do |node|
        top_class = node['class'][/m[ty]{1}-(lg-)?(\d+)/]
        bottom_class = node['class'][/m[by]{1}-(lg-)?(\d+)/]
        node['class'] = node['class'].gsub(/(m[tby]{1}-(lg-)?\d+)/, '')
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

    def spacing
      each_node('*[class*=space-y-]') do |node|
        spacer = node['class'].scan(/space-y-((lg-)?\d+)/)[0][0]
        # get all direct children except the first
        node.xpath('./*[position()>1] | ./tbody/tr/td/*[position()>1]').each do |child|
          html = ''
          html += template('div', classes: "s-#{spacer}", contents: nil)
          html += child.to_html
          child.replace(html)
        end
      end
    end

    def spacer
      each_node('*[class*=s-]') do |node|
        node.replace(template('table', classes: "#{node['class']} w-full", contents: '&nbsp;'))
      end
    end

    def table
      @adapter.doc.css('table').each do |node|
        node['border'] = 0
        node['cellpadding'] = 0
        node['cellspacing'] = 0
      end
    end

    def body
      @adapter.doc.css('body').each do |node|
        node.replace('<body>' + preview_text.to_s + template('body', classes: "#{node['class']} body", contents: node.inner_html) + '</body>')
      end
    end

    def preview_text
      preview_node = @adapter.doc.at_css('preview')
      return if preview_node.nil?

      # apply spacing after the text max of 100 characters so it doesn't show body text
      preview_node.content += '&nbsp;' * [(100 - preview_node.content.length.to_i), 0].max
      node = template('div', classes: 'preview', contents: preview_node.content)
      preview_node.remove
      node
    end

    # def color
    #   each_node('*[class*=bg-]') do |node|
    #     next if ['table', 'td'].include?(node.name) # skip if it is already on a table

    #     background_color_regex = /(bg-\w*(-\d+)?)/
    #     classes = node['class'].scan(background_color_regex).map(&:first).join(' ')
    #     node['class'] = node['class'].gsub(background_color_regex, '')
    #     node.replace(template('table', classes: classes, contents: node.to_html))
    #   end
    # end
  end
end
