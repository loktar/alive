class UnderscoreTemplate < Tilt::Template
  include ActionView::Helpers::JavaScriptHelper

  self.default_mime_type = 'application/javascript'
  self.engine_initialized = true

  def initialize_engine; end
  def prepare; end

  def evaluate(context, locals, &block)
    template_name = context.logical_path.gsub(/^templates\/(.*)$/, \\s).to_s
    @output = <<-JS
Alive.templates['#{template_name}'] = _.template("#{escape_javascript data}")
JS
  end
end
