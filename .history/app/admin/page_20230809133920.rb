
ActiveAdmin.register Page do
    permit_params :title, :content
  
    form do |f|
      f.inputs do
        f.input :title
        f.input :content, as: :ckeditor
      end
      f.actions
    end
  end
  