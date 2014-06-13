class HtmlEditorGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def copy_files
    directory "ckeditor", File.join(name, "vendor/assets/javascripts/ckeditor")
  end

  def edit_application_js
    append_to_file File.join(name, "app/assets/javascripts/application.js"), "//= require ckeditor/ckeditor\n"
    append_to_file File.join(name, "app/assets/javascripts/application.js"), "//= require ckeditor/adapters/jquery\n"
  end
end
